class PlaceService < ActiveRecord::Base
  belongs_to :place
  belongs_to :service
end
