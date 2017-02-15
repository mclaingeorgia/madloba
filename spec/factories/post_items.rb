# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :post_item do
    item
    post
  end

  factory :post_with_first_item, class: 'PostItem' do
    association :item, factory: :first_item
  end

  factory :post_with_second_item, class: 'PostItem' do
    association :item, factory: :second_item
  end

end
