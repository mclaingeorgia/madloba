class PlaceTag < ActiveRecord::Base
  belongs_to :place
  belongs_to :tag
end
