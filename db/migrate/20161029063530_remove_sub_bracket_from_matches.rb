class RemoveSubBracketFromMatches < ActiveRecord::Migration
  change_table :matches do |t|
    t.remove :sub_bracket
  end
end
