class RemoveExtraGameOptionFromTournaments < ActiveRecord::Migration
  change_table :tournaments do |t|
    t.remove :extra_game_option
  end
end
