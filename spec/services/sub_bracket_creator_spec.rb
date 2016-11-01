require 'rails_helper'

RSpec.describe SubBracketCreator do
  let(:user) {User.create!({email: "user1@example.com", password: "password"})}
  let(:tournament) {Tournament.create!({user: user, name:"hello world", public: 1, extra_game_option: 0, num_teams: 4, team_names: ["team1", "team2", "team3", "team4"], team_seeds: [1, 2, 3, 4]})}
  let(:sub_bracket_creator) {SubBracketCreator.new(tournament)}
  
  describe "#initialize" do
    it "sets the instance variables" do
      expect(sub_bracket_creator.tournament.id).to eq tournament.id
    end
    
    it "creates a new sub_bracket" do
      expect {sub_bracket_creator}.to change { SubBracket.all.count }.from(0).to(1)
    end
    
    it "creates a sub_bracket belonging to @tournament" do
      sub_bracket_creator
      expect(SubBracket.last.tournament_id).to eq sub_bracket_creator.tournament.id
    end
    
    it "creates a sub_bracket with an empty string as the base_win_loss_record win_loss_record" do
      sub_bracket_creator
      expect(SubBracket.last.base_win_loss_record).to eq ""
    end
  end
  
  describe "create_new_sub_bracket" do
    
    before do
      sub_bracket_creator
      2.times { tournament.matches.create! }
      tournament.matches.first.update({win_loss_record: [*"A".."Z"].sample})
      sub_bracket_creator.create_new_sub_bracket(tournament.matches.first(1))
    end
    
    it "increases the bracket_count by one" do
      expect(sub_bracket_creator.bracket_count).to eq 2
    end
    
    it "creates a new SubBracket for @tournament" do
      expect(SubBracket.count).to eq 2
    end
    
    it "assigns the correct match to the new SubBracket" do
      id = tournament.matches.first.id
      expect(tournament.matches.find(id).sub_bracket).to eq(SubBracket.last)
    end
    
    it "does not assign the incorrect match to the new SubBracket" do
      id = tournament.matches.last.id
      expect(tournament.matches.find(id).sub_bracket).not_to eq(SubBracket.last)
    end
    
    it "assigns the correct base_win_loss_record to the new SubBracket" do
      id = tournament.matches.first.id
      expect(Match.find(id).sub_bracket.base_win_loss_record).to eq(Match.find(id).win_loss_record)
    end
  end
end
