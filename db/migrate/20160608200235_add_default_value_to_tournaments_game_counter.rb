class AddDefaultValueToTournamentsGameCounter < ActiveRecord::Migration
  change_column_default(:tournaments, :game_counter,  1)
end
