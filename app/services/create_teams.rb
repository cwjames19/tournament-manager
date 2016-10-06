class CreateTeams
  def initialize(params)
    @tournament = params[:tournament]
    @names = params[:names]
    @seeds = params[:seeds]
  end
  
  def create_teams
    seed_teams if @seeds.any? { |s| s == "" }
    i = 0
    while (i < @names.length) do
      Team.create!({tournament_id: @tournament.id, name: @names[i], seed: @seeds[i]})
      i += 1
    end
  end
  
  def seed_teams
    @seeds = (1..@seeds.length).step(1).to_a
    @seeds.shuffle!
  end
end