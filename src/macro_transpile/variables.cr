module MacroTranspile
  module Variables
    # private def transpile(node : Crystal::Alias)
    #   assign(node.name.to_s, node.as(Crystal::ASTNode))
    #   "#{node.name}"
    # end

    private def transpile(node : Crystal::TypeDeclaration)
      @@log.debug "#{node.declared_type}"
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
      if name.starts_with? '@'
        name = name.to_s.sub(/^@/, "")
        value << '@'
      end

      if get(node.to_s).class == Crystal::NumberLiteral
        value << '#' << name
      elsif get(node.to_s).class == Crystal::StringLiteral
        value << '&' << name
      elsif get(node.to_s).class == Crystal::BoolLiteral
        value << name
      elsif get(node.to_s).class == Crystal::ArrayLiteral
        value << '&' << name << "[]"
      else
        value << '&' << name
      end
      value
      # get(node.to_s)
    end
  end
end
