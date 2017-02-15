global = this

global.Home = (locations_exact, areas, params, marker_colors) ->
  markers.locations_exact = locations_exact
  markers.areas = areas
  markers.marker_colors = marker_colors

  @params = params

  @init()
  @putLocationMarkers()

Home::init = ->
  # This is to correct a behavior that was happening in Chrome: when clicking on the zoom control panel,
  # in the home page, the page would scroll down.
  # When clicking on zoom in/zoom out, this will force to be at the top of the page
  $('.leaflet-control-zoom-out, .leaflet-control-zoom-in').click ->
    $('html, body').animate { scrollTop: 0 }, 0

  # Initialize the sidebars on the home page. Open it on load (not on mobile)
  L.control.sidebar('sidebar').addTo(leaf.map)
  L.control.sidebar('search_result', {position: 'right'}).addTo(leaf.map)
  if !$('.navbar-toggle').is(':visible')
    $('#sidebar_category_icon').trigger('click')

  # After choosing an area, moves the map to where it is.
  leaf.moveMapBasedOnArea({showAreaIcon: true, zoom: 11})

  if @params.item
    global.navState.populateSearchResultsSidebar(markers.locations_exact, false)

  # Update left sidebar with info related to url params
  global.navState.applyQueryParams(@params)

  @updateUrlWhenMovingMap()

  # Ajax calls made when choosing a category, in the sidebar.
  @refineMarkers()

  # Update left sidebar height()
  updateCategorySidebarHeight()


###*
# Populates the map with different markers (eg exact address and area-type markers, to show posts)
# @param locations_hash - hash containing the info to create all different markers.
###
Home::putLocationMarkers = ->
  _this = this
  # The MarkerClusterGroup object will allow to aggregate location markers (both 'exact location' and 'area' markers),
  # when they get too close to one another, as the user zooms out, on the home page.
  markers.group = new (L.markerClusterGroup)(
    spiderfyDistanceMultiplier: 2)
  markers.area_group = L.featureGroup().addTo(leaf.map)

  # Displaying markers on map
  markers.place_exact_locations_markers(markers.locations_exact, false)

  # Creating area markers and registering them (showing one area marker at a time when area selected in the sidebar)
  markers.registerAreaMarkers(markers.areas, false)

  # Event to trigger when click on a link in an area popup, on the home page map. Makes a modal window appear.
  # Server side is in home_controller, method showSpecificPosts.
  $('#map').on 'click', '.area_link', ->
    input = $(this).attr('id').split('|')
    $.get '/showSpecificPosts', {
      item: input[0]
      type: input[1]
      area: input[2]
    }, (data) ->
      html_to_append = '<ul>'
      i = 0
      while i < data['posts'].length
        post = data['posts'][i]
        html_to_append = html_to_append + '<li><a href="/posts/' + post['id'] + '/">' + post['title'] + '</a></li>'
        i++
      html_to_append = html_to_append + '</ul>'
      $('#posts-modal-body-id').html html_to_append
      icon = ''
      if typeof data['icon'] != 'undefined'
        icon = '<i class="fa ' + data['icon'] + '" style="color: ' + data['hexa_color'] + '; padding-right: 10px;"></i>'

      resultModalTitle = gon.vars['posts_for'] + ' \'' + input[0].capitalizeFirstLetter() + '\' - ' + data['area_name']
      $('#postsModalTitle').html icon + resultModalTitle
      options =
        'backdrop': 'static'
        'show': 'true'
      $('#postsModal').modal options

  searched_location_marker = ''
  if typeof leaf.searched_address != 'undefined'
    # Adding marker for the searched address, on the home page.
    searchedLocationMarker = L.marker([
      leaf.my_lat
      leaf.my_lng
    ], icon: markers.default_icon)

    popup = L.popup().setContent(leaf.searched_address)

    searchedLocationMarker.bindPopup popup
    searchedLocationMarker.addTo leaf.map
    searchedLocationMarker.openPopup()
    leaf.map.flyTo([leaf.my_lat, leaf.my_lng], 15, {animate: true})

  # Adding all the markers to the map.
  leaf.map.addLayer markers.group

  if searched_location_marker != ''
    searched_location_marker.openPopup()

Home::updateUrlWhenMovingMap = ->
  leaf.map.on 'dragend zoomend', ->
    current_url = window.location.href
    updated_url = addOrUpdateUrlParam('lat', leaf.map.getCenter().lat, current_url)
    updated_url = addOrUpdateUrlParam('lon', leaf.map.getCenter().lng, updated_url)
    history.pushState '', '', updated_url
    return

  leaf.map.on 'zoomend', ->
    current_url = window.location.href
    updated_url = addOrUpdateUrlParam('zoom', leaf.map.getZoom(), current_url)
    history.pushState '', '', updated_url
    return


Home::refineMarkers = ->
  _this = this
  $('#sidebar').on 'click', '.guided-nav-category', ->
    # Copying the html of the selected category
    # and inserting it in the "Selected categories" section.
    selectedLinkHtml = $(this).clone()
    link_id = $(this).attr('id')
    if global.navState.cat.indexOf(link_id) > -1
      # User is removing this category from the "Your selection" section.
      selectedLinkHtml.find('i.align-cross').remove()
      $('#available_categories').append selectedLinkHtml.prop('outerHTML')
      # Deleting the html of the selected category in initial list.
      $(this).remove()
      global.navState.cat = jQuery.grep(global.navState.cat, (value) ->
        value != link_id
      )
      if global.navState.cat.length == 0
        $('#refinements').html ''
    else
      # User is selecting this category to refine their search.
      selectedLinkHtml.append '<i class=\'glyphicon glyphicon-remove align-cross\' style=\'float: right;\'></i>'
      $('#refinements').append selectedLinkHtml.prop('outerHTML')

      # Deleting the html of the selected category in initial list.
      $(this).remove()
      global.navState.cat.push $(this).attr('id')

    global.navState.getMarkersFromNavState()



Home::sendNavState = (state) ->
  $.get 'refine_state', {
    state: state
  }, (data) =>
    # After receiving new data, we first need to clear all the current layers.
    new_map_info = data.map_info

    if markers.group != ''
      markers.group.clearLayers()
    if markers.area_group != ''
      markers.area_group.clearLayers()

    markers.locations_exact = new_map_info['markers']

    # Then we place the different markers and areas.
    markers.place_exact_locations_markers(new_map_info['markers'], false)

    @updateURL

    return


addOrUpdateUrlParam = (name, value, current_url) ->
  href = current_url
  regex = new RegExp('[&\\?]' + name + '=')
  if regex.test(href)
    if name == 'zoom'
      regex = new RegExp('([&\\?])' + name + '=\\d+')
    else
      regex = new RegExp('([&\\?])' + name + '=\\-?\\d+\\.\\d+')
    current_url = href.replace(regex, '$1' + name + '=' + value)
  else
    if href.indexOf('?') > -1
      current_url = href + '&' + name + '=' + value
    else
      current_url = href + '?' + name + '=' + value
  current_url
