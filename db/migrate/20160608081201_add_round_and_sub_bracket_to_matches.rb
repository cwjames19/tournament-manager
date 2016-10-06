class AddRoundAndSubBracketToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :round, :integer
    add_column :matches, :sub_bracket, :integer
  end
end
