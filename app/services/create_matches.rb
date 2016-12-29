class CreateMatches
  def initialize(params)
    puts "in the create_matches #initialize"
    @tournament = params[:tournament]
    @extra_game_option = @tournament.extra_game_option
    @teams = params[:tournament].teams
    binding.pry
  end
  
  attr_reader :tournament, :teams
  
  def assign_matches
    
  end
  
  def create_matches
    case @extra_game_option
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