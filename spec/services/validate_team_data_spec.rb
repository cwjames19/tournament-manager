RSpec.describe ValidateTeamData do
  
  before do
    @num = gen_good_num
  end
  
  describe "#validate_team_name_characters" do
    it "accepts the team names" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_good_name }, gen_good_seeds(@num))
      expect(instance.validate_team_name_characters).to be_nil
    end
    
    it "rejects team names with invalid characters" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_bad_name }, gen_good_seeds(@num))
      expect(instance.validate_team_name_characters).to eq([@@characters_error_message])
    end
  end
  
  describe "#validate_team_name_length" do
    it "accepts the team names" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_good_name }, gen_good_seeds(@num))
      expect(instance.validate_team_name_length).to be_nil
    end
    
    it "rejects teams with short names" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_short_name }, gen_good_seeds(@num))
      expect(instance.validate_team_name_length).to eq([@@length_error_message])
    end
  end
  
  describe "#validate_team_seeds" do
    it "accepts properly seeded teams" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_good_name }, gen_good_seeds(@num))
      expect(instance.validate_seeds).to be_nil
    end
    
    it "rejects team seeds with improper seeding" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_good_name }, gen_bad_seeds(@num))
      expect(instance.validate_seeds).to eq([@@seed_error_message])
    end
  end
  
  describe "validate_team_data" do
    it "accepts properly formed team data" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_good_name }, gen_good_seeds(@num))
      expect( instance.validate_team_data ).to be_empty
    end
    
    it "rejects improperly formed team data with the correct error message(1)" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_bad_name }, gen_good_seeds(@num))
      expect( instance.validate_team_data ).to eq([@@characters_error_message])
    end
    
    it "rejects improperly formed team data with the correct error message(2)" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_short_name }, gen_good_seeds(@num))
      expect( instance.validate_team_data ).to eq([@@length_error_message])
    end
    
    it "rejects improperly formed team data with the correct error message(3)" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_good_name }, gen_bad_seeds(@num))
      expect( instance.validate_team_data ).to eq([@@seed_error_message])
    end
    
    it "rejects improperly formed team data with the correct error messages(4)" do
      instance = ValidateTeamData.new(Array.new(@num){ gen_bad_name }, gen_bad_seeds(@num))
      expect( instance.validate_team_data ).to eq([@@characters_error_message, @@seed_error_message])
    end
  end
  
  private
  
  @@characters_error_message = "You can only use letters, numbers, '\'', ':', '.', ',', '?', and ' ' to name teams."
  @@length_error_message = "Team names must be at least three characters long."
  @@seed_error_message = "Teams were improperly seeded."
  
  def gen_good_num
    [4, 8, 16].sample
  end
  
  def gen_bad_num
    loop do
      result = [*1..17].sample
      break unless [4, 8, 16].include?(result)
    end
    result
  end
  
  def gen_good_name
    range = [*'0'..'9', *'a'..'z', *'A'..'Z', '\'', ':', '.', ',', '?', ' ']
    Array.new((Random.rand(3..36)).round){ range.sample }.join
  end
  
  def gen_bad_name
    range = ['`', '~', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '_', '-', ']', '[', ';', '"', '?', '/', '<', '>', '{', '}', '+', '=', '|', '\\']
    Array.new((Random.rand(3..36)).round){ range.sample }.join
  end
  
  def gen_short_name
    range = [*'0'..'9', *'a'..'z', *'A'..'Z', '\'', ':', '.', ',', '?', ' ']
    Array.new((Random.rand(0..2)).round){ range.sample }.join
  end
  
  def gen_good_seeds(num)
    [*1..num].shuffle!
  end
  
  def gen_bad_seeds(num)
    result = nil
    range = [*1..num]
    loop do
      result = Array.new(num){ range.sample }
      break if result.uniq.length != num
    end
    result
  end
end