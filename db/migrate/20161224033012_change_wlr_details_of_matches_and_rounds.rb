class ChangeWlrDetailsOfMatchesAndRounds < ActiveRecord::Migration
  change_table :rounds do |t|
    t.string :common_wlr
  end
  
  change_table :teams do |t|
    t.rename :win_loss_record, :current_wlr
  end
  
  change_table :sub_brackets do |t|
    t.rename :base_win_loss_record, :base_wlr
  end
  
  change_table :matches do |t|
    t.rename :win_loss_record, :required_wlr
  end
end
