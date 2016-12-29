class ChangeSubBracketsBaseToBaseRecord < ActiveRecord::Migration
  change_table :sub_brackets do |t|
    t.rename :base, :base_win_loss_record
  end
end
