class ValidateTeamData
  def initialize(names, seeds)
    @names = names
    @seeds = seeds
    if names.length == seeds.length
      @num = names.length
    else
      raise ArgumentError, "Different numbers of team names and seeds were submitted"
    end
    @errors = []
  end
  
  def validate_team_data
    validate_team_name_characters
    validate_team_name_length
    validate_seeds
    @errors
  end
  
  def validate_team_name_characters
    regexp = /[\+=_\)\(\*&^%$@!~\{\}\[\]-]/
    @errors << "You can only use letters, numbers, '\'', ':', '.', ',', '?', and ' ' to name teams." if @names.any?{ |name| regexp =~ name }
  end
  
  def validate_team_name_length
    @errors << "Team names must be at least three characters long." if @names.any?{ |name| name.length < 3 }
  end
  
  def validate_seeds
    return if @seeds == Array.new(@names.length){ "" }
    puts"#{@seeds}"
    @errors << "Teams were improperly seeded." if @seeds.uniq != @seeds || @seeds.any?{ |s| s == "" }
  end
end