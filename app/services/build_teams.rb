class BuildTeams
  def initialize(params)
    @tournament = params[:tournament]
    @names = params[:names]
    @seeds = params[:seeds]
  end
  
  def create_teams
    @seeds.any? { |s| s == "" } ? seed_teams : nil
    i = 0
    while (i < @names.length) do
      Team.create!({tournament_id: @tournament.id, name: @names[i], seed: @seeds[i]})
      i += 1
    end
  end
  
  def seed_teams
    @seeds.each_index { |index| @seeds[index] = index + 1 }
    @seeds.shuffle!
  end
end