class ChangeDetailsOnSubBrackets < ActiveRecord::Migration
  change_table :sub_brackets do |t|
    t.remove :tournament_id, :references
    t.remove :tournament_id_id, :references
  end
end
