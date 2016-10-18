require 'pp'

class CreateMatches
  def initialize(params)
    @tournament = params[:tournament]
    @teams = params[:tournament].teams
  end
  
  attr_reader :teams, :tournament
  
  def assign_matches_win_loss_records
    assign_elimination_matches_win_loss_records
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
  
  def create_sub_brackets
    
  end
  
  def assign_elimination_matches_win_loss_records
    matches = @tournament.matches.to_a
    pp("1: #{matches}")
    matches.shift((@tournament.num_teams) / 2)
    
    pp("2: #{matches}")
    (Math.log2(@tournament.num_teams) - 1).to_i.times do
      puts("In the first do loop")
      ( calc_matches_in_round(matches) ).times do
        puts("In the second do loop")
        matches.each do |m|
          puts("In the deepest each block")
          pp(m)
          m.win_loss_record << "W"
          m.save
        end
        matches.shift( calc_matches_in_round(matches) )
      end
    end
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