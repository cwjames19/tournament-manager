class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :tournament_type, default: "single elimination"
      t.boolean :play_out_all_games
      t.boolean :bronze_medal_game
      t.string :image
      t.boolean :public, default: true
      t.text :teams
      t.boolean :normal_scoring

      t.timestamps null: false
    end
  end
end
