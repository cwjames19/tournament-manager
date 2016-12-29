require 'pp'

class CreateMatchesAndSubBrackets
  def initialize(tournament)
    @tournament = tournament
    @sub_bracket_creator = SubBracketCreator.new(@tournament)
    binding.pry
  end
  
  def assign_win_loss_records_and_consolation_sub_brackets
    case  @tournament.extra_game_option
    when "no_extra_games"
      assign_win_loss_records_to_championship_bracket_only(@tournament.matches.to_a << nil, false)
    when "bronze_medal_game"
      assign_win_loss_records_to_championship_bracket_only(@tournament.matches.to_a, true)
    when "play_to_all_places"
      assign_win_loss_records_to_all_brackets(@tournament.matches.last(@tournament.matches.count - (@tournament.num_teams / 2)))
      @tournament.matches.each{ |match| match.save }
    end
    binding.pry
  end
  
  def create_matches
    @sub_bracket_creator = SubBracketCreator.new(@tournament)
    
    case  @tournament.extra_game_option
    when "no_extra_games"
      optn = @tournament.num_teams - 1
    when "bronze_medal_game"
      optn = @tournament.num_teams
    when "play_to_all_places"
      optn = Math.log2(@tournament.num_teams).to_i * ( 2 ** (Math.log2(@tournament.num_teams).to_i - 1))
    else
      return raise ArgumentError, 'The extra_game_option was not found to be an acceptable value'
    end
    
    for i in 1..optn do
      @tournament.matches.create(tournament_id: @tournament.id, num: i, win_loss_record: "", sub_bracket: @tournament.sub_brackets.first)
    end
    @tournament.matches.first.update_column(:num, 1)
  end
  
  private
  
  def assign_win_loss_records_to_championship_bracket_only(all_matches, bronze)
    matches_in_this_round = []
    for i in 0..((Math.log2(all_matches.length) - 1).to_i)
      matches_in_this_round = all_matches.shift( all_matches.length / 2)
      matches_in_this_round.each do |m|
        i.times do
          m.win_loss_record << "W"
        end
      end
    end
    
    assign_bronze_match_win_loss_record(all_matches.first, matches_in_this_round[0].win_loss_record.to_s) if bronze
    @tournament.matches.each{ |match| match.save }
  end
  
  def assign_bronze_match_win_loss_record(match, win_loss_record_of_championship_game)
    win_loss_record_of_bronze_game = win_loss_record_of_championship_game.split(//)
    win_loss_record_of_bronze_game[-1] = "L"
    match.win_loss_record = win_loss_record_of_bronze_game.join
  end
  
  def assign_win_loss_records_to_all_brackets(matches_collection)
    w_group = matches_collection.first(matches_collection.count / 2)
    l_group = matches_collection.last(matches_collection.count / 2)
    w_group.each { |match| match.update({win_loss_record: match.win_loss_record + "W"}) }
    l_group.each { |match| match.update({win_loss_record: match.win_loss_record + "L"}) }
    @sub_bracket_creator.create_new_sub_bracket(l_group) if l_group.count >= 4
    assign_win_loss_records_to_all_brackets(w_group.last(w_group.count / 2)) if w_group.count > 1
    assign_win_loss_records_to_all_brackets(l_group.last(l_group.count / 2)) if l_group.count > 1
  end
end