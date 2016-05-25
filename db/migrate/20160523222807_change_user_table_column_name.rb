class ChangeUserTableColumnName < ActiveRecord::Migration
  def change
    change_table :tournaments do |t|
      t.rename :teams, :teams_raw
    end
  end
end
