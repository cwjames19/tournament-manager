class AddSubBracketCounterToournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :sub_bracket_counter, :integer, default: 0
  end
end
