require 'pp'

class CreateMatches
  def initialize(tournament)
    @tournament = tournament
    @teams = tournament.teams
  end
  
  attr_reader :teams, :tournament
  
  def assign_all_win_loss_records_to_matches
    assign_associated_win_loss_records_to_matches(@tournament.matches)
    assign_bronze_match_win_loss_record unless @tournament.extra_game_option == "no_extra_games"
    assign_consolation_matches_win_loss_records if @tournament.extra_game_option == "play_to_all_places"
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
  
  # def assign_elimination_matches_win_loss_records
  #   matches = @tournament.matches.to_a
  #   pp("1: #{matches}")
  #   matches.shift((@tournament.num_teams) / 2)
    
  #   pp("2: #{matches}")
  #   (Math.log2(@tournament.num_teams) - 1).to_i.times do
  #     puts("In the first do loop")
  #     ( calc_matches_in_round(matches) ).times do
  #       puts("In the second do loop")
  #       matches.each do |m|
  #         puts("In the deepest each block")
  #         pp(m)
  #         m.win_loss_record << "W"
  #       end
  #       matches.shift( calc_matches_in_round(matches) )
  #     end
  #   end
    
  #   all_matches = @tournament.matches.to_a
  #   all_matches << nil unless all_matches % 2 == 0
    
  #   (Math.log2(@tournament.num_teams) - 1).to_i.times do
  #     matches_in_this_round = 
    
  #   @tournament.matches.save
  # end
  
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
    end
    @tournament.matches.each{ |match| match.save }
  end
  
  def assign_bronze_match_win_loss_record
    @tournament.matches.last.win_loss_record << "L"
  end
  
  def assign_consolation_matches_win_loss_records
    # create sub_brackets here with service object
  end
  
  def calc_matches_in_round(match_array)
    match_array.count % 2 == 0 ? match_array.count / 2 : (match_array.count + 1) / 2
  end
end