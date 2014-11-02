require 'open3'
require 'io/wait'

module PhilioUCI
  class Engine
    VALID_COMMANDS = %w(uci isready ucinewgame position go stop)
    VALID_OPTIONS = %w(Ponder)

    attr_reader :engine_path, :movetime, :output, :input

    def initialize(options)
      raise InvalidEngineOptionException unless options[:engine_path]
      @engine_path = options[:engine_path]
      @movetime = options[:movetime] || 10
      @output, @input = establish_connection_with_engine
    end

    def establish_connection_with_engine
      begin
        Open3.popen2e(@engine_path)
      rescue Errno::ENOENT
        raise InvalidEngineOptionException.new("Not a proper engine path")
      end
    end

    def send_command(command, *args)
      raise InvalidEngineCallException.new("Not a supported call: #{command}") unless VALID_COMMANDS.include?(command)
      @output.puts(command.concat(' ' + args.join(' ')))
      engine_response
    end

    def send_engine_option(option, value)
      raise InvalidEngineCallException.new("Not a supported option: #{option}") unless VALID_OPTIONS.include?(option)
      command = "setoption name #{option} "
      command.concat "value #{value}" if value
      @output.puts(command)
      true
    end

    def engine_response
      total_output = Array.new
      while(@input.ready?)
        @input.readline.tap do |line|
           total_output << line
        end
      end
      total_output
    end
  end

  class InvalidEngineOptionException < Exception;end

  class InvalidEngineCallException < Exception;end
end
