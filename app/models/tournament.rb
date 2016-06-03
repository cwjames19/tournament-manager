class Tournament < ActiveRecord::Base
    belongs_to :user
    has_many :matches
    has_many :teams
    
    validates :name, presence: true, length: {maximum: 40}, uniqueness: {scope: :user}
    validates :tournament_type, presence: true, inclusion: { in: ["single_elimination"]}
    validates :extra_game_option, presence: true, inclusion: { in: [0, 1, 2]}
    validates :num_teams, presence: true, numericality: {only_integer: true}
    
    enum tournament_type: [:single_elimination]
    enum extra_game_options: [:no_extra_games, :bronze_medal_game, :play_to_all_places]
end
