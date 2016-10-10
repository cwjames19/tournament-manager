class AddExtraGameOptionToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :extra_game_option, :integer, default: 0
  end
end
