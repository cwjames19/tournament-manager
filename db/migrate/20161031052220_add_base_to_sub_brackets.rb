class AddBaseToSubBrackets < ActiveRecord::Migration
  change_table :sub_brackets do |t|
    t.string :base
  end
end
