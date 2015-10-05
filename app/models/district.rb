class District < ActiveRecord::Base

  has_many :locations

  validates :name, :bounds, presence: true

  # Fields to be translated
  translates :name

end
