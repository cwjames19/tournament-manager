class TeamNamesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    regexp = /[\+=_\)\(\*&^%$@!~\{\}\[\]-]/
    record.errors[attribute] << "must be between 4 and 36 characters" if value.to_a.any?{ |name| name.length < 3 || name.length > 36}
    record.errors[attribute] << "can not include characters +=-_\*&^%$@!~{}[]" if value.any?{ |name| regexp =~ name }
    record.errors[attribute] << "must all be different" if value.map(&:downcase) != (value.map(&:downcase)).uniq
    record.errors[attribute] << "must have one name for every team" if value.length != record.num_teams
  end
end

# class TeamNamesValidator < ActiveModel::Validator
#   def validate(record)
#     validate_team_name_characters(record.team_names)
#     validate_team_name_length(record.team_names)
#   end
  
#   def validate_team_name_characters(names)
#     regexp = /[\+=_\)\(\*&^%$@!~\{\}\[\]-]/
#     record.errors[:team_names] << "You can only use letters, numbers, '\'', ':', '.', ',', '?', and ' ' to name teams. " if names.any?{ |name| regexp =~ name }
#   end
  
#   def validate_team_name_length(names)
#     record.errors[:team_names] << "Team names must be at least three characters long. " if names.any?{ |name| name.length < 3 }
#   end
# end