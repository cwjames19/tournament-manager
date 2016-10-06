class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.references :tournaments, index: true, foreign_key: true
      t.references :sub_brackets, index: true, foreign_key: true
      t.integer :num

      t.timestamps null: false
    end
  end
end
