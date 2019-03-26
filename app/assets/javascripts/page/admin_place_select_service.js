(function() {
  var select_service = {
    els: {},
    init: function () {
      var t = select_service
      t.els['root-services'] = $('body.places.select_service .root-services')
      t.els['sub-services'] = $('body.places.select_service .sub-services')
      t.els['active-sub-services'] = $('body.places.select_service .active-sub-services')
      t.els['no-selection'] = $('body.places.select_service .no-selection')
      t.els['submit'] = $('body.places.select_service input[type="submit"]')
      t.els['service-container'] = $('body.places.select_service .service-selection-container')
      t.els['button'] = $('body.places.select_service button.show-root-services-selection')

      t.bind()
      t.check_screen_size()

      return t
    },

    bind: function () {
      var t = select_service

      // click on root service
      $(t.els['root-services']).on('click', 'input[type="radio"]', function(evt){
        t.show_service_details($(evt.target))
      })

      // click on sub service
      $(t.els['active-sub-services']).on('click', 'input[type="checkbox"]', function(evt){
        t.toggle_submit_button()
      })

      //
      $('.actions').on('click', t.els['button'], function(evt){
        t.show_categories()
      })

      // when resize check the screen size
      $(window).resize(function(evt){
        t.check_screen_size()
      })
    },
    check_screen_size: function(){
      var t = select_service

      // if the screen is small, hide the root services so the user can see the sub-services
      var w = $(document).width()
      var h = $(document).height()
      if ((w < 665 && h < 975) || (w > 665 && h < 740)){
        t.els['service-container'].addClass('for-mobile')
        $('.root-services-selection').show()
        $('.sub-services-selection').hide()
        t.els['button'].hide()
        t.els['submit'].removeClass('active')
      }else{
        t.els['service-container'].removeClass('for-mobile')
        $('.sub-services-selection').show()
        $('.root-services-selection').show()
        t.els['button'].hide()
      }
    },
    toggle_submit_button: function(){
      var t = select_service

      // if anything is checked, show the submit button, else hide it
      if (t.els['active-sub-services'].find('input[name="services[]"]:checked').length === 0){
        t.els['submit'].removeClass('active')
      }else{
        t.els['submit'].addClass('active')
      }
    },
    show_service_details: function($root_service_input){
      var t = select_service
      var select_by_default = false

      // clear any previous sub-service selection
      t.els['active-sub-services'].empty()

      // show the sub-services for this service
      t.els['no-selection'].removeClass('active')

      var $fields = t.els['sub-services'].find('.field-wrapper[data-parent-id="' + $root_service_input.data('id') + '"]')
      if ($fields.length === 0){
        // this item has not sub-services so get the service itself
        $fields = t.els['sub-services'].find('.field-wrapper[data-id="' + $root_service_input.data('id') + '"]')
        select_by_default = true
      }

      $fields.clone().appendTo(t.els['active-sub-services'])
      if (select_by_default){
        t.els['active-sub-services'].find('input[type="checkbox"]').prop('checked', true)
      }

      t.toggle_submit_button()

      // if the screen is small, hide the root services so the user can see the sub-services
      if (t.els['service-container'].hasClass('for-mobile')){
        $('.root-services-selection').hide()
        $('.sub-services-selection').show()
        t.els['button'].show()
      }
    },
    show_categories: function(){
      var t = select_service
      $('.sub-services-selection').hide()
      $('.root-services-selection').show()
      t.els['button'].hide()

      // reset the radio button so nothing is highlighted
      t.els['root-services'].find('input').prop('checked', false)
    }
  }

  select_service.init()
}())
