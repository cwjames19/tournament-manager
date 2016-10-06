class AddGameCounterToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :game_counter, :integer
  end
end
