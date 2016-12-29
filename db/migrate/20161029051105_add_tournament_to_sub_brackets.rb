class AddTournamentToSubBrackets < ActiveRecord::Migration
  change_table :sub_brackets do |t|
    t.references :tournament
  end
end
