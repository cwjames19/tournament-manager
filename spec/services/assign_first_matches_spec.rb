require 'pp'

RSpec.describe AssignFirstMatches do
  let (:user) {User.create!({email: "user@example.com", password: "example"})}
  let (:tournament) do
    user.tournaments.create!({
      name: "tournament1",
      public: 1,
      num_teams: 8,
      team_names: ["team1", "team2", "team3", "team4", "team5", "team6", "team7", "team8"],
      team_seeds: [*1..8],
      extra_game_option: 0,
      user_id: user.id
    })
    for i in 1..[*8..20].sample do
      Tournament.last.teams.create!({
        name: "team#{i}",
        seed: i,
        win_loss_record: ""
      })
      Tournament.last.matches.create({win_loss_record: ""})
    end
    Tournament.find_by(name: "tournament1")
  end
  
  describe "#assign_first_round" do
    before do
      tournament
    end
    it "assigns the first 8 teams one match" do
      
    end
    
    it "assigns no matches to any additional teams after the first eight" do
      
    end
    
    it "has the one seed playing the eight seed" do
      
    end
  end
end
