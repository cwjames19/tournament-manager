class ChangeDetailsOnMatch < ActiveRecord::Migration
  change_table :matches do |t|
    t.remove :round, :integer
    t.references :round
  end
end
