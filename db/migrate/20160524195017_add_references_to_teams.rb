class AddReferencesToTeams < ActiveRecord::Migration
  def change 
    add_reference :teams, :tournaments, index: true
    add_foreign_key :teams, :tournaments
  end
end
