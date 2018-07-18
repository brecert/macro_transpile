module MacroTranspile
  module Conditionals
    private def conditional(node : Crystal::Var)
      "%#{typed node}#{node.to_s}%"
    end

    private def transpile(node : Crystal::If)
      @@log.debug "If: #{node} #{node.cond}"
      cond = node.cond
      case node
      when Crystal::Unless
        cond = "!#{cond}"
      end

      statement = transpile(cond)

      # statement = transpile(cond).eacb do |item|
      #   if item == Crystal::Var
      #     transpile item
      #   else
      #     item.to_s
      #   end
      # end

      code = format_body %[IF("#{statement}");
#{format_body(node.then)}
]
      case node.else
      when Crystal::Nop
      when Crystal::If
        code += "ELSE;\n #{transpile(node.else)}\n"
      else
        code += "ELSE;\n #{format_body(node.else)}\n"
      end
      code += "ENDIF;"
    end
  end
end
