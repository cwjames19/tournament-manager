class Tournament < ActiveRecord::Base
    belongs_to :user
    has_many :matches
    has_many :teams
    
    enum tournament_type: [:single_elimination]
    enum extra_game_options: [:no_extra_games, :bronze_medal_game, :play_to_all_places]
end
