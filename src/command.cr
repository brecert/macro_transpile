require "./macro_transpile"
require "file"
require "option_parser"

class MacroTranspile::Command
  USAGE = <<-USAGE
  Usage: macr [command] [switches] [program file] [--] [arguments]
  Command:
      init                     generate a new project
      transpile                transpile crystal code to a mkb script
      help, --help, -h         show this help
      version, --version, -v   show version
  USAGE

  def self.run(options = ARGV)
    new(options).run
  end

  private getter options

  def initialize(@options : Array(String))
    @color = true
  end

  def run
    command = options.first?
    case
    when !command
      puts USAGE
      exit
    when "init".starts_with?(command)
      puts "Oops not finished.."
    when "transpile".starts_with?(command)
      options.shift
      transpile
    end
  end

  private def transpile
    command = "transpile"

    filenames = [] of String
    opt_filenames = nil
    opt_arguments = nil
    opt_output_filename = nil
    specified_output = false

    transpiler = MacroTranspile

    option_parser = OptionParser.parse(options) do |opts|
      opts.banner = "Usage: macr #{command} [options] [program file] [--] [arguments]\n\nOptions:"

      # opts.on("-d", "--debug", "Print debug info") do
      #   transpiler.log_level = Logger::Debug
      # end

      opts.on("-o ", "Output filename") do |an_output_filename|
        opt_output_filename = an_output_filename
        specified_output = true
      end

      opts.unknown_args do |before, after|
        opt_filenames = before
        opt_arguments = after
      end
    end

    output_filename = opt_output_filename.not_nil!
    filenames += opt_filenames.not_nil!
    arguments = opt_arguments.not_nil!

    if filenames.size > 1
      arguments = filenames[1..-1] + arguments
      filenames = [filenames[0]]
    end

    if filenames.size == 0
      STDERR.puts option_parser
      exit 1
    end

    if Dir.exists?(output_filename)
      error "can't use `#{output_filename}` as output filename because it's a directory"
    end

    puts output_filename, filenames, arguments

    input = filenames[0]
    output output_filename, transpiler.parse(File.read(input))
  end

  private def output(file, content)
    File.write file, content
  end

  private def error(msg, exit_code = 1)
    @color = false if ARGV.includes?("--no-color")
    Crystal.error msg, @color, exit_code: exit_code
  end
end

MacroTranspile::Command.run
