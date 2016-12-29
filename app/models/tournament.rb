class Tournament < ActiveRecord::Base
  # include ActiveModel::Validations
  # (IF YOU ENABLE ME, I WILL BREAK THE TOURNAMENT#NEW FORM AND WILL NOT PERSIST
  # EXTRA_GAME_OPTION, MAYBE MORE. ATTR_ACCESSOR IS THE CULPRIT DUE TO OVERRIDING ENUM)
  serialize :team_names, Array
  serialize :team_seeds, Array

  belongs_to :user
  has_many :matches
  has_many :teams
  has_many :sub_brackets
  has_many :rounds, through: :sub_brackets
  
  validates :name, presence: true, length: {in: 3..45}, uniqueness: {scope: :user}
  validates :user_id, presence: true
  validates :extra_game_option, presence: true
  validates :num_teams, presence: true, numericality: true
  validates :team_names, presence: true, team_names: true
  validates :team_seeds, team_seeds: true
  validates :public, presence: true

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
