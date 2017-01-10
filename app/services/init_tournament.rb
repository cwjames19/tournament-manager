require 'pp'

module InitTournament
  def InitTournament.assign_teams_to_first_round_matches(tournament)
    first_round_matches = tournament.matches.where(required_wlr: "").order(num: :asc).to_a
    first_round_matches.each do |match|
      match.update({
        team_home_id: Team.find_by({
          tournament_id: tournament.id,
          prog_wlr: "",
          og_seed: match.required_seed_home
        }).id,
        team_visitor_id: Team.find_by({
          tournament_id: tournament.id,
          prog_wlr: "",
          og_seed: match.required_seed_visitor
        }).id
      })
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
  
  def InitTournament.assign_required_seeds_to_matches(tournament)
    AssignRequiredSeedsToMatches.new(tournament).assign_each_sub_bracket
  end
  
  class AssignRequiredSeedsToMatches
    def initialize(tournament)
      @tournament = tournament
    end
    
    def assign_each_sub_bracket
      @tournament.sub_brackets.each do |sb|
        seed_range = find_seed_range(sb)
        sb.rounds.order(num: :asc).each do |round|
          assign_each_round(round, seed_range)
          seed_range = seed_range.first(seed_range.count / 2)
        end
      end
    end
    
    private
    
    def find_seed_range(sb)
      seed_range = [*1..@tournament.num_teams]
      wlr = sb.base_wlr.split('')
      until wlr.empty?
        if wlr.shift == "W"
          seed_range = seed_range.first(seed_range.count/ 2)
        else
          seed_range = seed_range.last(seed_range.count / 2)
        end
      end
      return seed_range
    end
    
    def assign_each_round(round, range)
      matches = round.matches.to_a
      top_half = range.first(range.count / 2)
      bottom_half = range.last(range.count / 2)
      counter = 0
      until matches.empty?
        counter += 1
        current_seeds = [top_half.shift, bottom_half.pop]
        matches.shift.update({required_seeds: current_seeds,
                              required_seed_home: current_seeds[0],
                              required_seed_visitor: current_seeds[-1]
        })
        matches.reverse!
        if counter == 2
          [top_half, bottom_half].each(&:reverse!)
          counter = 0
        end
      end
    end
  end
  
  class CreateMatchesAndSubBrackets
    def initialize(tournament)
      @tournament = tournament
      @sub_bracket_creator = SubBracketCreator.new(@tournament)
    end
    
    def assign_wlr_and_consolation_sub_brackets
      if @tournament.extra_game_option == "play_to_all_places"
        separate_matches_into_sb(@tournament.matches.all.to_a)
        add_sb_wlr
      end
      @tournament.sub_brackets.each {|sb| assign_wlr_to_matches(sb) }
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
    
    def separate_matches_into_sb(m_collection)
      m_collection.shift(@tournament.num_teams)
      sb_size = @tournament.num_teams / 2
      iterations = 1
      while sb_size >= 4 do
        iterations.times do
          @sub_bracket_creator.create_new_sub_bracket(m_collection.shift(sb_size))
        end
        sb_size /= 2
        iterations *= 2
      end
    end
    
    def add_sb_wlr
      sb_count = @tournament.sub_brackets.count
      sb_collection = @tournament.sub_brackets.last(sb_count - 1).to_a
      sb_count_of_this_match_size = 1
      
      Math.log2(sb_count).to_i.times do
        sbs_of_focus = sb_collection.shift(sb_count_of_this_match_size)
        if (sbs_of_focus.count == 1)
          sbs_of_focus[0].update({base_wlr: "L"})
        else
          prepend_half_half(sbs_of_focus)
          sbs_of_focus.each { |sb| sb.update({base_wlr: sb.base_wlr << "L"}) }
        end
        sb_count_of_this_match_size *= 2
      end
    end
    
    def prepend_half_half(collection)
      l_group = collection.first(collection.count / 2)
      w_group = collection.last(collection.count / 2)
      l_group.each {|sb| sb.update({base_wlr: sb.base_wlr.prepend("L")})}
      w_group.each {|sb| sb.update({base_wlr: sb.base_wlr.prepend("W")})}
      [w_group, l_group].each {|group| prepend_half_half(group) if group.count > 1}
    end
    
    def assign_wlr_to_matches(sub_bracket)
      all_matches = sub_bracket.matches.to_a.each{ |m| m.required_wlr = sub_bracket.base_wlr }
      all_matches << nil if all_matches.count % 2 == 1
      
      matches_in_this_round = []
      for i in 0..((Math.log2(all_matches.length) - 1).to_i)
        matches_in_this_round = all_matches.shift( all_matches.length / 2)
        wins_string = "W" * i
        matches_in_this_round.each{ |m| m.update({required_wlr: m.required_wlr << wins_string}) }
      end
      
      unless all_matches[0] == nil
        champ_game_wlr = matches_in_this_round[0].required_wlr.split(//)
        champ_game_wlr[-1] = "L"
        all_matches[0].update({required_wlr: champ_game_wlr.join})
      end
    end
  end
  
  class CreateTeams
    def initialize(tournament)
      @tournament = tournament
    end
    
    def create_teams
      seed_teams if @tournament.team_seeds.any?{ |s| s == "" }
      for i in 0..( @tournament.team_names.length - 1 ) do
        Team.create({ tournament_id: @tournament.id,
                      name: @tournament.team_names[i],
                      og_seed: @tournament.team_seeds[i],
                      prog_seed: @tournament.team_seeds[i],
                      prog_wlr: ""
        })
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
      new_sb = @tournament.sub_brackets.create!({num: @bracket_count, base_wlr: "" })
      m_collection.each { |match| match.update({sub_bracket: new_sb}) }
    end
  end
end