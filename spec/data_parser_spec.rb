require 'spec_helper'

describe PhilioUCI::DataParser do
  it 'shoud properly parse eval string' do
    eval_string = 'info score cp 20  depth 3 nodes 423 time 15 pv f1c4 g8f6 b1c3'
    result = PhilioUCI::DataParser.parse_eval_string(eval_string)
    expect(result[:depth]).to eq 3
    expect(result[:score]).to eq 0.2
    expect(result[:time]).to eq 0.015
    expect(result[:variation]).to eq 'f1c4 g8f6 b1c3'
  end
end
