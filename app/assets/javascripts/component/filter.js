/* global $ */

(function() {
  var filter = {
    el: undefined,
    names: ['what', 'where', 'age', 'favorite'], // plus map
    data: {},
    els: {},
    // result: [],
    results: [],
    dynamic_map: false,
    first: false,
    map: [],
    init: function () {
      var t = filter
      t.el = $('#filter')

      t.names.forEach(function(name) {
        t.els[name] = t.el.find('[data-filter="' + name + '"]')
      })
      t.els['map'] = $('#by_map')
      t.els['search'] = t.el.find('.search input[type="submit"]')
      t.els['results'] = t.el.find('.results')
      t.els['count'] = t.el.find('.info .count')
      t.bind()

      t.prepare_data()
      t.process_send()
      t.map_highlight_region(false)

      return t
    },
    prepare_data: function () {
      var t = filter
      var value

      // search
      t.set_data('what', t.els['what'].val())

      // region
      t.set_data('where', t.els['where'].val())

      // age
      value = pollution.components.age.get(t.els['age'])
      t.set_data('age', value)

      // services
      // value = pollution.components.services.get(t.els['services'])
      // t.set_data('services', (value.length > 0 ? value : undefined))

      // favorite
      value = pollution.components.favoritor.get(t.els['favorite'])
      // console.log('favorite value', value)
      t.set_data('favorite', (value === true ? true : undefined))


      var mp = pollution.elements['places_map']
      var map = JSON.parse(t.els['map'].attr('data-m'))

      if(map.length === 4) {
        mp.fitBounds([[map[0], map[1]],[map[2],map[3]]])
        t.first = true
      }
      // console.log('data to process_all', t.data)
    },
    process: function (type, value) {
      var t = filter
      switch(type) {
        case 'search':
          t.set_data('what', t.els['what'].val())

          break
        case 'region':
          t.set_data('where', t.els['where'].val())

          break
        case 'age':
          t.set_data('age', value)

          break
        case 'favorite':
          t.set_data('favorite', (value === true ? true : undefined))

          break
        // case 'services':
        //   t.set_data('services', (value.length > 0 ? value : undefined))

        //   break
        case 'map':
          var mp = pollution.elements['places_map']
          t.map_switch(value)
          break
      }

      // console.log('data to process', t.data)
      var url = window.location.pathname + '?' + (jQuery.param(t.data)) + (t.map.length ? '&' + jQuery.param({map: t.map}) : '') + window.location.hash
      window.history.pushState({ }, null, url)

      // if search text was submitted, reload the results data from ajax query
      // else, just render the results that will filter the data
      if (type === 'search'){
        t.process_send()
      }else if(type !== 'map') {
        t.render_results()
      }
    },
    process_send: function () {
      var t = filter

      pollution.components.loader.start()
      t.els['results'].html('')
      // t.render_count(0)

      $.ajax({
        dataType: "json",
        url: location.pathname,
        data: t.data,
        cache: false,
        success: function(json) {
          t.results = json.results
          t.process_callback('success')
        },
        error: function() {
          t.results = []
          t.process_callback('error')
        }
      });
    },
    process_callback: function (type) {
      var t = filter
      if(type === 'success') {

        // console.log( "success", data )
        // place_cards_builder(data.result)
        t.render_results()
      }
      else {
        t.render_results()
        // console.log( "fail message" )
      }
    },
    // private
    bind: function () {
      var t = filter

      var search_keydown = function (event) {
        var code = event.keyCode || event.which
        if(code === 13) {
          t.process('search')
        }
      }
      if($('.en2ka').length) {
        var en2kaFlag = true
        $('.en2ka-switcher').click(function () {
          en2kaFlag = this.innerText === 'EN'
          this.innerText = en2kaFlag ? 'KA' : 'EN'
        })

        t.els['what'].keypress(function(event){
          if (event.altKey || event.ctrlKey || event.metaKey) return;
          if(en2kaFlag && event.charCode) {
            insertText(this, en2ka(String.fromCharCode(event.keyCode || event.which)))
            event.preventDefault()
          }
        })
      }


      function en2ka(str) {
         var index, symbols = "abgdevzTiklmnopJrstufqRySCcZwWxjh"

         return str.split('').map(function(m) {
           index = symbols.indexOf(m)
           return index >= 0 ? String.fromCharCode(index + 4304) : m
         }).join('')
       }

       function insertText(input, text) {
         if (input == undefined) { return; }
         var scrollPos = input.scrollTop;
         var pos = 0;
         var browser = ((input.selectionStart || input.selectionStart == "0") ?
           "ff" : (document.selection ? "ie" : false ) );
         if (browser == "ie") {
           input.focus();
           var range = document.selection.createRange();
           range.moveStart ("character", -input.value.length);
           pos = range.text.length;
         }
         else if (browser == "ff") { pos = input.selectionStart };

         var front = (input.value).substring(0, pos);
         var back = (input.value).substring(pos, input.value.length);
         input.value = front+text+back;
         pos = pos + text.length;
         if (browser == "ie") {
           input.focus();
           var range = document.selection.createRange();
           range.moveStart ("character", -input.value.length);
           range.moveStart ("character", pos);
           range.moveEnd ("character", 0);
           range.select();
         }
         else if (browser == "ff") {
           input.selectionStart = pos;
           input.selectionEnd = pos;
           input.focus();
         }
         input.scrollTop = scrollPos;
       }

      t.els['what'].keydown(search_keydown)
      // t.els['where'].keydown(search_keydown)

       $('#region_filter').select2({
        width: '100%',
        allowClear: true
      })
        .on('change', function (evt) {
          t.process('region')
          t.map_highlight_region()
        })

      t.els['search'].click(function () {
        t.process('search')
      })

      pollution.components.age.bind(t.els['age'], function(v) {
        t.process('age', v)
      })

      pollution.components.favoritor.bind(t.els['favorite'], function(v) {
        t.process('favorite', v)
      })

      // pollution.components.services.bind(t.els['services'], function(v) {
      //   t.process('services', v)
      // })
      t.els['map'].change(function () {
        t.process('map', $(this).is(":checked"))
      })
      pollution.elements['places_map'].on('moveend', function () { t.map_move_end() })

      // when click on service show details if necessary
      $('.services > ul > li').on('click', '> a > span.name', function(evt){
        t.show_details($(evt.target).closest('li'))
      })
      $('.services ul.sub-services > li.sub-service ').on('click', '> span.name', function(evt){
        t.show_details($(evt.target).closest('li'))
      })

      // when click on results service header, show service list
      $('.results-container').on('click', '.results-service-name', function(evt){
        t.hide_details()
      })
    },
    set_data: function (key, value) {
      var t = filter
      if(typeof value !== 'undefined' && value !== null && !Number.isNaN(value) && value !== '') {
        t.data[key] = value
      }
      else if(t.data.hasOwnProperty(key)) {
        delete t.data[key]
      }
    },
    // render_result: function (data) {
    //   var t = filter
    //   var result = data.result

    //   t.render_count(data.result_count)

    //   if(data.length === 0) {
    //     t.els['results'].html('<div class="not-found">' + gon.labels.not_found + '</div>')
    //     return
    //   }

    //   var places = []
    //   gon.regions.forEach(function (region) {

    //     if(typeof result[region[0]] !== 'undefined') {
    //       var n = result[region[0]].length
    //       t.els['results'].append('<div class="region collapsed" data-id="' + region[0] + '"><div class="region-name">' +
    //           region[1] + '<span class="caret"></span><span class="region-count">' +
    //           n + '&nbsp;' + gon.labels[n > 1 ? 'results' : 'result'] +
    //           '</span></div></div>')
    //         .appendTo()

    //       result[region[0]].forEach(function (place) {
    //         place.region_id = region[0]
    //         places.push(place)
    //         t.els['results'].append(pollution.components.place_card.builder(place, region[0])) // + (d.length === 2 ? d[1].html : ''))// '<div class="row">' ++ '</div>'
    //       })
    //     }
    //   })

    //   pollution.components.map.render_markers('places_map', places)
    //   if(t.first) {
    //     t.first = false
    //     t.map_switch(true)
    //   } else if (t.dynamic_map) {
    //     t.map_move_end()
    //   }
    // },
    filter_results: function () {
      var t = filter
      var filtered_results = []

      if (t.results.length > 0){
        var where = t.els['where'].val()
        var age = pollution.components.age.get(t.els['age'])
        var favorite = pollution.components.favoritor.get(t.els['favorite']) === true ? true : undefined

        if (where === '' && age === undefined && favorite === undefined ){
          // no filter, show load all data
          filtered_results = t.results
        }else{
          t.results.forEach(function (place){
            var is_match = []
            if (where !== null && where !== ''){
              is_match.push(place.region_id !== null && where.includes(place.region_id.toString()))
            }
            if (age !== undefined){
              is_match.push((age === 'children' && place.for_children === true) || (age === 'adults' && place.for_adults === true))
            }
            if (favorite !== undefined){
              is_match.push(place.favorite === favorite)
            }

            // if is_match only has trues, then a match was found
            if (!is_match.includes(false)){
              filtered_results.push(place)
            }
          })
        }
      }

      return filtered_results
    },
    render_results: function () {
      var t = filter
      var $services = $('.services > ul > li')
      var place_count
      var place_ids = []
      var age_filter_value = pollution.components.age.get(t.els['age'])
      var filtered_results = t.filter_results()

      pollution.components.loader.start()

      // get the places for each sub-service
      $services.each(function (i, service){

        place_ids.length = 0

        // if service has subservices, process them
        // else just look for places assigned to the service
        var subservices = $(service).find('ul > li')
        if (subservices.length > 0){

          // go through each subservice
          $(subservices).each(function (j, subservice){
            place_ids = place_ids.concat(t.set_service_place_ids(subservice, filtered_results, age_filter_value))
          })

          // get unique place ids
          var uniq_place_ids = place_ids.filter(t.unique_array_values)

          // save the place ids
          $(service).attr('place-ids', uniq_place_ids)

          // show the number next to service name
          $(service).find('a .name .service-count').empty().text('(' + place_ids.length + ')')

        }else{
          // no subservices
          t.set_service_place_ids(service, filtered_results, age_filter_value)
        }
      })

      // if a li.service item has class of toggled,
      // then the service is currently open
      // so update the service details
      /// - this will also update the map markers
      if ($('.services li.service.toggled').length > 0){
        // if details is being show, reload it
        if ($('.results-service-name').attr('service-id') !== undefined && $(t.els['results']).html().length > 0){
          t.show_details($('.services li[data-id="' + $('.results-service-name').attr('service-id') + '"]'))
        }
      }else{
        // show the map markers
        t.show_map_markers(filtered_results)
      }

      pollution.components.loader.stop()

    },
    unique_array_values: function (value, index, self){
      return self.indexOf(value) === index
    },
    set_service_place_ids: function (service, filtered_results, age_filter_value) {
      var service_id = $(service).data('id')
      var place_ids = []
      place_ids.length = 0

      // only continue if the service is visible for the age filter
      if (age_filter_value === undefined || $(service).data(age_filter_value) === true){
        // reset the place ids
        $(service).attr('place-ids', null)

        // see if this service has any places
        filtered_results.forEach(function (place){
          if (place.service_ids && place.service_ids.includes(service_id)){
            place_ids.push(place.id)
          }
        })

        // save the place ids
        $(service).attr('place-ids', place_ids)
        // show the number next to service name
        $(service).find('.service-count').empty().text('(' + place_ids.length + ')')
      }
      // return the places
      return place_ids
    },
    show_map_markers: function(places){
      var t = filter

      // clear existing markers
      if(pollution.elements.hasOwnProperty('places_map_marker_group')) {
        pollution.elements['places_map_marker_group'].clearLayers()
      }

      pollution.components.map.render_markers('places_map', places)
      if(t.first) {
        t.first = false
        t.map_switch(true)
      } else if (t.dynamic_map) {
        t.map_move_end()
      }
    },
    hide_details: function () {
      var t = filter
      var $service = $('.services > ul > li.toggled')

      // if the main service has sub-services,
      // update the map to show all of the places in the service
      // else, there are no sub-services so close the service item and show all places on the map

      if ($service.find('ul > li').length === 0){
        // no sub-services

        // - close the service
        $service.find('> a').trigger('click')

        // - show all places on map
        t.show_map_markers(t.filter_results())

      }else{
        // show sub-services on map

        // get the service places
        var places = t.get_service_places($service)

        // show the map markers
        t.show_map_markers(places)
      }

      // hide the result details and show the services
      $('.services > .results-container').removeClass('slide-in')
      $('.services > ul').removeClass('slide-out')

      // remove all existing results
      $(t.els['results']).empty()
    },
    show_details: function (service_element) {
      // if the service is visible and does not have a nested list, show the details
      // - is visible if the li has .service with toggled class or has sub-service class
      // - this will be true if a main service has no subservice or for a subservice
      var t = filter
      var $service = $(service_element)

      if ($service.find('ul > li').length === 0 && (
          $service.hasClass('sub-service') ||
          ($service.hasClass('service') && $service.hasClass('toggled'))
        )){

        // slide the services out and the results in
        $('.services > ul').addClass('slide-out')
        $('.services > .results-container').addClass('slide-in')

        // add the header info
        var $results_service = $('.results-service-name')

        // - service id
        $results_service.attr('service-id', $service.data('id'))
        // - service icon
        $results_service.find('i').removeClass().addClass($service.closest('.service').find('a i').get(0).classList[0])
        // - service name
        $results_service.find('.name').empty().html($service.find('.name').html())

        // remove all existing results
        $(t.els['results']).empty()

        // get the service places
        var places = t.get_service_places($service)

        // show each place listed in the service li tag
        if (places.length === 0){
          // no results
          t.els['results'].html('<div class="not-found">' + gon.labels.not_found + '</div>')
        }else{
          places.forEach(function (place){
            t.els['results'].append(pollution.components.place_card.builder(place, $service.data('id')))
          })
        }

        // show the map markers
        t.show_map_markers(places)

      }else if($service.find('ul > li').length > 0 &&
                $service.hasClass('service') &&
                $service.hasClass('toggled')){
        // if this is a service with sub-services,
        // update the map to show all places in this service

        // get the service places
        var places = t.get_service_places($service)

        // show the map markers
        t.show_map_markers(places)
      }else{
        // slide the services in and the results out
        t.hide_details()
      }
    },
    get_service_places: function (service){
      var t = filter

      var place_ids = $(service).attr('place-ids').split(',')
      var places = []

      if ($(service).attr('place-ids') !== '' && place_ids.length > 0){

        // go through the results and find these places
        t.results.forEach(function (place){
          if (place_ids.includes(place.id.toString())){
            places.push(place)
          }
        })
      }

      return places
    },
    // render_count: function (n) {
    //   var t = filter
    //   t.els['count'].html(n + '&nbsp;<span>' + gon.labels[n > 1 ? 'results' : 'result'] + '</span>')
    // },
    map_move_end: function () {
      var t = filter
      if(!t.dynamic_map) { return }
      var mp = pollution.elements['places_map']
      var $result_container = t.els['results'].parent()

      $result_container.addClass('loader')

      var bounds = mp.getBounds()
      var tmp = [bounds._northEast.lat, bounds._northEast.lng, bounds._southWest.lat, bounds._southWest.lng]
      t.map = tmp
      var url = window.location.pathname + '?' + (jQuery.param(t.data) + (tmp.length ? '&' + jQuery.param({map: tmp}) : ''))
      // console.log(url)
      window.history.pushState({ }, null, url)

      pollution.elements['places_map_marker_group'].eachLayer(function (layer) {
        t.els['results'].find('.place-card[data-place-id="' + layer.options._place_id + '"]').toggleClass('hidden', !bounds.contains(layer.getLatLng()))
      });
      // t.render_count(t.els['results'].find('.place-card:not(.hidden)').length)
      setTimeout(function() { $result_container.removeClass('loader') }, 200)
    },
    map_switch: function (value) {
      var t = filter
      if(value === true) {
        t.dynamic_map = true
        var $result_container = t.els['results'].parent()

        $result_container.addClass('loader')
        t.els['results'].addClass('plain')
        t.els['results'].find('.region').addClass('collapsed')

        t.map_move_end()
        $result_container.removeClass('loader')
      }
      else {
        t.dynamic_map = false
        t.map = []
        t.els['results'].removeClass('plain')
        t.els['results'].find('.place-card').addClass('hidden')
        // t.render_count(t.els['results'].find('.place-card').length)
      }
    },
    map_highlight_region: function (fly) {
      if(typeof fly === 'undefined') { fly = true }
      var t = filter
      var region_ids = t.els['where'].val()
      var fly_coordinates = [42.224, 43.401]
      var zoomTo = 7
      if(region_ids !== null)  {
        if(region_ids.length === 1) {
          var r = gon.regions.filter(function(f) { return f[0] === +region_ids[0] })[0]
          fly_coordinates = [r[2], r[3]]
          zoomTo = 9
        } else {
          fly = false
        }
      }
      pollution.components.map.set_view('places_map', fly_coordinates, zoomTo, fly)
    }
  }
  pollution.components.filter = filter
}())
