require_relative 'success.rb'
require_relative 'error.rb'

class InitTournament
  attr_reader :params, :name, :tournament_type, :extra_game_option, :num_teams
  attr_accessor :teams_clean
  
  def initialize(tournament_params)
    @params = tournament_params
    @name = tournament_params[:name]
    @tournament_type = tournament_params[:tournament_type]
    @extra_game_option = tournament_params[:extra_game_option]
    @num_teams = tournament_params[:num_teams].to_i
    @teams_raw = tournament_params[:teams_raw]
    @teams_clean |= []
  end
  
  
  
  public
  #PUBLICPUBLICPUBLICPUBLICPUBLICPUBLICPUBLICPUBLICPUBLICPUBLICPUBLICPUBLICPUBLICPUBLIC
  
  def validate_teams
    parse_teams_raw
  end
  
  def fill_in_tournament(tournament_id)
    generate_teams(tournament_id, @teams_clean)
    #generate_matches(tournament_id, @teams_clean)
  end
  
  
  
  private
  #PRIVATEPRIVATEPRIVATEPRIVATEPRIVATEPRIVATEPRIVATEPRIVATEPRIVATEPRIVATEPRIVATEPRIVATE
  
  # delegates raw string of teams to methods dealing with seeded or non-seeded teams
  def parse_teams_raw
    string = @teams_raw.split("\r\n")
    
    if string.any? { |t| t =~ /^\d+,/ }
      return seeded_teams(string)
    else
      return non_seeded_teams(string)
    end
  end
  
  # parses string of raw team data and formats into an arrays of arrays
  # containing seed and titleized team name
  def seeded_teams(teams_split)
    unless teams_split.length == @num_teams
      return teams_split.length > @num_teams ? Error.new("Too many teams provided") : Error.new("Too few teams provided")
    end
    
    teams_with_seeds = teams_split.map!{ |t|
      t = t.partition(/^\d+,/)[1..2]
      t[0] = t[0].to_i
      t[1].strip!
      t[1] = t[1].split(/ /).map!(&:capitalize).join(" ")
      return Error.new("There was a problem with the seeds provided for the tournament's teams.") unless t[1].match(/\S/)
      t
    }
    
    model_seed_array = []
    for i in 1..(@num_teams.to_i) do model_seed_array[i - 1] = i end
    
    real_seed_array = []
    teams_with_seeds.each {|t| real_seed_array << t[0]}
    real_seed_array.sort!

    if real_seed_array == model_seed_array
      @teams_clean = teams_with_seeds
      return Success.new(@teams_clean)
    else
      return Error.new("There was a problem with the seeds provided for the tournament's teams.")
    end
  end
  
  # parses string of raw team data and formats into an array of titleized team names
  def non_seeded_teams(teams_split)
    teams_split.map!{ |t| t.split(/ /).map(&:capitalize).join(" ") }
    
    if teams_split.length > @num_teams
      return Error.new("Too many team names")
    elsif teams_split.length < @num_teams
      while teams_split.length < @num_teams do
        teams_split << "Team " + (teams_split.length + 1).to_s
      end
    end
    
    teams_with_blank_seeds = []
    teams_split.each { |team| teams_with_blank_seeds << [nil, team] }
    
    @teams_clean = teams_with_blank_seeds
    return Success.new(@teams_clean)
  end
  
  
  def generate_teams(tournament_id, teams_clean)
    teams_clean = assign_random_seeds(teams_clean) if teams_clean[0][0] == nil
    
    teams_clean.each do |t|
      Team.create({name: t[1], seed: t[0], tournament_id: tournament_id})
    end
    
    return Success.new(Tournament.find(tournament_id).teams.to_a)
  end
  
  def assign_random_seeds(unseeded_teams)
    seed_array = []
    for i in 1..unseeded_teams.size do seed_array << i end
    seed_array.shuffle!
    
    for i in 0..(unseeded_teams.size - 1) do unseeded_teams[i][0] = seed_array[i] end
    return unseeded_teams
  end
  
  def generate_matches(tournament_id)
    # return Success(true)
  end
  
  # validate parameters
  # =>.validate
  # =>new_tournament.parse_teams_raw(tournament_params).success?
  # =>  accept or return error about seeding
  # create Tournament object
  # do other stuff for Tournament object
  
  # go through parse_raw_data again or keep instance variable (teams_clean)?
  # create the right amount of teams with association, correct names, and correct ranking
  # create the right amount of games with association
  # create the right amount of rounds
  # assign the right amount of games to each round
  # write logic for assigning teams to first round
  # write logic for teams advancing appropriately
end