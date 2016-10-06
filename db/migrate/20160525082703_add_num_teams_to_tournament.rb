class AddNumTeamsToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :num_teams, :integer
  end
end
