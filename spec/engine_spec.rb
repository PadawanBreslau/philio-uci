require 'spec_helper'

describe PhilioUCI::Engine do
  context 'initializing engine' do

    it 'should initialize engine with proper parameters' do
      en_path = '/usr/games/stockfish'
      options = {:engine_path => en_path , :movetime => 200}
      expect{@engine = PhilioUCI::Engine.new(options)}.not_to raise_error
      @engine.engine_path.should eql en_path
      @engine.movetime.should eql 200
    end

    it 'should initialize engine with default parameters' do
      en_path = '/usr/games/stockfish'
      options = {:engine_path => en_path}
      expect{@engine = PhilioUCI::Engine.new(options)}.not_to raise_error
      @engine.engine_path.should eql en_path
      @engine.movetime.should eql 10
    end

    it 'should raise error if engine path not given' do
      options = {}
      expect{PhilioUCI::Engine.new(options)}.to raise_error(PhilioUCI::InvalidEngineOptionException)
    end

    it 'should raise error if engine not present in location' do
      en_path = '/usr/games/swordfish'
      options = {:engine_path => en_path}
      expect{PhilioUCI::Engine.new(options)}.to raise_error(PhilioUCI::InvalidEngineOptionException)
    end

    it 'should connect to engine and establish input and output' do
      en_path = '/usr/games/stockfish'
      options = {:engine_path => '/usr/games/stockfish'}
      expect{@engine = PhilioUCI::Engine.new(options)}.not_to raise_error
      @engine.output.should_not be_nil
      @engine.input.should_not be_nil
    end

  end

  context 'prior communication with engine' do
    before do
      options = {:engine_path => '/usr/games/stockfish' , :movetime => 200}
      @engine = PhilioUCI::Engine.new(options)
    end

    it 'should be able to send command to engine and receive response' do
      #RACE PROBLEM
      @engine.send_command('uci')
      sleep(1)
      @response = @engine.send_command('uci')
      @engine.input.should_not be_nil
      @response.last.strip.should eql 'uciok'
      @engine.send_command('isready')
      sleep(1)
      @response = @engine.send_command('isready')
      @engine.input.should_not be_nil
      @response.last.strip.should eql 'readyok'
    end

    it 'should be able to send options to engine' do
      expect{@engine.send_command('uci')}.not_to raise_error
      expect{@response = @engine.send_engine_option('Ponder', 'true')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_true
    end

  end

  context 'other calls' do
    before do
      options = {:engine_path => '/usr/games/stockfish'}
      @engine = PhilioUCI::Engine.new(options)
      expect{@engine.send_command('uci')}.not_to raise_error
    end

    it 'should be able to send other comamnds' do
      expect{@response = @engine.send_command('ucinewgame')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_true

      expect{@response = @engine.send_command('position', 'startpos')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_true

      expect{@response = @engine.send_command('go', 'ponder')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_kind_of Array

      expect{@response = @engine.send_command('stop')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_kind_of Array

      expect{@response = @engine.send_command('go', 'searchmoves', 'e2e4', 'd2d4')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_kind_of Array

      expect{@response = @engine.send_command('stop')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_kind_of Array

      expect{@response = @engine.send_command('go', 'depth', '5')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_kind_of Array

      expect{@response = @engine.send_command('stop')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_kind_of Array

      expect{@response = @engine.send_command('go', 'movetime', '5000')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_kind_of Array

      expect{@response = @engine.send_command('stop')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_kind_of Array

      expect{@response = @engine.send_command('go', 'infinite')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_kind_of Array

      sleep 5

      expect{@response = @engine.send_command('stop')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_kind_of Array

    end
  end
end
