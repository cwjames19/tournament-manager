# require 'rails_helper'
require_relative '../../app/services/init_tournament.rb'

describe InitTournament do
  
  # before(:each) do
  #   tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "4", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "test team 1\r\ntest team 2\r\ntest team 3\r\ntest team 4" }
  #   @tournament = InitTournament.new(tournament_params)
  # end
  
  describe "#generate_teams" do
    #teams increase by @num_teams
    #teams are associated with the correct tournament
    #all teams have a seed
  end
  
  describe "#assign_random_seeds" do
    #all teams get a seed
    #no seeds duplicated
    #seeds are randomized
  end
  
  describe "#parse_teams_raw" do
    
    context "with a full list of non-seeded teams" do
    
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "test team 1\r\ntest team 2\r\ntest team 3\r\ntest team 4\r\ntest team 5\r\ntest team 6\r\ntest team 7\r\ntest team 8" }
        @tournament = InitTournament.new(tournament_params)
      end
    
      it "returns a Success object" do
        expect(@tournament.validate_teams.is_a?(Success)).to eq(true)
        expect(@tournament.validate_teams.success?).to eq(true)
      end
      
      it "returns the correct array of parsed team names in Success.data" do
        expect(@tournament.validate_teams.data).to eq([[nil, "Test Team 1"], [nil, "Test Team 2"], [nil, "Test Team 3"], [nil, "Test Team 4"], [nil, "Test Team 5"], [nil, "Test Team 6"], [nil, "Test Team 7"], [nil, "Test Team 8"]])
      end
      
      it "assigns the parsed list of teams to @teams_clean" do
        result = @tournament.validate_teams
        expect(@tournament.teams_clean).to eq(result.data)
      end
      
      it "returns an array of the correct number of teams" do
        expect(@tournament.validate_teams.data.length).to eq(@tournament.num_teams.to_i)
      end
      
    end
    
    context "with a full list of seeded teams" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "8, test team 1\r\n7, test team 2\r\n6, test team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7\r\n1, test team 8" }
        @tournament = InitTournament.new(tournament_params)
      end
      
      it "returns a Success object" do
        expect(@tournament.validate_teams.is_a?(Success)).to eq(true)
        expect(@tournament.validate_teams.success?).to eq(true)
      end
      
      it "returns the correct array of parsed team names in Success.data" do
        expect(@tournament.validate_teams.data).to eq([[8, "Test Team 1"], [7, "Test Team 2"], [6, "Test Team 3"], [5, "Test Team 4"], [4, "Test Team 5"], [3, "Test Team 6"], [2, "Test Team 7"], [1, "Test Team 8"]])
      end
      
      it "assigns the parsed list of teams to @teams_clean" do
        result = @tournament.validate_teams
        expect(@tournament.teams_clean).to eq(result.data)
      end
      
      it "returns an array of the correct number of teams" do
        expect(@tournament.validate_teams.data.length).to eq(@tournament.num_teams.to_i)
      end
      
    end
    
    
    context "with a list of too many unseeded teams" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "test team 1\r\ntest team 2\r\ntest team 3\r\ntest team 4\r\ntest team 5\r\ntest team 6\r\ntest team 7\r\ntest team 8\r\ntest team 9" }
        @tournament = InitTournament.new(tournament_params)
      end
      
      it "returns an Error object" do
        expect(@tournament.validate_teams.is_a?(Error)).to be true
      end
      
      it "returns the correct error message" do
        expect(@tournament.validate_teams.error).to eq("Too many team names")
      end
      
    end
    
    context "with a list of not enough unseeded teams" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "test team 1\r\ntest team 2\r\ntest team 3\r\ntest team 4\r\ntest team 5\r\ntest team 6" }
        @tournament = InitTournament.new(tournament_params)
      end
      
      it "returns an Success object" do
        expect(@tournament.validate_teams.is_a?(Success)).to be true
      end
      
      it "returns the correct array of parsed team names in Success.data" do
        expect(@tournament.validate_teams.data).to eq([[nil, "Test Team 1"], [nil, "Test Team 2"], [nil, "Test Team 3"], [nil, "Test Team 4"], [nil, "Test Team 5"], [nil, "Test Team 6"], [nil, "Team 7"], [nil, "Team 8"]])
      end
      
      it "assigns the parsed list of teams to @teams_clean" do
        result = @tournament.validate_teams
        expect(@tournament.teams_clean).to eq(result.data)
      end
      
      it "returns an array of the correct number of teams" do
        expect(@tournament.validate_teams.data.length).to eq(@tournament.num_teams.to_i)
      end
      
    end
    
    context "with a list of not enough seeded teams" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "8, test team 1\r\n7, test team 2\r\n6, test team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7" }
        @tournament = InitTournament.new(tournament_params)
      end
      
      it "returns an Error object" do
        expect(@tournament.validate_teams.is_a?(Error)).to be true
      end
      
      it "returns the correct error message" do
        expect(@tournament.validate_teams.error).to eq("Too few teams provided")
      end
      
    end
    
    context "with a list of too many seeded teams" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "8, test team 1\r\n7, test team 2\r\ntest team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7\r\n1, test team 8\r\n9, test team 0" }
        @tournament = InitTournament.new(tournament_params)
      end
      
      it "returns an Error object" do
        expect(@tournament.validate_teams.is_a?(Error)).to be true
      end
      
      it "returns the correct error message" do
        expect(@tournament.validate_teams.error).to eq("Too many teams provided")
      end
      
    end
    
    context "with a list of seeded teams missing seeds" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "8, test team 1\r\n7, test team 2\r\ntest team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7\r\n1, test team 8" }
        @tournament = InitTournament.new(tournament_params)
      end
      
      it "returns an Error object" do
        expect(@tournament.validate_teams.is_a?(Error)).to be true
      end
      
      it "returns the correct error message" do
        expect(@tournament.validate_teams.error).to eq("There was a problem with the seeds provided for the tournament's teams.")
      end
      
    end
    
    context "with edge case #1, seed but no title" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "8, test team 1\r\n7, test team 2\r\n6, test team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7\r\n1, " }
        @tournament = InitTournament.new(tournament_params)
      end
      
      it "returns an Error object" do
        expect(@tournament.validate_teams.is_a?(Error)).to be true
      end
      
      it "returns the correct error message" do
        expect(@tournament.validate_teams.error).to eq("There was a problem with the seeds provided for the tournament's teams.")
      end
      
    end
    
    context "with edge case #2, wrong seed numbers" do
      
      before do
        tournament_params = {name: "test_name", tournament_type: "single_elimination", num_teams: "8", extra_game_option: "no_extra_games", "public" => "1", teams_raw: "9, test team 1\r\n7, test team 2\r\n6, test team 3\r\n5, test team 4\r\n4, test team 5\r\n3, test team 6\r\n2, test team 7\r\n1, test team 8" }
        @tournament = InitTournament.new(tournament_params)
      end
      
      it "returns an Error object" do
        expect(@tournament.validate_teams.is_a?(Error)).to be true
      end
      
      it "returns the correct error message" do
        expect(@tournament.validate_teams.error).to eq("There was a problem with the seeds provided for the tournament's teams.")
      end
      
    end
    
  end
  
end