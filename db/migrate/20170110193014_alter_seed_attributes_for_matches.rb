class AlterSeedAttributesForMatches < ActiveRecord::Migration
  change_table :teams do |t|
    t.rename :seed, :og_seed
    t.integer :prog_seed
  end
end
