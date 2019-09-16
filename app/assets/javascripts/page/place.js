/* global $ */
//= require component/rator
//= require component/recaptcha
//= require component/tinymce
//= require component/slideshow

pollution.components.map.init('place_map', { zoom: 16, type: 'data', popup: gon.place_address, scrollWheelZoom: false })

pollution.components.rator.deferred_bind($('.action-bar .rator'), function(v, $element) {
  $element.attr('href', $element.attr('data-href-template').replace(/_v_/g, v))
  xhr($element)
})

pollution.components.rator.deferred_bind($('.action-bar .favoritor'), function(v, $element) {
  $element.attr('href', $element.attr('data-href-template').replace(/_v_/g, v))
  xhr($element)
})

// var report_dialog = $('[data-bind="place_report"]')
$(document).on('click', '#place_report_send', function () {
  var v = $('#place_report_reason').val()
  if(v !== '') {
    $element = $('#place_report_link')
    $element.attr('href', $element.attr('data-href-template').replace(/_v_/g, v))
    xhr($element)
    pollution.components.dialog.close()
    $('#place_report_reason').val('')
  }
})

// when click on tab, show the panel
$(document).on('click', '.place-services .service-tabs .service-tab', function(){
  var $panels = $('.place-services .service-panels .service-panel .service-content')
  var $headers = $('.place-services .service-panels .service-panel h3')
  var $active_tab = $('.place-services .service-tabs .service-tab.active')
  var $active_panel = $panels.filter(':visible')
  var $active_header = $headers.filter('.active')
  var $new_active_panel = $panels.filter('[data-service-id="' + $(this).data('service-id') + '"]')
  var $new_active_header = $new_active_panel.siblings('h3')

  if ($active_tab.data('service-id') == $(this).data('service-id')){
    // turn off the panel
    $active_tab.removeClass('active')
    $active_header.removeClass('active')
    $active_panel.fadeOut()
  }else{
    // show the new panel

    // if something already active, turn it off
    if ($active_tab){
      $active_tab.removeClass('active')
      $active_header.removeClass('active')
      $active_panel.fadeOut()
    }

    // show the panel
    $(this).addClass('active')
    $new_active_header.addClass('active')
    $new_active_panel.slideDown()
  }
})

// when click on header, show the panel
$(document).on('click', '.place-services .service-panels .service-panel h3', function(){
  var $panel = $(this).find('+ .service-content')
  var $tabs = $('.place-services .service-tabs .service-tab')
  var $active_tab = $tabs.filter('.active')
  var $new_active_tab = $tabs.filter('[data-service-id="' + $panel.data('service-id') + '"]')

  if ($(this).hasClass('active')){
    // turn it off
    $(this).removeClass('active')
    $active_tab.removeClass('active')
    $panel.fadeOut()
    $panel.slideUp()
  }else{
    // turn it on
    $(this).addClass('active')
    $new_active_tab.addClass('active')
    $panel.slideDown()
  }
})


// if service tabs have wrapped text, adjust them so text is vertically centered
(function() {
  test_for_service_block_text_wrap($('.content .details-wrapper .details .place-services .service-tabs .service-tab'))

  // when resize, check the text wrap again
  $(window).resize(function(evt){
    test_for_service_block_text_wrap($('.content .details-wrapper .details .place-services .service-tabs .service-tab'))
  })
}())

