class ChangeDetailsOfSubBrackets < ActiveRecord::Migration
  change_table :sub_brackets do |t|
    t.rename :rounds, :num_rounds
  end
end
