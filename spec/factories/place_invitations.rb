FactoryGirl.define do
  factory :place_invitation do
    place nil
    email "MyString"
    has_accepted false
    token "MyString"
    user nil
  end
end
