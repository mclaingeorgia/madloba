# Using this root context variable to define global variables later on.
global = this

$ ->
  # Show Bootstrap notify on load, when needed
  if $('body').data('message').length > 0
    createNotification($('body').data('message'), $('body').data('alert'))

###*
# Initialization of the leaf object (called 'leaf' as because of the main use of the Leaflet library :) )
# This object attributes consists of the map object, map tiles and other map-related objects.
###
global.leaf =
  map: null
  mapSettings: null
  map_tiles: null
  my_lat: ''
  my_lng: ''
  areas: null
  searched_address: ''

  init: (map_settings) ->
    leaf.map = L.map('map', scrollWheelZoom: false)

    leaf.map.on 'click', ->
      if leaf.map.scrollWheelZoom.enabled()
        leaf.map.scrollWheelZoom.disable()
      else
        leaf.map.scrollWheelZoom.enable()

    leaf.mapSettings = map_settings

    leaf.my_lat = map_settings['latitude']
    leaf.my_lng = map_settings['longitude']
    leaf.searched_address = map_settings['searched_address']

    if map_settings['chosen_map'] == 'map_quest'
      # Loading Mapquest tiles
      leaf.map_tiles = MQ.mapLayer()
    else if map_settings['chosen_map'] == 'open_street_map'
      # Loading Openstreetmap tiles
      leaf.map_tiles = L.tileLayer(map_settings['osm_tile_url'], attribution: map_settings['osm_attribution'])
    else if map_settings['chosen_map'] == 'mapbox'
      # Loading Mapbox tiles
      leaf.map_tiles = L.tileLayer(map_settings['mapbox_tile_url'], attribution: map_settings['mapbox_attribution'])

    leaf.map_tiles.addTo leaf.map
    leaf.map.setView [leaf.my_lat, leaf.my_lng], map_settings['zoom_level']


  show_single_marker: (map_settings) ->
    # we are displaying the center point.
    center_marker = L.marker([
      leaf.my_lat
      leaf.my_lng
    ], icon: markers.default_icon)
    if map_settings['marker_message'] != ''
      center_marker.addTo(leaf.map).bindPopup(map_settings['marker_message']).openPopup()
    else
      center_marker.addTo leaf.map

    return


  moveMapBasedOnArea: (opts) ->
    $('.area-select').on('change', ->
      selectedOption = $('.area-select option:selected')

      if markers.selected_area != ''
        leaf.map.removeLayer markers.selected_area

      # Home page: close sidebar when changing location
      if $('#sidebar_category_icon').length > 0 && $('.navbar-toggle').is(':visible')
        $('#sidebar_category_icon').trigger('click')

      if selectedOption.val() != ''
        latitude = selectedOption.data('latitude')
        longitude = selectedOption.data('longitude')

        leaf.map.flyTo([latitude, longitude], opts.zoom, {animate: true})

        if opts.showAreaIcon
          markers.selected_area = markers.area_markers[selectedOption.val()]
          markers.selected_area.addTo(leaf.map)
          leaf.map.once 'zoomend', ->
            markers.selected_area.fireEvent('click')
    )
    

  show_single_area: (area_name) ->
    # Before adding the selected area, we need to remove all the currently displayed areas.
    if markers.selected_area != ''
      leaf.map.removeLayer markers.selected_area
    latlng = ''
    latlng



