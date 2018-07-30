module MacroTranspile
  module Functions
    private def transpile(method : Crystal::Def)
      CURRENT_CONTEXT.push({symbol: :def, node: method})
      @@log.debug("Def: #{method.name}, #{method.args}")

      name = method.name

      @@functions[name.to_s] = method

      args = method.args.map_with_index do |arg, i|
        %(
          #{arg.name} = @#{name.to_s}_args[#{i}]
        ).as(String)
      end

      cr_code = %(
        @#{name}_args = [] of String
        #{args.join("\n")}
      )
      CURRENT_CONTEXT.pop
      %(
// #{name}.txt
// def #{name} (#{method.args.join(", ")})
  #{parse(cr_code)}
  #{transpile method.body}
// end
)
    end

    private def transpile(call : Crystal::Call)
      @@log.debug("Call: #{call.name}, #{call.args}")

      method = call.name

      @@log.debug "#{call.obj} : #{call.obj.class}"

      case call.name
      when "+", "-", "*", "/", "<", ">", "=="
        obj = call.obj
        arg = call.args[0]

        obj = transpile call.obj if call.obj.class == Crystal::InstanceVar || call.obj.class == Crystal::Var
        arg = transpile call.args[0] if call.args[0].class == Crystal::InstanceVar || call.args[0].class == Crystal::Var
        "#{obj} #{call.name} #{arg}"
      when "[]"
        obj = call.obj
        arg = call.args[0]

        obj = transpile call.obj if call.obj.class == Crystal::InstanceVar || call.obj.class == Crystal::Var
        arg = transpile call.args[0] if call.args[0].class == Crystal::InstanceVar || call.args[0].class == Crystal::Var

        # args.map do |arg|
        #   arg = transpile arg if arg == Crystal::InstanceVar || arg == Crystal::Var
        # end

        obj.to_s.sub /\[\]/, "[#{arg}]"
        # obj.to_s + "[#{arg}]"
      else
        if @@functions[method.to_s]?
          args = call.args.map_with_index do |arg, i|
            arg = transpile arg if arg == Crystal::InstanceVar || arg == Crystal::Var
            arg
          end

          method_arguments = "#{method}_args = [#{args.join(",")}]"

          "
// #{method} (#{args.join(", ")})
  #{method_arguments}
  $$<#{method}.txt>
  "
        else
          args = transpile call.args

          if call.obj
            method = "#{call.obj}.#{method}"
          end

          "#{method.upcase}(#{args.join(", ")});"
        end
      end
    end
  end
end
