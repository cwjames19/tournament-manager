class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :image
      t.integer :seed
      t.integer :placement

      t.timestamps null: false
    end
  end
end
