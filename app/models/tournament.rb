class Tournament < ActiveRecord::Base
  # ( IF YOU ENABLE ME, I WILL BREAK THE TOURNAMENT#NEW FORM AND WILL NOT PERSIST
  # EXTRA_GAME_OPTION, MAYBE MORE. ATTR_ACCESSOR IS THE PRIMARY CULPRIT)
  # attr_reader :extra_game_option
  # attr_accessor :game_counter, :sub_bracket_counter, :extra_game_option
  
  belongs_to :user
  has_many :matches
  has_many :teams
  has_many :sub_brackets
  has_many :rounds
  
  # validates :name, presence: true, length: {minimum: 3, maximum: 40}, uniqueness: {scope: :user}
  # # validates :extra_game_option, presence: true, inclusion: { in: [0, 1, 2]}
  # # validates :num_teams, presence: true, numericality: {only_integer: true}
  
  enum tournament_type: {
    single_elimination: 0
  }
  enum extra_game_option: {
    no_extra_games: 0,
    bronze_medal_game: 1,
    play_to_all_places: 2
  }
  
  private
  
  
  
end
