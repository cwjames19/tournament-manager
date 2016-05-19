class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :match_number
      t.string :winner
      t.string :loser
      t.string :team_home
      t.string :team_visitor
      t.string :result_home
      t.string :result_visitor
      t.string :overtime_home
      t.string :overtime_visitor

      t.timestamps null: false
    end
  end
end
