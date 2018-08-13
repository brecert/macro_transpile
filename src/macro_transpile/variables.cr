module MacroTranspile
  module Variables
    # private def transpile(node : Crystal::Alias)
    #   assign(node.name.to_s, node.as(Crystal::ASTNode))
    #   "#{node.name}"
    # end

    private def transpile(node : Crystal::TypeDeclaration)
      @@log.debug "TypeDeclaration: #{node.declared_type}"
      assign(node.var.to_s, node.declared_type)
      ""
    end

    private def transpile(node : Crystal::Assign)
      @@log.debug "Assign #{node.target.to_s} : #{node.target.class}, #{node.value.to_s}  : #{node.value.class}"
      assign(node.target.to_s, node.value)
      @@config[:assign] % {target: variable(node.target), value: transpile(node.value).to_s, type: ""}
    end

    # Initial Variable, first time seen
    private def transpile(node : AST::InitialVar)
      "#{variable node}"
    end

    # Every Time After Init.
    private def transpile(node : Crystal::Var)
      "%#{variable node}%"
    end

    private def transpile(node : AST::InitialInstanceVar)
      "A @#{variable node}"
    end

    # Global @
    private def transpile(node : Crystal::InstanceVar)
      # "#{transpile Crystal::Self.new}." + transpile(node.to_s.sub(/^@/, ""))
      "%#{variable node}%"
    end

    private def assign(target : String, value : Crystal::ASTNode)
      @@variables[target] = value
    end

    private def get(target : String)
      @@variables[target]
    end

    private def variable(node)
      @@log.debug "Typed: #{node.to_s} #{get(node.to_s).class}"

      name = node.to_s

      value = IO::Memory.new
      # Dirty hack to remove @ from globals and reinsert it correctly in the mkb variable.
      if name.starts_with? '@'
        name = name.to_s.sub(/^@/, "")
        value << '@'
      end

      case get(node.to_s)
      when Crystal::NumberLiteral, Number
        value << '#' << name
      when Crystal::StringLiteral, String
        value << '&' << name
      when Crystal::BoolLiteral, Bool
        value << name
      when Crystal::ArrayLiteral, Array
        value << '&' << name << "[]"
        # when Crystal::Call
        #   case node
        #   when Crystal::Var
        #     value << "VAR: #{node.to_s}"
        #   else
        #     value << "VAR2: #{node.to_s}"
        #   end
      else
        value << '&' << name
      end
      value
      # get(node.to_s)
    end
  end
end
