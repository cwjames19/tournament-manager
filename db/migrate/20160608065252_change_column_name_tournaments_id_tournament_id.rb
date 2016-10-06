class ChangeColumnNameTournamentsIdTournamentId < ActiveRecord::Migration
  rename_column(:teams, :tournaments_id, :tournament_id )
end
