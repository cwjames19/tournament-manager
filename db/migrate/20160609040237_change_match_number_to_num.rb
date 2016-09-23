class ChangeMatchNumberToNum < ActiveRecord::Migration
  def change
    rename_column(:matches, :match_number, :num)
  end
end
