FactoryGirl.define do
  
  factory :tournament do
    sequence :name do |n|
      "tournament #{n}"
    end
    user_id create(:user)
    num_teams 8
  end
  
end