global.navState =
  cat: []
  q: ''
  item: ''
  lat: ''
  lon: ''

  stringifyState: ->
    fullState = ''
    if global.navState.cat.length > 0
      fullState = 'cat='
      fullState += global.navState.cat.join('+')
    if global.navState.item != ''
      fullState = global.navState.append_to_state(fullState, 'item', global.navState.item)
    if global.navState.q != ''
      fullState = global.navState.append_to_state(fullState, 'q', global.navState.q)
    if global.navState.lat != ''
      fullState = global.navState.append_to_state(fullState, 'lat', global.navState.lat)
    if global.navState.lon != ''
      fullState = global.navState.append_to_state(fullState, 'lon', global.navState.lon)
    fullState

  append_to_state: (complete_state, param, value) ->
    if complete_state != ''
      complete_state = complete_state + '&' + param + '=' + value
    else
      complete_state = param + '=' + value
    complete_state


  getMarkersFromNavState:  ->
    $.ajax
      url: '/refine_state'
      global: false
      type: 'GET'
      data:
        categories: global.navState.cat
        item: global.navState.item
      dataType: 'html'
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'Accept', 'text/html-partial'
      success: (data) ->
        # After receiving new data, we first need to clear all the current layers.
        global.navState.updateMarkersOnMap(data)
        return

  updateMarkersOnMap: (data) ->
    new_map_info = JSON.parse(data)

    if markers.group != ''
      markers.group.clearLayers()
    if markers.area_group != ''
      markers.area_group.clearLayers()

    markers.locations_exact = new_map_info.markers

    # Then we place the different markers .
    markers.place_exact_locations_markers(new_map_info.markers, false)
    global.navState.updateURL()

  populateSearchResultsSidebar: (results, withContent = true) ->
    $("#search_result").removeClass('hide')
    if !$('.search-panes').is(':visible')
      $('#search_result_icon').trigger('click')
    if withContent
      $("#result_list").html(results)

  # This method allows to update the URL without redirecting, when a category is selected.
  # By doing so, we give the user the possibility to reload the page on a specific category nav state.
  updateURL: ->
    params = location.search
    port = if location.port.length > 0 then ':'+location.port else ''
    urlBase = location.protocol+'//'+location.hostname+port
    newUrl = urlBase+'?'+global.navState.stringifyState()

    history.replaceState {}, '', newUrl
    return

  applyQueryParams:  (params)->
    if params.q
      $('.searching-giving h5').addClass('hide')
      $('.searching-giving .'+params.q).removeClass('hide')

    if params.item
      $('.queried-item').removeClass('hide')
      $('.queried-item span').html(params.item)



###*
# Object gathering different markers and icons that are used on the Madloba maps.
###
global.markers =
  new_marker: ''
  selected_area: ''
  group: ''
  area_group: ''
  locations_exact: null
  areas: null

  default_icon: null
  new_icon: null
  area_icon: null

  area_markers: {}

  selected_categories: []
  marker_colors: null
  area_color: null
  area_geocodes: null
  center_marker: null
  init: (map_settings) ->

    markers.default_icon = L.icon(
      iconUrl: map_settings['default_marker_icon']
      iconAnchor: [12,41]
      popupAnchor: [0,-34])

    markers.new_icon = L.icon(
      iconUrl: map_settings['new_marker_icon']
      iconAnchor: [12,41]
      popupAnchor: [0,-34])

    markers.area_icon = L.icon(
      iconUrl: area_marker
      iconAnchor: [15,43]
      popupAnchor: [1,-34])

    markers.area_color = map_settings['area_color']
    return

  place_exact_locations_markers: (locations_exact, is_bouncing_on_add) ->
    i = 0
    while i < locations_exact.length
      post = locations_exact[i]
      l = 0
      while l < post['locations'].length
        location = post['locations'][l]
        j = 0
        while j < post['markers'].length

          category = post['markers'][j]

          if markers.canCategoryBeDisplayed(category.category_id)
            # Creating the marker for this post here.
            marker_icon = L.AwesomeMarkers.icon(
              prefix: 'fa'
              markerColor: category['color']
              icon: category['icon'])

            marker = L.marker([location['lat'], location['lng']],
              icon: marker_icon
              bounceOnAdd: is_bouncing_on_add)

            marker.post_id = post['post_id']
            marker.category_id = category.category_id
            marker.location_id = location.location_id

            popup = L.popup(
              minWidth: 250
              maxWidth: 280).setContent('Loading...')

            marker.bindPopup popup, popupOptions()
            # When a marker is clicked, an Ajax call is made to get the content of the popup to display
            marker.on 'click', (e) ->
              marker_popup = e.target.getPopup()

              $.ajax
                url: '/showPostPopup'
                global: false
                type: 'GET'
                data:
                  post_id: @post_id
                  category_id: @category_id
                  location_id: @location_id
                dataType: 'html'
                beforeSend: (xhr) ->
                  xhr.setRequestHeader 'Accept', 'text/html-partial'
                success: (data) ->
                  $(marker_popup._container).removeClass('area-popup').addClass('area-popup-no-margin')
                  marker_popup.setContent data
                  marker_popup.update()
                  adjustPopupPosition(marker_popup, 'exact')
                error: (data) ->
                  marker_popup.setContent data
                  marker_popup.update()
              return
            markers.group.addLayer marker
          j++
        l++
      i++
    return

  registerAreaMarkers: (areas) ->
    for area in areas
      # Adding area marker
      marker = L.marker(
        [area.latitude, area.longitude],
        icon: markers.area_icon,
        bounceOnAdd: false,
        areaId: area.id
      )

      popup = L.popup().setContent('Loading...')
      marker.bindPopup popup, popupOptions()

      marker.on 'click', (e) ->
        marker_popup = e.target.getPopup()
        $.ajax
          url: '/showAreaPopup'
          global: false
          type: 'GET'
          data:
            area_id: e.target.options.areaId
            area_marker: true
          dataType: 'html'
          beforeSend: (xhr) ->
            xhr.setRequestHeader 'Accept', 'text/html-partial'
          success: (data) ->
            $(marker_popup._container).removeClass('area-popup').addClass('area-popup-no-margin')
            marker_popup.setContent data
            marker_popup.update()
            adjustPopupPosition(marker_popup, 'area')
          error: (data) ->
            marker_popup.setContent data
            marker_popup.update()

      markers.area_markers[area.id] = marker
      
    return  

  # We show on the map all the markers if there's no specific navigation state.
  # If there's one, we show only the markers which category are in the nav state.
  canCategoryBeDisplayed: (categoryId) ->
    markers.selected_categories.length == 0 ||
      categoryId.toString() in markers.selected_categories



