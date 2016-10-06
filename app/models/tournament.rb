class Tournament < ActiveRecord::Base
  attr_accessor :game_counter, :sub_bracket_counter
  
  belongs_to :user
  has_many :matches
  has_many :teams
  has_many :sub_brackets
  has_many :rounds
  
  # validates :name, presence: true, length: {maximum: 40}, uniqueness: {scope: :user}
  # validates :extra_game_option, presence: true, inclusion: { in: [0, 1, 2]}
  # validates :num_teams, presence: true, numericality: {only_integer: true}
  
  enum tournament_type: [:single_elimination]
  enum extra_game_options: [:no_extra_games, :bronze_medal_game, :play_to_all_places]
  
  private
  
  
  
  # def increment_sub_bracket_counter
  #   self.increment!(:sub_bracket_counter)
  # end
  
  # def increment_game_counter
  #   self.increment!(:game_counter)
  # end
end
