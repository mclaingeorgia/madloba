class MapTile < ActiveRecord::Base

  MAPBOX_MAPTILES = [['Street','mapbox.streets'], ['Satellite','mapbox.satellite']]

  def self.osm
    self.find_by_name('open_street_map')
  end

  def self.mapbox
    self.find_by_name('mapbox')
  end

  def self.mapquest
    self.find_by_name('map_quest')
  end

  def self.chosen_map
    self.send(Setting.find_by_key('chosen_map').value)
  end

  def url_builder
    url = tile_url.dup
    if url.present?
      map_name = I18n.locale == :en ? 'map_english_name' : 'map_georgian_name'
      url.gsub!('<api_key>', api_key) if api_key.present?
      url.gsub!('<map_id>', self.send(map_name)) if self.send(map_name).present?
    end
    url
  end

  def display_name
    name.titleize.delete(' ')
  end

end
