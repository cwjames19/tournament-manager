class SubBracketCreator
  def initialize(tournament)
    @tournament = tournament
    @bracket_count = 1
    
    @tournament.sub_brackets.create({num: @bracket_count, rounds: Math.log2(@tournament.num_teams)})
    binding.pry
  end
  
  attr_reader :tournament, :bracket_count
  
  def create_new_sub_bracket(matches_collection)
    binding.pry
    @bracket_count += 1
    new_sb = @tournament.sub_brackets.create!({num: @bracket_count, rounds: Math.log2(matches_collection.count)})
    matches_collection.each { |match| match.update({sub_bracket: new_sb}) }
  end
end