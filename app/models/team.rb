class Team < ActiveRecord::Base
    belongs_to :tournament, inverse_of: :teams
    has_and_belongs_to_many :matches, inverse_of: :teams
end
