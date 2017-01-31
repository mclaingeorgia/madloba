global = this

global.NavigationBar = ->
  @searchedAdItems = new Bloodhound(
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('value')
    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote:
      url: '/getItems?item=QUERY&type=search_post_items'
      wildcard: 'QUERY')
  @searchedAdItems.clearPrefetchCache()
  @searchedAdItems.initialize()
  @init()

NavigationBar::init = ->
  _this = this
  # Press Enter to valid search form.
  $('#nav_search_form input').keypress (event) ->
    if event.which == 13
      event.preventDefault()
      _this.getLocationsPropositions()

  # Event tied to "up" arrow, to go back to the top of the page.
  $('#navbar-up-link').click ->
    $('html, body').animate { scrollTop: 0 }, 1000

  # Navigation - Search form: Ajax call to get locations proposition, based on user input in this form.
  $('#btn-form-search').click ->
    _this.getLocationsPropositions()

  # Popover when "Sign in / Register" link is clicked, in the navigation bar.
  $('#popover').popover
    html: true
    placement: 'bottom'
    title: ->
      $('#popover-head').html()
    content: ->
      $('#popover-content').html()

  # Type-ahead for the item text field, in the main navigation bar.
  # searched_post_items object is initialized in home layout template.
  $('#item').typeahead null,
    name: 'item-search'
    display: 'value'
    source: _this.searchedAdItems

  # Changing the typeahead query, depending of user choice between "I'm giving away" and "I'm searching for".
  $('#q').change(->
    _this.searchedAdItems.remote.url = '/getItems?item=QUERY&type=search_post_items&q=' + $('#q').val()
    # As the type of search changes, the item name field needs to be reset.
    $('#item').val ''
  ).change()

  # If search field, when clicking on selection, if it is an post title, redirect to this post.
  $('.typeahead').on 'typeahead:selected', (evt, item) ->
    if typeof item['post_id'] != 'undefined'
      post_id = item['post_id']
      $.ajax
        url: 'posts/goToService'
        type: 'GET'
        data: post: item['post_id']

  @initEventsAttachedToLinks()


###
# Before submitting the form with the location, we first do an Ajax call to see
# if the Nominatim webservice comes back with several addresses.
#
# if it does, we show a modal window with this list of addresses. Once one is chosen,
# the form is submitted.
###
NavigationBar::getLocationsPropositions = ->
  if $('#location').val() != ''
    # A location has been entered, let's use the Nominatim web service
    locationInput = $('#location').val()
    $.ajax
      url: '/getNominatimLocationResponses'
      global: false
      type: 'GET'
      data: location: locationInput
      cache: false
      beforeSend: (xhr) ->
        xhr.setRequestHeader 'Accept', 'application/json'
        xhr.setRequestHeader 'Content-Type', 'application/json'
        $('#btn-form-search').html 'Loading...'
        return
      success: (data) ->
        modalHtmlText = ''
        if data != null and data.length > 0
          if typeof data[0]['error_key'] != 'undefined'
            # There's been an error while retrieving info from Nominatim,
            # or there is no result found for this address.
            $('#search_error_message').html '<strong>' + data[0]['error_key'] + '</strong>'
          else
            # Address suggestions were found.
            # We need to create the HTML body of the modal window, based on the location proposition from OpenStreetMap.
            modalHtmlText = '<p>Choose one of the following available locations</p><ul></ul>'
            # We also need to consider whether an item is being searched/given at the same time.
            item = $('#item').val()
            search_action = $('#q').val()
            i = 0
            while i < data.length
              proposed_location = data[i]
              url = "/services/"+proposed_location['id']
              if item != ''
                url = url + '&item=' + item
              modalHtmlText = modalHtmlText + '<li><a href=\'' + encodeURI(url) + '\'>' +
                  proposed_location['display_name'] + '</a></li>'
              
              i++
            modalHtmlText = modalHtmlText + '</ul>'
            $('#modal-body-id').html modalHtmlText
            options =
              'backdrop': 'static'
              'show': 'true'
            $('#basicModal').modal options
        # Webservice response came back - button label goes back to "Search"
        $('#btn-form-search').html 'Search'

  else if $('#item').val() != '' or $('#user_action').val() != ''
    # no location is being searched, but an item is. We need to submit the form with this information.
    $('#nav_search_form').submit()
    
NavigationBar::initEventsAttachedToLinks = ->
  # Home page: When clicking on about, scroll to the home page upper footer.
  $('#about-nav-link').click ->
    $('html, body').animate { scrollTop: $('#upper-footer-id').offset().top }, 2000
    return
  # Offcanvas related scripts
  $('[data-toggle=offcanvas]').click ->
    $('.row-offcanvas').toggleClass 'active'
    return
  # This event replaces the 'zoomToBoundsOnClick' MarkerCluster option. When clicking on a marker cluster,
  # 'zoomToBoundsOnClick' would zoom in too much, and push the markers to the edge of the screen.
  # This event underneath fixes this behaviour, the markers are not pushed to the boundaries of the map anymore.
  if markers.group != ''
    markers.group.on 'clusterclick', (a) ->
      bounds = a.layer.getBounds().pad(0.5)
      leaf.map.fitBounds bounds
      return
  # This is to correct a behavior that was happening in Chrome: when clicking on the zoom control panel, in the home page, the page would scroll down.
  # When clicking on zoom in/zoom out, this will force to be at the top of the page
  $('#home-map-canvas-wrapper .leaflet-control-zoom-out, #home-map-canvas-wrapper .leaflet-control-zoom-in').click ->
    $('html, body').animate { scrollTop: 0 }, 0
    return
  # Ad show page: event triggered when clicking on "Add to favorite" button
  $('.add_to_favorite_button').click ->
    addFavorite $(this)
    return
  # Ad show page: event triggered when clicking on "Remove from favorite" button
  $('.remove_favorite_button').click ->
    removeFavorite $(this)
    return
  # Admin favorite page: event triggered when clicking on "Remove" link
  $('.remove_favorite').click ->
    removeFavorite $(this)
    return
  # Sign up page - event for modal window when click on Terms and Conditions link.
  $('.terms_popup').click ->
    $('#terms_modal').modal 'show'
    return
