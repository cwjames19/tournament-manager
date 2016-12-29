class RemoveNumRoundsFromSubBracket < ActiveRecord::Migration
  change_table :sub_brackets do |t|
    t.remove :num_rounds, :integer
  end
end
