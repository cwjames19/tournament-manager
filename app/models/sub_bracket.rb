class SubBracket < ActiveRecord::Base
  belongs_to :tournament
  has_many :matches
end
