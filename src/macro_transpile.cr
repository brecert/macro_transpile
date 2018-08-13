require "compiler/crystal/syntax/virtual_file.cr"
require "compiler/crystal/syntax/exception.cr"
require "compiler/crystal/syntax/parser.cr"
require "logger"

require "./macro_transpile/*"

module MacroTranspile
  include MacroTranspile::Core
  include MacroTranspile::Expressions
  include MacroTranspile::Literals
  include MacroTranspile::Variables
  include MacroTranspile::Functions
  include MacroTranspile::Loops
  include MacroTranspile::Conditionals
  include MacroTranspile::TemplateString
  include MacroTranspile::Formatting
  extend self

  @@log = Logger.new(STDOUT)
  @@log.level = Logger::INFO

  @@log.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    label = severity.unknown? ? "ANY" : severity.to_s
    io << label.rjust(5) << progname << ": " << message
  end

  def log
    @@log
  end

  @@config = {
    assign: "%{type}%{target} = %{value};",
  }

  @@variables = Hash(String, Crystal::ASTNode).new
  @@functions = Hash(String, Crystal::ASTNode).new

  def parse(crystal_source_code)
    parser = Crystal::Parser.new(crystal_source_code)
    node = Crystal::Expressions.from(parser.parse)
    result = ""
    result += transpile(node).strip
    result
  end

  CURRENT_CONTEXT = Array(NamedTuple(symbol: Symbol, node: Crystal::ASTNode)).new

  CONTEXTS = [:top]

  private def context(context, &blk)
    CONTEXTS.push context
    result = yield
    CONTEXTS.pop
    result
  end

  private def context?(context)
    CONTEXTS.last == context
  end
end
