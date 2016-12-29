require 'rails_helper'
include TeamNamesValidator

RSpec.describe Tournament, type: :model do
  it { should have_many(:matches) }
  it { should have_many(:teams) }
  
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:extra_game_option) }
  it { should validate_presence_of(:num_teams) }
  it { should validate_presence_of(:team_names) }
  it { should validate_presence_of(:team_seeds) }
  it { should validate_presence_of(:public) }
  
  it { should validate_numericality_of(:num_teams) }
  
  it { should validate_length_of(:name).is_at_least(3).is_at_most(45) }
  # it { should validate_length_of(:team_names).is(self.num_teams) }
  # it { should validate_length_of(:team_seeds).is(self.num_teams) }
  
end