###*
# Main function that initializes the map on different screens (eg home page, map setting page, post page...).
# @param map_settings - hash that contains all info needed to initialize the map.
###

global.initLeafletMap = (map_settings) ->
  if leaf != null and leaf.map != null
    leaf.map.remove()

  # Initialization of the map and markers.
  leaf.init map_settings
  markers.init map_settings


###*
# This function draws areas (where at least one current post is included)
# on the map of the home page.
###
global.drawAreasOnMap = (locations_area) ->
  Object.keys(locations_area).forEach (area_id) ->
    locations = locations_area[area_id]
    area_name = markers.area_geocodes[area_id]['name']
    area_bounds = markers.area_geocodes[area_id]['bounds']

    # Adding the areas (which have posts) to the home page map.
    areaLayer = L.geoJson JSON.parse(area_bounds), onEachFeature: (feature, layer) ->
      layer.setStyle color: markers.area_color
      markers.area_group.addLayer layer
      return

    areaLayer.on 'click', (e) ->
      _layer = e.layer
      $.ajax
        url: '/showAreaPopup'
        global: false
        type: 'GET'
        data:
          area_id: area_id
          area_marker: false
        dataType: 'html'
        beforeSend: (xhr) ->
          _layer.bindPopup 'Loading...', popupOptions()
          _layer.openPopup()
          xhr.setRequestHeader 'Accept', 'text/html-partial'
        success: (data) ->
          _layer.unbindPopup()
          _layer.bindPopup data
          markers.area_group.addLayer _layer
          _layer.off('click')
          _layer.openPopup()
          adjustPopupPosition(_layer.getPopup(), 'area')
        error: (data) ->
          _layer.unbindPopup()
          _layer.bindPopup data
          _layer.openPopup()
    return
  return


###*
# Defines latitude and longitude, after a click on a map (eg on map settings page...).
# Updates hidden fields, if needed, if the geocodes are part of a form.
###
global.onMapClickLocation = (e) ->
  geocodes = onMapClick(e)

  # latitude and longitude are classes used on area settings page.
  $('#new_dynamic_button_add').removeClass 'disabled'
  $('.latitude').val geocodes.lat
  $('.longitude').val geocodes.lng


# Event triggered when click on "Locate me on the map" button,
# on the "Create post" form, and on the Ad edit form.
global.find_geocodes = ->
  $('#find_geocodes_from_address').button().click ->
    location_type = 'exact'
      
    # Ajax call to get geocodes (latitude, longitude) of an exact location defined by address, postal code, city...
    # This call is triggered by "Find this city", "Find this general location" buttons,
    # on Map settings page, location edit page, map setup page...
    $.ajax
      url: '/getCityGeocodes'
      global: false
      type: 'GET'
      data:
        street_number: $('.location_streetnumber').val()
        address: $('.location_streetname').val()
        city: $('.location_city').val()
        province: $('.location_state').val()
        country: $('.location_country').val()
      cache: false
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'Accept', 'application/json'
        xhr.setRequestHeader 'Content-Type', 'application/json'
        $('#find_geocode_loader').html gon.vars['searching_location']
        return
      success: (data) ->
        if data != null and data.status == 'ok'
          # Geocodes were found: the location is shown on the map.
          latitude = Math.round(data.lat * 100000) / 100000
          longitude = Math.round(data.lon * 100000) / 100000

          $('.latitude').val latitude
          $('.longitude').val longitude

          # Update the center of map, to show the general area
          leaf.map.flyTo([latitude, longitude], 16, {animate: true})
        else
          # The address' geocodes were not found - the user has to pinpoint the location manually on the map.
          $('#myErrorModal').modal 'show'
        # Displaying notification about location found.
        $('#find_geocode_loader').html '<i>' + data.address_found + '</i>'


