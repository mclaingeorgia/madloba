class AdLocation < ActiveRecord::Base
  belongs_to :post
  belongs_to :location
  accepts_nested_attributes_for :location, :reject_if => :all_blank

end
