class AddReferencesToMatches < ActiveRecord::Migration
  def change
    add_reference :matches, :tournament, index: true
    add_foreign_key :matches, :tournaments
  end
end