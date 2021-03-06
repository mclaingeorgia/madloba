require 'rails_helper'
#require 'shoulda/matchers'
# - There is a problem using shoulda, there's a conflict with Pundit
# - Read more here: https://github.com/elabs/pundit/issues/145

RSpec.describe Category, :type => :model do
  it 'has a valid factory' do
    expect(FactoryGirl.create(:first_category)).to be_valid
  end

  it 'is invalid without a name' do
    expect(FactoryGirl.build(:category, name: nil)).not_to be_valid
  end

  it 'is invalid without a marker color' do
    expect(FactoryGirl.build(:category, marker_color: nil)).not_to be_valid
  end

  it 'is invalid without an icon' do
    expect(FactoryGirl.build(:category, icon: nil)).not_to be_valid
  end

  it 'is invalid if it has same marker color and icon as another category' do
    same_icon_to_use = 'fa-circle'
    same_marker_color_to_use = 'blue'
    category1 = FactoryGirl.create(:category, icon: same_icon_to_use, marker_color: same_marker_color_to_use)
    expect(FactoryGirl.build(:category, icon: same_icon_to_use, marker_color: same_marker_color_to_use)).not_to be_valid

  end

end
