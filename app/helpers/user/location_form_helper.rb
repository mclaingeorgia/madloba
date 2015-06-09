module User::LocationFormHelper

  # Get all the districts for the location form partial.
  def districts
    all_districts = Rails.cache.fetch(CACHE_DISTRICTS) {District.select(:id, :name, :latitude, :longitude)}
    return all_districts.collect{|d| [d.name, d.id] }
  end

  # Get the districts geocodes, when localizing districts on map.
  def districts_geocodes
    all_districts = Rails.cache.fetch(CACHE_DISTRICTS) {District.select(:id, :name, :latitude, :longitude)}
    results = {}
    all_districts.each do |d|
      results[d.id] = [d.latitude, d.longitude]
    end
    return results
  end

  # Returns different available area types.
  def area_type
    types = Rails.cache.fetch(CACHE_AREA_TYPE) {Setting.find_by_key('area_type').value}
    if types
      types = types.split(',')
    else
      types = []
    end
    return types
  end

end