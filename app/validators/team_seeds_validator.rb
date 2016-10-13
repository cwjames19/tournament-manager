class TeamSeedsValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << "must seed no teams or all teams without repeats" unless ( value == Array.new(record.num_teams){ "" } ) || ( value.map(&:to_i).sort == [*1..record.num_teams] )
  end
end