(function() {
  var select_service = {
    els: {},
    init: function () {
      var t = select_service
      t.els['root-services'] = $('body.places.select_service .root-services')
      t.els['sub-services'] = $('body.places.select_service .sub-services')
      t.els['active-sub-services'] = $('body.places.select_service .active-sub-services')
      t.els['no-selection'] = $('body.places.select_service .no-selection')

      t.bind()

      return t
    },

    bind: function () {
      // click on root service
      var t = select_service

      $(t.els['root-services']).on('click', 'li', function(evt){
        t.show_service_details($(evt.target))
      })

    },
    show_service_details: function($root_service_li){
      var t = select_service
      var no_active_service = $root_service_li.hasClass('active')

      // turn off all other root services
      $(t.els['root-services']).find('li.active').removeClass('active')

      if (!no_active_service){
        // turn this service on
        $root_service_li.addClass('active')
      }

      // clear any previous sub-service selection
      t.els['active-sub-services'].empty()

      if (no_active_service){
        // the user is turning off this service so hide the sub-services
        t.els['no-selection'].addClass('active')
      }else{
        // show the sub-services for this service
        t.els['no-selection'].removeClass('active')

        var $lis = t.els['sub-services'].find('li[data-parent-id="' + $root_service_li.data('id') + '"]')
        if ($lis.length === 0){
          // this item has not sub-services so get the service itself
          $lis = t.els['sub-services'].find('li[data-id="' + $root_service_li.data('id') + '"]')
        }

        $lis.clone().appendTo(t.els['active-sub-services'])

      }


    }
  }

  select_service.init()
}())
