class Match < ActiveRecord::Base
    belongs_to :tournament, inverse_of: :matches
    has_and_belongs_to_many :teams, inverse_of: :teams
end