# This event replaces the 'zoomToBoundsOnClick' MarkerCluster option. When clicking on a marker cluster,
# 'zoomToBoundsOnClick' would zoom in too much, and push the markers to the edge of the screen.
# This event underneath fixes this behaviour, the markers are not pushed to the boundaries of the map anymore.
global.spiderifyMarkerGroups = ->
  if markers.group != ''
    markers.group.on 'clusterclick', (a) ->
      bounds = a.layer.getBounds().pad(0.5)
      leaf.map.fitBounds bounds


# Notification
global.createNotification = (message, alert) ->
  $.notify message,
    offset:
      x: 10
      y: 60
    type: alert
    placement:
      from: 'top'
      align: 'right'

# Center popup based on its content, by positioning the clicked maker correctly.
global.adjustPopupPosition = (popup, popup_type) ->
  px = leaf.map.project(popup.getLatLng())
  offset = 0
  if popup_type == 'exact'
    offset = 100
  px.y -= popup._container.clientHeight/2 + offset
  if !$('.sidebar').hasClass('collapsed')
    px.x -= 140
  leaf.map.panTo(leaf.map.unproject(px),{animate: true})

# Option to attach to popup, on bindPopup event  
global.popupOptions = (otherOpts) ->
  opts = {className: 'area-popup'}
  for key, val of otherOpts
    opts[key] = val
  opts


global.initMapClick = (e) ->
  if markers.new_marker != ''
    leaf.map.removeLayer markers.new_marker
    
  myNewLat = e.latlng.lat
  myNewLng = e.latlng.lng
  # Rounding up latitude and longitude, with 5 decimals
  myNewLat = Math.round(myNewLat * 100000) / 100000
  myNewLng = Math.round(myNewLng * 100000) / 100000
  {lat: myNewLat, lng: myNewLng}



###*
# Event triggered when clicking on "Add to favorite" button
# @param obj
###

global.addFavorite = (obj) ->
  btn = obj
  $.ajax
    url: '/user/favorite/add'
    global: false
    type: 'POST'
    data:
      post_id: btn.attr('id')
    success: (data) ->
      if data.status == 'ok'
        btn.removeClass('add_to_favorite_button btn-warning').addClass 'btn-danger remove_favorite_button'
        btn.html '<i class=\'glyphicon glyphicon-star\'></i>&nbsp;' + gon.vars['remove_from_favorites']
        $('#post_star').show()
        btn.unbind()
        btn.on 'click', ->
          removeFavorite obj
          return
      else
        $('#error_remove').html 'Sorry, server error occured. Try again later.'

    error: (data) ->
      $('#error_remove').html 'Sorry, server error occured. Try again later.'



###*
# Event triggered when clicking on "Remove from favorite" button
# @param obj
###
global.removeFavorite = (obj) ->
  btn = obj
  isInAdmin = obj.attr('class') == 'btn btn-danger remove_favorite'

  $.ajax
    url: '/user/favorite/remove'
    global: false
    type: 'POST'
    data:
      post_id: btn.attr('id')
    success: (data) ->
      if data.status == 'ok'
        if isInAdmin
          # admin favorite page : remove the whole line
          btn[0].closest('tr').remove()
        else
          # posts show page: change the button
          btn.addClass('add_to_favorite_button btn-warning').removeClass 'btn-danger remove_favorite_button'
          btn.html '<i class=\'glyphicon glyphicon-star\'></i>&nbsp;' + gon.vars['add_to_favorites']
          btn.unbind()
          $('#post_star').hide()
          btn.on 'click', ->
            addFavorite obj
            return
      else
        $('#error_remove').html 'Sorry, server error occured. Try again later.'

    error: (data) ->
      $('#error_remove').html 'Sorry, server error occured. Try again later.'


global.updateCategorySidebarHeight = ->
  $('.sidebar-left').height($('#category').height() + 50)
  
###*
# Callback function that returns geocodes of clicked location.
# @param e
# @returns "latitude,longitude"
###
onMapClick = (e) ->

  geocodes = initMapClick(e)
  markers.new_marker = new (L.Marker)(e.latlng, { icon: markers.new_icon }, draggable: false)
  leaf.map.addLayer markers.new_marker
  geocodes

String::capitalizeFirstLetter = ->
  @charAt(0).toUpperCase() + @slice(1)
