class MapPostInfo < MapInfo

  POST_INFO_ATTRIBUTES = [:post_show, :popup_message, :area]

  attr_accessor(*(MAP_INFO_ATTRIBUTES+POST_INFO_ATTRIBUTES))

  def initialize(post)
    super()
    post_location = post.locations.first
    categories = post.categories

    # Getting information as an exact address location
    self.post_show = []
    categories.each {|cat| self.post_show << {icon: cat.icon, color: cat.marker_color, item_name: cat.name}}


    self.latitude = post_location.latitude
    self.longitude = post_location.longitude
    self.zoom_level = CLOSER_ZOOM_LEVEL
  end

  def attributes_to_read
    MAP_INFO_ATTRIBUTES+POST_INFO_ATTRIBUTES
  end
end