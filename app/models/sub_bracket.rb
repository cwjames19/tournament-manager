class SubBracket < ActiveRecord::Base
  attr_accessor :round_counter
  
  belongs_to :tournaments
  
  def increment_round_counter
    self.sub_bracket_number += 1
  end
end
