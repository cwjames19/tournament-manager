class ChangeSubBracketRoundCounterToRounds < ActiveRecord::Migration
  def change
    rename_column :sub_brackets, :round_counter, :rounds
  end
end
