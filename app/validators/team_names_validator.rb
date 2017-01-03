class TeamNamesValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    regexp = /[\+=_\)\(\*&^%$@!~\{\}\[\]-]/
    record.errors[attribute] << "must be between 3 and 24 characters" if value.to_a.any?{ |name| name.length < 3 || name.length > 24}
    record.errors[attribute] << "can not include characters +=-_\*&^%$@!~{}[]" if value.any?{ |name| regexp =~ name }
    record.errors[attribute] << "must all be different" if value.map(&:downcase) != (value.map(&:downcase)).uniq
    record.errors[attribute] << "must have one name for every team" if value.length != record.num_teams
  end
end