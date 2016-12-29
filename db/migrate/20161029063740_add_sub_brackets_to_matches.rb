class AddSubBracketsToMatches < ActiveRecord::Migration
  change_table :matches do |t|
    t.references :sub_bracket
  end
end
