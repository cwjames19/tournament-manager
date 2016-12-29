class ChangeDetailsOnRounds < ActiveRecord::Migration
  change_table :rounds do |t|
    t.remove :tournaments, :references
    t.remove :tournaments_id, :references
    t.remove :sub_brackets, :references
    t.remove :sub_brackets_id, :references
    t.references :tournament
    t.references :sub_bracket
  end
end
