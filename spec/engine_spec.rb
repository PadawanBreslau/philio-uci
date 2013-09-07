require 'spec_helper'

describe Engine do
  context 'initializing engine' do

    it 'should initialize engine with proper parameters' do
      en_path = '/usr/games/stockfish'
      options = {:engine_path => en_path , :movetime => 200}
      expect{@engine = Engine.new(options)}.not_to raise_error
      @engine.engine_path.should eql en_path
      @engine.movetime.should eql 200
    end

    it 'should initialize engine with default parameters' do
      en_path = '/usr/games/stockfish'
      options = {:engine_path => en_path}
      expect{@engine = Engine.new(options)}.not_to raise_error
      @engine.engine_path.should eql en_path
      @engine.movetime.should eql 100
    end

    it 'should raise error if engine path not given' do
      options = {}
      expect{Engine.new(options)}.to raise_error(InvalidEngineOptionException)
    end

    it 'should raise error if engine not present in location' do
      en_path = '/usr/games/swordfish'
      options = {:engine_path => en_path}
      expect{Engine.new(options)}.to raise_error(InvalidEngineOptionException)
    end

    it 'should connect to engine and establish input and output' do
      en_path = '/usr/games/stockfish'
      options = {:engine_path => '/usr/games/stockfish'}
      expect{@engine = Engine.new(options)}.not_to raise_error
      @engine.output.should_not be_nil
      @engine.input.should_not be_nil
    end

  end

  context 'prior communication with engine' do
    before do
      options = {:engine_path => '/usr/games/stockfish'}
      @engine = Engine.new(options)
    end

    it 'should be able to send command to engine and receive response' do
      expect{@response = @engine.send_command('uci')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should eql 'uciok'
# 	  expect{@response = @engine.send_command('debug', 'on')}.not_to raise_error
#  	  @engine.input.should_not be_nil
#  	  @response.should eql 'uciok'
      expect{@response = @engine.send_command('isready')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should eql 'readyok'
    end

    it 'should be able to send options to engine' do
      expect{@engine.send_command('uci')}.not_to raise_error
      expect{@response = @engine.send_engine_option('Ponder', 'true')}.not_to raise_error
      @engine.input.should_not be_nil
      @response.should be_true
    end

  end
end
