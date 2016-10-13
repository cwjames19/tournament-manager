class CreateTeams
  def initialize(params)
    @tournament = params[:tournament]
    @names = @tournament.team_names
    @seeds = @tournament.team_seeds
  end
  
  def create_teams
    seed_teams if @seeds.any? { |s| s == "" }
    for i in 0..( @names.length - 1 ) do
      Team.create!({tournament_id: @tournament.id, name: @names[i], seed: @seeds[i]})
    end
  end
  
  def seed_teams
    @seeds = [*1..@seeds.length]
    @seeds.shuffle!
  end
end