class CreateTeams
  def initialize(tournament)
    @tournament = tournament
  end
  
  def create_teams
    seed_teams if @tournament.team_seeds.any?{ |s| s == "" }
    for i in 0..( @tournament.team_names.length - 1 ) do
      Team.create({tournament_id: @tournament.id, name: @tournament.team_names[i], seed: @tournament.team_seeds[i], win_loss_record: ""})
    end
  end
  
  private
  
  def seed_teams
    @tournament.team_seeds = [*1..@tournament.team_seeds.length].shuffle
    @tournament.save
  end
end