class CreateMatches
  def initialize(params)
    @tournament = params[:tournament]
    @teams = params[:tournament].teams
  end
  
  def assign_matches
    
  end
  
  def create_matches
    case  @tournament.extra_game_option
    when "no_extra_games"
      num = @teams.length - 1
    when "bronze_medal_game"
      num = @teams.length
    when "play_to_all_places"
      num = Math.log2(@teams.length).to_i * ( 2 ** (Math.log2(@teams.length).to_i - 1))
    else
      return raise ArgumentError, 'The extra_game_option was not found to be an acceptable value'
    end
    
    for i in 1..num do
      @tournament.matches.create(tournament_id: @tournament.id, num: i)
    end
    @tournament.matches.first.update_column(:num, 1)
  end
end