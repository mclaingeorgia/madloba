class MapAdInfo < MapInfo

  AD_INFO_ATTRIBUTES = [:ad_show, :popup_message, :area]

  attr_accessor(*(MAP_INFO_ATTRIBUTES+AD_INFO_ATTRIBUTES))

  def initialize(ad)
    super()
    ad_location = ad.locations.first
    categories = ad.categories

    # Getting information as an exact address location
    self.ad_show = []
    categories.each {|cat| self.ad_show << {icon: cat.icon, color: cat.marker_color, item_name: cat.name}}


    self.latitude = ad_location.latitude
    self.longitude = ad_location.longitude
    self.zoom_level = CLOSER_ZOOM_LEVEL
  end

  def attributes_to_read
    MAP_INFO_ATTRIBUTES+AD_INFO_ATTRIBUTES
  end
end