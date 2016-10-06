class CreateJoinTableMatchesTeams < ActiveRecord::Migration
  def change
    create_join_table :matches, :teams, column_options: {null: true} do |t|
      t.index :match_id
      t.index :team_id
    end
  end
end
