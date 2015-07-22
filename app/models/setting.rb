class Setting < ActiveRecord::Base

  # Fields to be translated
  translates :value

  def self.maptypes
    %w(osm mapbox mapquest)
  end

end
