require 'rails_helper'

RSpec.describe Tournament, type: :model do
  it { should have_many(:matches) }
  it { should have_many(:teams) }
  
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:num_teams) }
  it { should validate_presence_of(:extra_game_option) }
  it { should validate_presence_of(:public) }
  
  it { should validate_length_of(:name).is_at_least(3).is_at_most(45) }
end