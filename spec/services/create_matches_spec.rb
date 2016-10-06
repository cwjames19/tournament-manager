require 'rails_helper'

RSpec.describe CreateMatches do
  let(:user) { create(:user) }
  let(:tournament) { user.tournaments.create({user_id: user.id, name: "foo", extra_game_option: 1, public: true, num_teams: 4}) }
  
  describe "#initialize" do
    before do
      @instanceCM = CreateMatches.new({tournament: tournament})
    end
    
    it "sets @tournament to params[:tournament]" do
      expect(@instanceCM.tournament).to eq(tournament)
    end
    
    it "sets @teams to @tournament's teams" do
      expect(@instanceCM.teams).to eq(tournament.teams)
    end
  end
  
  # describe "4 team tournament, non-seeded" do
  #   before do
  #     @t = user.tournaments.create({user_id: user.id, name: "foo", extra_game_option: 1, public: true, num_teams: 4})
  #     @instanceCM = CreateMatches.new({tournament: @t})
  #   end
    
  #   describe "#create_matches" do
      
  #   end
  # end
  
end