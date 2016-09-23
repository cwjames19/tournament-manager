class AddRoundCounterToSubBracket < ActiveRecord::Migration
  def change
    add_column :sub_brackets, :round_counter, :integer, default: 1
  end
end
