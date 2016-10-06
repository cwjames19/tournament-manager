require_relative '../spec_helper.rb'
require_relative '../rails_helper.rb'
require_relative '../../app/services/generate_main_bracket.rb'

RSpec.describe GenerateMainBracket do
  
  let(:user) { create(:user) }
  
  context "8 team, single elimination tournament" do
  
    before do
      tournament_params = {
        name: "test_name",
        tournament_type: "single_elimination",
        num_teams: "8",
        extra_game_option: "no_extra_games",
        "public" => "1",
        user_id: user
      }
      @tournament = Tournament.create(tournament_params)
      init_tournament = InitTournament.new(tournament_params)
      init_tournament.generate_teams(@tournament.id, [[6, "Test Team 1"], [3, "Test Team 2"], [5, "Test Team 3"], [8, "Test Team 4"], [2, "Test Team 5"], [7, "Test Team 6"], [1, "Test Team 7"], [4, "Test Team 8"]])
      @gen_main = GenerateMainBracket.new(@tournament.id)
    end
    
    describe "generate_main_matches" do
      
      
      it "returns a success" do
        expect(@gen_main.generate_main_matches.success?).to be true
      end
      
      it "creates the correct number of matches (7)" do
        expect{@gen_main.generate_main_matches}.to change(@tournament.matches, :count).from(0).to(7)
      end
      
      it "does some other stuff" do
        expect(@gen_main.generate_main_matches.data).to eq 5
      end
      
      it "assigns match numbers to each of the matches properly" do
        result = []
        @gen_main.generate_main_matches.data.each{|match| result << match.num}
        expect(result.sort).to eq([1, 2, 3, 4, 5, 6, 7])
      end
      
      it "assigns 4 matches to round 1" do
        @gen_main.generate_main_matches
        expect(@tournament.matches.where(num: [1, 2, 3, 4]).to_a.all?{|match| match.round == 1}).to be true
      end
      
      it "assigns 2 matches to round 2" do
        @gen_main.generate_main_matches
        expect(@tournament.matches.where(num: [5, 6]).to_a.all?{|match| match.round == 2}).to be true
      end
      
      it "assigns 1 match to round 3" do
        @gen_main.generate_main_matches
        expect(@tournament.matches.where(num: [7]).to_a.all?{|match| match.round == 3}).to be true
      end
      
      it "assigns sub_bracket numbers to each of the matches properly" do
        expect(@tournament.matches.to_a.all?{|match| match.sub_bracket == 0 }).to be true
      end
      
      it "does some stuff" do
        @gen_main.generate_main_matches
        expect(@tournament).to eq 4
      end
    end
    
    describe "assign_teams_to_main_matches" do
      it "assigns teams to first round matches properly according to seeding" do
        
      end
    end
  end
  
end