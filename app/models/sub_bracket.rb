class SubBracket < ActiveRecord::Base
  belongs_to :tournament
  has_many :rounds
  has_many :matches
  has_many :teams, through: :matches
  attr_reader :base
end
