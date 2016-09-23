class Match < ActiveRecord::Base
  belongs_to :tournament
  has_and_belongs_to_many :teams
  
  before_save :assign_match_num
  
  def assign_match_num
    self.num = self.tournament.game_counter
    increment_game_counter
  end
  
  def increment_game_counter
    self.tournament.increment!(:game_counter)
  end
  
end
