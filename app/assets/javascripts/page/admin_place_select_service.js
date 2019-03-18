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

      t.bind()

      return t
    },

    bind: function () {
      // click on root service
      var t = select_service

      $(t.els['root-services']).on('click', 'input[type="radio"]', function(evt){
        t.show_service_details($(evt.target))
      })

      $(t.els['active-sub-services']).on('click', 'input[type="checkbox"]', function(evt){
        t.toggle_submit_button()
      })
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

    }
  }

  select_service.init()
}())
