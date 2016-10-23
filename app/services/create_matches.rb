require 'pp'

class CreateMatches
  def initialize(tournament)
    @tournament = tournament
    @teams = tournament.teams
    @matches_in_main_bracket = (@tournament.extra_game_option == 0) ? @tournament.num_teams : (@tournament.num_teams - 1)
  end
  
  attr_reader :teams, :tournament
  
  def assign_all_win_loss_records_to_matches
    assign_associated_win_loss_records_to_matches(@tournament.matches)
    # assign_bronze_match_win_loss_record unless @tournament.extra_game_option == "no_extra_games"
    # assign_consolation_matches_win_loss_records if @tournament.extra_game_option == "play_to_all_places"
  end
  
  def create_matches
    case  @tournament.extra_game_option
    when "no_extra_games"
      optn = @teams.length - 1
    when "bronze_medal_game"
      optn = @teams.length
    when "play_to_all_places"
      optn = Math.log2(@teams.length).to_i * ( 2 ** (Math.log2(@teams.length).to_i - 1))
    else
      return raise ArgumentError, 'The extra_game_option was not found to be an acceptable value'
    end
    
    for i in 1..optn do
      @tournament.matches.create(tournament_id: @tournament.id, num: i, win_loss_record: "")
    end
    @tournament.matches.first.update_column(:num, 1)
  end
  
  private
  
  def assign_associated_win_loss_records_to_matches(matches_collection)
    all_matches = matches_collection.to_a
    all_matches << nil unless all_matches.length % 2 == 0
    
    for i in 0..((Math.log2(all_matches.length) - 1).to_i)
      matches_in_this_round = all_matches.shift( all_matches.length / 2)
      matches_in_this_round.each do |m|
        i.times do
          m.win_loss_record << "W"
        end
      end
      assign_consolation_match_win_loss_record(all_matches.last, matches_in_this_round[0].win_loss_record.to_s) if all_matches.length == 1 && all_matches.last != nil
    end
    @tournament.matches.each{ |match| match.save }
  end
  
  def assign_consolation_match_win_loss_record(match, win_loss_record_of_championship_game)
    win_loss_record_of_consolation_game = win_loss_record_of_championship_game.split(//)
    win_loss_record_of_consolation_game[-1] = "L"
    match.win_loss_record = win_loss_record_of_consolation_game.join
  end
  
  def assign_consolation_matches_win_loss_records
    # create sub_brackets here with service object
  end
end