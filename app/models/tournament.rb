class Tournament < ActiveRecord::Base
    belongs_to :user, inverse_of: :tournament
    has_many :matches, inverse_of: :tournament
    has_many :teams, inverse_of: :tournament
end
