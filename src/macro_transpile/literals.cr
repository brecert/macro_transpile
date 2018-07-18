module MacroTranspile
  module Literals
    private def transpile(node : Crystal::ArrayLiteral)
      elements = transpile(node.elements).join(", ")
      @@log.debug "ArrayLiteral: #{elements}"

      array_type = node.of
      "[#{elements}]"
    end

    private def transpile(node : Crystal::MagicConstant)
      "%#{node}%"
    end

    private def transpile(node : Crystal::Path)
      "%#{node}%"
    end
  end
end
