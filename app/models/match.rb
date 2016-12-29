class Match < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :sub_bracket
  has_and_belongs_to_many :teams
  
end
