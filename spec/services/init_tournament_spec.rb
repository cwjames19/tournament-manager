require_relative '../rails_helper.rb'
require_relative '../spec_helper.rb'
require_relative '../../app/services/init_tournament.rb'

describe InitTournament do
  
  # tournament_params = {name: "test_name", tournament_type: "single_elimination",
  #   num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: @teams_raw}
  let(:user) {FactoryGirl.create(:user)}
  # let(:basic_tournament) {FactoryGirl.create(:tournament, extra_game_option: "no_extra_games", )}
  # let(:init_tournament) {InitTournament.new(tournament_params)}
  
  # do testing of private methods, generate_teams generate_teams and generate_matches
  # when they pass combine them into the proper "describe" object and rename it fill_in_tournament
  # repeat for rest of object, action, etc.
  
  describe "#fill_in_tournament" do
  
    describe "#generate_teams" do
      
      before do
          tournament_params = {
          name: "test_name",
          tournament_type: "single_elimination",
          num_teams: "8",
          extra_game_option: "no_extra_games",
          "public" => "1",
          user_id: user
          }
          @init_tournament = InitTournament.new(tournament_params)
          @tournament = Tournament.create(tournament_params)
      end
      
      context "with a set of unseeded teams" do
        
        before do
          @init_tournament.teams_clean = [[nil, "Test Team 1"], [nil, "Test Team 2"], [nil, "Test Team 3"], [nil, "Test Team 4"], [nil, "Test Team 5"], [nil, "Test Team 6"], [nil, "Test Team 7"], [nil, "Test Team 8"]]
        end
        
        it "creates the correct amount of teams for the correct tournament" do
          expect{@init_tournament.fill_in_tournament(@tournament.id)}.to change(@tournament.teams, :count).from(0).to(8)
        end
        
        it "assigns the correct seed values, but randomized" do
          @init_tournament.fill_in_tournament(@tournament.id)
          test_arr = []
          @tournament.teams.to_a.each{|t| test_arr << t.seed }
          
          expect(test_arr).not_to eq [1, 2, 3, 4, 5, 6, 7, 8]
          expect(test_arr.sort!).to eq [1, 2, 3, 4, 5, 6, 7, 8]
        end
        
        it "assigns the correct team names" do
          @init_tournament.fill_in_tournament(@tournament.id)
          test_arr = []
          @tournament.teams.to_a.each{|t| test_arr << t.name }
          
          expect(test_arr).to eq ["Test Team 1", "Test Team 2", "Test Team 3", "Test Team 4", "Test Team 5", "Test Team 6", "Test Team 7", "Test Team 8"]
        end
        
      end
      
      context "with a set of seeded teams" do
        
        before do
          @init_tournament.teams_clean = [[6, "Test Team 1"], [3, "Test Team 2"], [5, "Test Team 3"], [8, "Test Team 4"], [2, "Test Team 5"], [7, "Test Team 6"], [1, "Test Team 7"], [4, "Test Team 8"]]
        end
        
        it "creates the correct amount of teams for the correct tournament" do
          expect{@init_tournament.fill_in_tournament(@tournament.id)}.to change(@tournament.teams, :count).from(0).to(8)
        end
        
        it "assigns the correct seed values, but randomized" do
          @init_tournament.fill_in_tournament(@tournament.id)
          test_arr = []
          @tournament.teams.to_a.each{|t| test_arr << t.seed }
          
          expect(test_arr).to eq [6, 3, 5, 8, 2, 7, 1, 4]
        end
        
        it "assigns the correct team names" do
          @init_tournament.fill_in_tournament(@tournament.id)
          test_arr = []
          @tournament.teams.to_a.each{|t| test_arr << t.name }
          
          expect(test_arr).to eq ["Test Team 1", "Test Team 2", "Test Team 3", "Test Team 4", "Test Team 5", "Test Team 6", "Test Team 7", "Test Team 8"]
        end
        
      end
      
    end
    
    # make me into another object!!!
    # what parameters will i need to accomplish just this task but in many situations?
    #   a list of teams (number of teams can be inferred),
    #   new/old seeding (take the lowest of the prior match)
    #   tournament to which it belongs
    #   sub_bracket
    #   round?
    describe "#generate_matches" do
      context "with 8 teams" do
        it "creates the proper number of matches" do
        
        end
        
        it "assigns teams exactly one time each" do
        
        end
        
        it "assigns teams according to proper seeding protocol" do
          
        end
      end
    end
    
  end
  
  describe "#validate_teams" do
    
    context "with a full list of non-seeded teams" do
    
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "test team 1\r\ntest team 2\r\ntest team 3\r\ntest team 4\r\ntest team 5\r\ntest team 6\r\ntest team 7\r\ntest team 8" }
        @init_tournament = InitTournament.new(tournament_params)
      end
      
      it "returns success" do
        expect(@init_tournament.validate_teams.success?).to eq(true)
      end
      
      it "returns the correct array of parsed team names in Success.data" do
        expect(@init_tournament.validate_teams.data).to eq([[nil, "Test Team 1"], [nil, "Test Team 2"], [nil, "Test Team 3"], [nil, "Test Team 4"], [nil, "Test Team 5"], [nil, "Test Team 6"], [nil, "Test Team 7"], [nil, "Test Team 8"]])
      end
      
      it "assigns the parsed list of teams to @teams_clean" do
        result = @init_tournament.validate_teams
        expect(@init_tournament.teams_clean).to eq(result.data)
      end
      
      it "returns an array of the correct number of teams" do
        expect(@init_tournament.validate_teams.data.length).to eq(@init_tournament.num_teams.to_i)
      end
      
    end
    
    context "with a full list of seeded teams" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "8, test team 1\r\n7, test team 2\r\n6, test team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7\r\n1, test team 8" }
        @init_tournament = InitTournament.new(tournament_params)
      end
      
      it "returns success" do
        expect(@init_tournament.validate_teams.success?).to eq(true)
      end
      
      it "returns the correct array of parsed team names in Success.data" do
        expect(@init_tournament.validate_teams.data).to eq([[8, "Test Team 1"], [7, "Test Team 2"], [6, "Test Team 3"], [5, "Test Team 4"], [4, "Test Team 5"], [3, "Test Team 6"], [2, "Test Team 7"], [1, "Test Team 8"]])
      end
      
      it "assigns the parsed list of teams to @teams_clean" do
        result = @init_tournament.validate_teams
        expect(@init_tournament.teams_clean).to eq(result.data)
      end
      
      it "returns an array of the correct number of teams" do
        expect(@init_tournament.validate_teams.data.length).to eq(@init_tournament.num_teams.to_i)
      end
      
    end
    
    
    context "with a list of too many unseeded teams" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "test team 1\r\ntest team 2\r\ntest team 3\r\ntest team 4\r\ntest team 5\r\ntest team 6\r\ntest team 7\r\ntest team 8\r\ntest team 9" }
        @init_tournament = InitTournament.new(tournament_params)
      end
      
      it "not to return success" do
        expect(@init_tournament.validate_teams.success?).to be false
      end
      
      it "returns the correct error message" do
        expect(@init_tournament.validate_teams.error).to eq("Too many team names")
      end
      
    end
    
    context "with a list of not enough unseeded teams" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "test team 1\r\ntest team 2\r\ntest team 3\r\ntest team 4\r\ntest team 5\r\ntest team 6" }
        @init_tournament = InitTournament.new(tournament_params)
      end
      
      it "returns success" do
        expect(@init_tournament.validate_teams.success?).to be true
      end
      
      it "returns an array of the correct number of teams" do
        expect(@init_tournament.validate_teams.data.length).to eq(@init_tournament.num_teams.to_i)
      end
      
      it "returns the correct array of parsed team names in Success.data" do
        expect(@init_tournament.validate_teams.data).to eq([[nil, "Test Team 1"], [nil, "Test Team 2"], [nil, "Test Team 3"], [nil, "Test Team 4"], [nil, "Test Team 5"], [nil, "Test Team 6"], [nil, "Team 7"], [nil, "Team 8"]])
      end
      
      it "assigns the parsed list of teams to @teams_clean" do
        result = @init_tournament.validate_teams
        expect(@init_tournament.teams_clean).to eq(result.data)
      end
      
    end
    
    context "with a list of not enough seeded teams" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "8, test team 1\r\n7, test team 2\r\n6, test team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7" }
        @init_tournament = InitTournament.new(tournament_params)
      end
      
      it "not to return success" do
        expect(@init_tournament.validate_teams.success?).to be false
      end
      
      it "returns the correct error message" do
        expect(@init_tournament.validate_teams.error).to eq("Too few teams provided")
      end
      
    end
    
    context "with a list of too many seeded teams" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "8, test team 1\r\n7, test team 2\r\ntest team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7\r\n1, test team 8\r\n9, test team 0" }
        @init_tournament = InitTournament.new(tournament_params)
      end
      
      it "not to return success" do
        expect(@init_tournament.validate_teams.success?).to be false
      end
      
      it "returns the correct error message" do
        expect(@init_tournament.validate_teams.error).to eq("Too many teams provided")
      end
      
    end
    
    context "with a list of seeded teams missing seeds" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "8, test team 1\r\n7, test team 2\r\ntest team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7\r\n1, test team 8" }
        @init_tournament = InitTournament.new(tournament_params)
      end
      
      it "not to return success" do
        expect(@init_tournament.validate_teams.success?).to be false
      end
      
      it "returns the correct error message" do
        expect(@init_tournament.validate_teams.error).to eq("There was a problem with the seeds provided for the tournament's teams.")
      end
      
    end
    
    context "with edge case #1, seed but no title" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "8, test team 1\r\n7, test team 2\r\n6, test team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7\r\n1, " }
        @init_tournament = InitTournament.new(tournament_params)
      end
      
      it "not to return success" do
        expect(@init_tournament.validate_teams.success?).to be false
      end
      
      it "returns the correct error message" do
        expect(@init_tournament.validate_teams.error).to eq("There was a problem with the seeds provided for the tournament's teams.")
      end
      
    end
    
    context "with edge case #2, wrong seed numbers" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "9, test team 1\r\n7, test team 2\r\n6, test team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7\r\n1, test team 8" }
        @init_tournament = InitTournament.new(tournament_params)
      end
      
      it "not to return success" do
        expect(@init_tournament.validate_teams.success?).to be false
      end
      
      it "returns the correct error message" do
        expect(@init_tournament.validate_teams.error).to eq("There was a problem with the seeds provided for the tournament's teams.")
      end
      
    end
    
  end
  
end