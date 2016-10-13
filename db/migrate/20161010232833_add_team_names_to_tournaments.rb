class AddTeamNamesToTournaments < ActiveRecord::Migration
  change_table :tournaments do |t|
    t.string :team_names
    t.integer :team_seeds
    t.remove :teams_raw
  end
end
