//= require component/loader
//= require component/rator
//= require component/favoritor
//= require component/services
//= require component/filter
//= require component/place_card

pollution.components.map.init('places_map', { zoom: 8, type: 'coordinates', locate: true })
pollution.components.filter.init()

$(document).on('click', '.result .region-name', function() {
  var p = $(this).parent()
  p.toggleClass('collapsed')
  $('.result').find('.place-card[data-region-id="' + p.attr('data-id') + '"]').toggleClass('hidden', p.hasClass('collapsed'))
})

$(document).on('click', '[toggle-view]', function() {
  var t = $(this)
  var view = t.attr('toggle-view')
  var is_map_view = view === 'map'

  $('[toggle-view]').removeClass('mobile-hidden')
  t.addClass('mobile-hidden')
  $('.result-container').toggleClass('mobile-hidden', is_map_view)
  $('.mapper').toggleClass('mobile-hidden', !is_map_view)
   pollution.elements.places_map.invalidateSize()
})
