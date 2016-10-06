class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.integer :tournament_type
      t.integer :extra_game_option
      t.string :image
      t.boolean :public, default: true
      t.text :teams_raw
      t.boolean :normal_scoring
      t.references :user, index: true, foreign_key: true
      t.references :teams, index: true, foreign_key: true
      t.references :matches, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
