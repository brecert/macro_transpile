module MacroTranspile
  module Core
    private def transpile(node : String)
      @@log.debug "String: #{node}"
      node
    end

    private def transpile(node : Crystal::ASTNode)
      # log_fallback_usage(node)
      @@log.debug "ASTNode: #{node}, #{node.class}"
      node.to_s
    end

    private def transpile(nodes : Array(Crystal::ASTNode) | Nil)
      puts "Array(ASTNode) | Nil: #{nodes}"
      case nodes
      when Nil
        [] of String
      else
        nodes.map do |node|
          transpile node
        end
      end
    end

    private def transpile(node : Crystal::Nop)
      @@log.debug "Nop: ''"
      ""
    end

    # private def transpile(node : Crystal::Return)
    #   if node.exp && CURRENT_CONTEXT.last[:symbol] == :def
    #     "&#{CURRENT_CONTEXT.last[:node]}_result = #{transpile node.exp};"
    #   else
    #     "a"
    #   end
    # end
  end
end
