module MacroTranspile
  module Loops
    private def transpile(node : Crystal::While)
      cond = transpile node.cond

      "WHILE(#{cond});
#{format_body(node.body)}
ENDIF;"
    end

    private def transpile(node : Crystal::Next)
      "next"
    end
  end
end
