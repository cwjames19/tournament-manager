class Round < ActiveRecord::Base
  belongs_to :sub_bracket
  has_many :matches
  has_many :teams, through: :matches
end
