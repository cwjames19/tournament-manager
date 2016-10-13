class ChangeTypeOfColumnInTournaments < ActiveRecord::Migration
  change_table :tournaments do |t|
    t.change :team_names, :text
    t.change :team_seeds, :text
  end
end
