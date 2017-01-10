class Match < ActiveRecord::Base
  serialize :required_seeds, Array
  
  belongs_to :tournament
  belongs_to :sub_bracket
  belongs_to :round
  has_and_belongs_to_many :teams
  
end
