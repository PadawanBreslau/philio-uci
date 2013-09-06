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
      en_path = '/usr/games/swordfidh'
      options = {:engine_path => en_path}
      expect{Engine.new(options)}.to raise_error(InvalidEngineOptionException)
    end


  end
end