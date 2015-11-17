class Location < ActiveRecord::Base
  has_many :ad_locations
  has_many :ads, through: :ad_locations, dependent: :destroy
  belongs_to :user
  belongs_to :district

  validates_presence_of :address
  validates_presence_of :latitude, :longitude
  # 'Postal code' field is not necessary only if user chooses a district name instead.
  validates_presence_of :postal_code, if: lambda { self.district == nil}
  validates :latitude , numericality: { greater_than:  -90, less_than:  90 }
  validates :longitude, numericality: { greater_than: -180, less_than: 180 }

  # Fields to be translated
  translates :name, :address, :province, :city, :block_unit, :village, :description
  globalize_accessors :locales => [:en, :ka], :attributes => [:name, :address, :block_unit, :village, :province, :city, :description]

  scope :type, -> (location_type) { where('ads.expire_date >= ? AND loc_type = ? AND ads.is_published = ?', Date.today, location_type, true)}

  # This method returns the right query to display relevant markers, on the home page.
  def self.search(location_type, cat_nav_state, searched_item, selected_item_ids, user_action, ad_id)

    locations = Location.includes([:translations, {ads: :categories}, {ads: {items: :translations}}, {ads: :translations}]).type(location_type).references(:ads)

    if ad_id.present?
      # Search by ad ids when adding ads on home page dynamically, when other user just created an ad (websocket)
      locations = locations.where('ads.id = ?', ad_id)
    end

    if cat_nav_state || searched_item
      if cat_nav_state
        if searched_item
          # We search for ads in relation to the searched item and the current category navigation state.
          locations = locations.where(categories: {id: cat_nav_state}, items: {id: selected_item_ids})
        else
          # We search for ads in relation to our current category navigation state.
          locations = locations.where(categories: {id: cat_nav_state})
        end
      elsif searched_item
        locations = locations.where(items: {id: selected_item_ids})
      end
    end

    if user_action
      # For the RehabLink app, ads are always on 'is_giving' mode.
      locations = locations.where("ads.is_giving = ?", true)
    end

    if location_type == 'postal'
      locations = locations.group_by(&:area)
    elsif location_type == 'district'
      locations = locations.group_by(&:district_id)
    end

    return locations
  end

  # This method creates the final longitudes and latitudes for each area to be displayed on the map.
  def self.define_area_geocodes (locations_postal, locations_district)
    area_geocodes = {}
    if (locations_postal && locations_postal.length > 0)
      locations_postal.each do |area, locations|
        total_latitude = 0.0
        total_longitude = 0.0
        count = 0
        locations.each do |location|
          total_latitude += location.latitude.to_f
          total_longitude += location.longitude.to_f
          count += 1
        end
        area_geocodes[area] = {'latitude' => total_latitude / count, 'longitude' => total_longitude / count}
      end
    end

    if (locations_district && locations_district.length > 0)
      districts = District.where(id: locations_district.keys)
      districts.each do |district|
        area_geocodes[district.id] = {'name' => district.name, 'bounds' => district.bounds}
      end
    end

    return area_geocodes
  end

  def is_area
    ['postal','district'].include? self.loc_type
  end

  def type
    self.loc_type=='exact'?'exact':'area'
  end

  def area
    area_length = Setting.find_by_key(:area_length).value.to_i
    self.postal_code[0..area_length-1]
  end

  def full_address
    if self.street_number
      "#{self.street_number} #{self.address}, #{self.city}"
    else
      "#{self.address}, #{self.city}"
    end
  end

  def name_and_or_full_address
    if self.name && self.name != ''
      "#{self.name} - #{self.location_type_address_public}"
    else
      self.location_type_address_public
    end
  end

  # if the location has no name, return "unnamed location"
  def location_full_name
    if self.name && self.name != ''
      return self.name
    else
      return "(#{I18n.t('admin.location.unnamed')})"
    end
  end

  def location_type_address
    if self.loc_type == 'exact'
      full_address
    elsif self.loc_type == 'postal'
      self.postal_code
    elsif self.loc_type == 'district'
      self.district.name
    end
  end

  # On the ads/show page, we're not necessarily showing the full address,
  # depending of how the location type.
  def location_type_address_public
    if self.loc_type == 'exact'
      full_address
    elsif self.loc_type == 'postal'
      I18n.t('admin.location.area_name', area_name: self.area)
    elsif self.loc_type == 'district'
      self.district.name
    end
  end

  def full_website_url
    if self.website && !self.website.include?('http')
      "http://#{self.website}"
    else
      self.website
    end
  end

end
