require 'open3'
require 'io/wait'

module PhilioUCI
  class Engine
    VALID_COMMANDS = %w(uci isready ucinewgame position go stop)
    VALID_OPTIONS = %w(Ponder MultiPV)

    attr_reader :engine_path, :movetime, :output, :input

    def initialize(options)
      raise InvalidEngineOptionException unless options[:engine_path]
      @engine_path = options[:engine_path]
      @movetime = options[:movetime] || 10
      @engine_reconnection = options[:reconnections] || 3
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
      reconnections = @engine_reconnection
      begin
        @output.puts(command.concat(' ' + args.join(' ')))
      rescue Errno::EPIPE
        @output, @input = establish_connection_with_engine
        sleep(1)
        retry unless (reconnections -= 1).zero?
      end
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
