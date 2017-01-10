class ChangeRequiredSeedsToTextType < ActiveRecord::Migration
  change_table :matches do |t|
    t.remove :required_seeds
    t.text :required_seeds
  end
end
