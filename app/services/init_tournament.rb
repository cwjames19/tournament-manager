require 'pp'

module InitTournament
  def InitTournament.assign_teams_to_first_round_matches(tournament)
    first_round_matches = tournament.matches.where(required_wlr: "").order(num: :asc).to_a
    included_teams = tournament.teams.all.order(seed: :asc).to_a
    while first_round_matches.any? do
      active_match = first_round_matches.shift
      active_match.teams << included_teams.shift
      active_match.teams << included_teams.pop
      active_match.team_home_id = active_match.teams.first.id
      active_match.team_visitor_id = active_match.teams.second.id
      active_match.save
    end
  end
  
  def InitTournament.assign_matches_to_rounds(tournament)
    tournament.matches.each do |m|
      if tournament.rounds.find_by(common_wlr: m.required_wlr)
        m.update(round_id: tournament.rounds.find_by(common_wlr: m.required_wlr).id)
      end
    end
  end
  
  def InitTournament.create_matches_and_sub_brackets(tournament)
    inst = CreateMatchesAndSubBrackets.new(tournament)
    inst.create_matches
    inst.assign_wlr_and_consolation_sub_brackets
  end
  
  def InitTournament.create_rounds(tournament)
    tournament.sub_brackets.each do |sb|
      counter = 1
      wlr_adjustment = ""
      (Math.log2(sb.matches.count).round.to_i).times do
        sb.rounds.create(num: counter, sub_bracket_id: sb, tournament_id: tournament, common_wlr: sb.base_wlr + wlr_adjustment );
        counter += 1
        wlr_adjustment += "W"
      end
    end
  end
  
  def InitTournament.create_teams(tournament)
    CreateTeams.new(tournament).create_teams
  end
  
  class CreateMatchesAndSubBrackets
    def initialize(tournament)
      @tournament = tournament
      @sub_bracket_creator = SubBracketCreator.new(@tournament)
    end
    
    def assign_wlr_and_consolation_sub_brackets
      case  @tournament.extra_game_option
      when "no_extra_games"
        assign_wlr_championship_only(@tournament.matches.to_a << nil, false)
      when "bronze_medal_game"
        assign_wlr_championship_only(@tournament.matches.to_a, true)
      when "play_to_all_places"
        assign_wlr_all(@tournament.matches.last(@tournament.matches.count - (@tournament.num_teams / 2)))
      end
      @tournament.matches.each{ |match| match.save }
    end
    
    def create_matches
      case  @tournament.extra_game_option
      when "no_extra_games"
        optn = @tournament.num_teams - 1
      when "bronze_medal_game"
        optn = @tournament.num_teams
      when "play_to_all_places"
        optn = Math.log2(@tournament.num_teams).to_i * ( 2 ** (Math.log2(@tournament.num_teams).to_i - 1))
      else
        return raise ArgumentError, 'The extra_game_option was found to be an unacceptable value'
      end
      
      for i in 1..optn do
        @tournament.matches.create(tournament_id: @tournament, required_wlr: "", sub_bracket: @tournament.sub_brackets.first, num: i)
      end
      @tournament.matches.first.update_column(:num, 1)
    end
    
    private
    
    def assign_wlr_championship_only(all_matches, bronze)
      matches_in_this_round = []
      for i in 0..((Math.log2(all_matches.length) - 1).to_i)
        matches_in_this_round = all_matches.shift( all_matches.length / 2)
        matches_in_this_round.each do |m|
          i.times do
            m.required_wlr << "W"
          end
        end
      end
      
      assign_bronze_match_wlr(all_matches.first, matches_in_this_round[0].required_wlr.to_s) if bronze
    end
    
    def assign_bronze_match_wlr(match, wlr_of_championship_game)
      wlr_of_bronze_game = wlr_of_championship_game.split(//)
      wlr_of_bronze_game[-1] = "L"
      match.required_wlr = wlr_of_bronze_game.join
    end
    
    def assign_wlr_all(m_collection)
      w_group = m_collection.first(m_collection.count / 2)
      l_group = m_collection.last(m_collection.count / 2)
      w_group.each { |match| match.update({required_wlr: match.required_wlr + "W"}) }
      l_group.each { |match| match.update({required_wlr: match.required_wlr + "L"}) }
      @sub_bracket_creator.create_new_sub_bracket(l_group) if l_group.count >= 4
      
      assign_wlr_all(w_group.last(w_group.count / 2)) if w_group.count > 1
      assign_wlr_all(l_group.last(l_group.count / 2)) if l_group.count > 1
    end
  end
  
  class CreateTeams
    def initialize(tournament)
      @tournament = tournament
    end
    
    def create_teams
      seed_teams if @tournament.team_seeds.any?{ |s| s == "" }
      for i in 0..( @tournament.team_names.length - 1 ) do
        Team.create({tournament_id: @tournament.id, name: @tournament.team_names[i], seed: @tournament.team_seeds[i], current_wlr: ""})
      end
    end
    
    private
    
    def seed_teams
      @tournament.team_seeds = [*1..@tournament.team_seeds.length].shuffle
      @tournament.save
    end
  end
  
  class SubBracketCreator
    def initialize(tournament)
      @tournament = tournament
      @bracket_count = 1
      puts(@tournament.sub_brackets)
      @tournament.sub_brackets.create({num: @bracket_count, base_wlr: ""})
    end
    
    attr_reader :tournament, :bracket_count
    
    def create_new_sub_bracket(m_collection)
      @bracket_count += 1
      new_sb = @tournament.sub_brackets.create!({num: @bracket_count, base_wlr: m_collection.first.required_wlr })
      m_collection.each { |match| match.update({sub_bracket: new_sb}) }
    end
  end
end