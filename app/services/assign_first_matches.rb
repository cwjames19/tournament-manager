require 'pp'

class AssignFirstMatches
  def initialize(tournament)
    @tournament = tournament
  end
  
  def assign_first_round
    first_round_matches = @tournament.matches.where(win_loss_record: "").order(num: :asc).to_a
    included_teams = @tournament.teams.where(win_loss_record: "").order(seed: :asc).to_a
    while first_round_matches.any? do
      active_match = first_round_matches.shift
      active_match.teams << included_teams.shift
      active_match.teams << included_teams.pop
      active_match.save
    end
  end
end