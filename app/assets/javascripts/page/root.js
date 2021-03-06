//= require component/loader
// require component/rator
//= require component/favoritor
// require component/services
//= require component/age
//= require component/filter
//= require component/place_card
//= require select2

pollution.components.map.init('places_map', { zoom: 7, type: 'coordinates' })
pollution.components.filter.init()

$(document).on('click', '.result .region-name', function() {
  var p = $(this).parent()
  p.toggleClass('collapsed')
  $('.result').find('.place-card[data-region-id="' + p.attr('data-id') + '"]').toggleClass('hidden', p.hasClass('collapsed'))
})

// show/hide map on mobile under list of services
$(document).on('click', '[toggle-view]', function() {
  var t = $(this)
  var view = t.attr('toggle-view')
  var is_map_view = view === 'show'

  $('[toggle-view]').removeClass('mobile-hidden')
  t.addClass('mobile-hidden')
  $('.mapper').toggleClass('mobile-hidden', !is_map_view)
   pollution.elements.places_map.invalidateSize()
})

// show/hide map on mobile for a particular place
$(document).on('click', '[toggle-place-map]', function() {
  var t = $(this)
  var view = t.attr('toggle-place-map')
  var is_map_view = view === 'show'
  var $map_view = t.closest('.front').find('.map-view')

  t.siblings().removeClass('mobile-hidden')
  t.addClass('mobile-hidden')
  $map_view.toggleClass('mobile-hidden', !is_map_view)

  // if showing map and map does not exist,
  // create it
  if (is_map_view && $map_view.is(':empty')){
    pollution.components.map.init($map_view.attr('id'), { zoom: 16, type: 'data' })
  }

})


// when an age filter is selected, show/hide the services that have/do not that age group
// age filter is radio button so also provide way to turn off radio selection
// var current_age_selection;
// var age_value;
// var age_radios = $('input[name="age"]');
// for(var i = 0; i < age_radios.length; i++){
//   age_radios[i].onclick = function() {
//     record_current_age_filter(this);
//     update_service_visibility(this);
//   };
// }

// function record_current_age_filter(ths){
//   // deselect the item if necessary
//   if(current_age_selection == ths){
//     ths.checked = false;
//     current_age_selection = null;
//   } else {
//     current_age_selection = ths;
//     age_value = $(ths).val();
//   }
// }

// // update the service visibility
// // - if nothing is selected, then show all services
// function update_service_visibility(ths){
//   if (current_age_selection == null){
//     // show all
//     $('.services li').show();
//   }else{
//     // show only services that have this age match
//     $('.services li[data-' + age_value + '="true"]').show()
//     $('.services li[data-' + age_value + '="false"]').hide()
//   }
// }

// // initialize
// var age_initial_selection = $('input[name="age"]:checked').get(0)
// if (age_initial_selection){
//   record_current_age_filter(age_initial_selection);
//   update_service_visibility(age_initial_selection);
// }
