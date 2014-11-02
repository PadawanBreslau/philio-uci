module PhilioUCI
  class DataParser
    def self.parse_eval_string(evaluation)
      result = Hash.new
      splited_eval = evaluation.split(' ')
      depth_index = splited_eval.index('depth')
      result[:depth] = splited_eval[depth_index+1] if depth_index
      score_index = splited_eval.index('score')
      result[:score] = splited_eval[score_index+2].to_i/100.0 if score_index
      time_index = splited_eval.index('time')
      result[:time] = splited_eval[time_index+1].to_i/1000.0 if time_index
      pv_index = splited_eval.index('pv')
      result[:variation] = splited_eval[pv_index+1..-1].join(' ')
      result
    end
  end
end
