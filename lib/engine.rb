require 'open3'

class Engine
  VALID_COMMANDS = %w()
  VALID_OPTIONS = %w()

  attr_reader :engine_path, :movetime

  def initialize(options)
    raise InvalidEngineOptionException unless options[:engine_path]
    @engine_path = options[:engine_path]
    @movetime = options[:movetime] || 100

    @output, @input = establish_connection_with_engine
  end

  def establish_connection_with_engine
	begin
	  Open3.popen2e(@engine_path)
	rescue Errno::ENOENT
	  raise InvalidEngineOptionException.new("Nat a proper engine path")
	end
  end

  def send_command(command, parameters={})
	raise InvalidEngineCallException.new("Not a supported call: #{command}") unless VALID_COMMANDS.include?(command)
  end

  def send_engine_option(option, value)
	raise InvalidEngineCallException.new("Not a supported option: #{option}") unless VALID_OPTIONS.include?(options)
  end
end

class InvalidEngineOptionException < Exception;end
class InvalidEngineCallException < Exception;end
