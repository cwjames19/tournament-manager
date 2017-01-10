class AlterSeedAttributesForMatchesAgain < ActiveRecord::Migration
  change_table :matches do |t|
    t.integer :required_seed_home
    t.integer :required_seed_visitor
    t.integer :required_seeds
  end
  
  change_table :teams do |t|
    t.rename :current_wlr, :prog_wlr
  end
end
