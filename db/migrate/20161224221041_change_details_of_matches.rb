class ChangeDetailsOfMatches < ActiveRecord::Migration
  change_table :matches do |t|
    t.remove :team_home, :string
    t.remove :team_visitor, :string
    t.remove :winner, :string
    t.remove :loser, :string
    t.references :team_home
    t.references :team_visitor
    t.references :winner
    t.references :loser
    
    t.remove :result_home, :string
    t.remove :result_visitor, :string
    t.remove :overtime_home, :string
    t.remove :overtime_visitor, :string
    t.float :result_home
    t.float :result_visitor
    t.float :overtime_home
    t.float :overtime_visitor
    
  end
end
