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
  
  # delegates raw string of teams to methods dealing with seeded or non-seeded teams
  def validate_teams
    string = @teams_raw.split("\r\n")
    
    if string.any? { |t| t =~ /^\d+,/ }
      return seeded_teams(string)
    else
      return non_seeded_teams(string)
    end
  end
  
  #
  def generate_teams(tournament_id, teams_clean)
    teams_clean = assign_random_seeds(teams_clean) if teams_clean[0][0] == nil
    
    teams_clean.each do |t|
      Team.create({name: t[1], seed: t[0], tournament_id: tournament_id})
    end
    
    return Success.new(Tournament.find(tournament_id).teams.to_a)
  end
  
  def fill_in_tournament(tournament_id)
    generate_teams(tournament_id, @teams_clean)
    GenerateMainBracket.new(tournament_id)
  end
  
  private
  
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
    1..(@num_teams.to_i).each { |i| model_seed_array[i - 1] = i }
    
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
  
  
  
  
  def assign_random_seeds(unseeded_teams)
    seed_array = []
    for i in 1..unseeded_teams.size do seed_array << i end
    seed_array.shuffle!
    
    for i in 0..(unseeded_teams.size - 1) do unseeded_teams[i][0] = seed_array[i] end
    return unseeded_teams
  end
end