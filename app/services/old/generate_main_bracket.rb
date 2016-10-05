class GenerateMainBracket
  
  def initialize(tournament_id)
    @tournament = Tournament.find(tournament_id)
    #generate_bracket
  end
  
  def generate_bracket
    
    generate_main_matches
    
    assign_teams_to_main_matches
    
    @tournament.sub_bracket_counter.increment
    
  end
  
  
  def generate_main_matches
    
    matches_left = @tournament.num_teams - 1
    round_counter = 1
    
    while matches_left != 1
    
      matches_left = (matches_left / 2).ceil
      matches_left.times{ @tournament.matches.create({sub_bracket: 0, round: round_counter}) }
      
      round_counter += 1
      
    end
    
    return Success.new(@tournament.matches.to_a)
  end
  
  def assign_teams_to_main_matches
    true
  end
  
  private
  
  
end