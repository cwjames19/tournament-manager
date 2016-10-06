class Round < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :sub_bracket
end
