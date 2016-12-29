class AddWinLossRecordToTeamsAndMatches < ActiveRecord::Migration
  def change
    add_column :teams, :win_loss_record, :string
    add_column :matches, :win_loss_record, :string
  end
end
