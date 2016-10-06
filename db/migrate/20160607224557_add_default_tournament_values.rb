class AddDefaultTournamentValues < ActiveRecord::Migration
  change_column_default(:tournaments, :extra_game_option, "no_extra_games")
  change_column_default(:tournaments, :tournament_type, "single_elimination")
end
