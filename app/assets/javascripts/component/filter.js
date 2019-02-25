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
      t.els['result'] = t.el.find('.result')
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
      t.els['result'].html('')
      t.render_count(0)
      // console.log(pollution.elements)
      if(pollution.elements.hasOwnProperty('places_map_marker_group')) {
        pollution.elements['places_map_marker_group'].clearLayers()
      }

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
    //     t.els['result'].html('<div class="not-found">' + gon.labels.not_found + '</div>')
    //     return
    //   }

    //   var places = []
    //   gon.regions.forEach(function (region) {

    //     if(typeof result[region[0]] !== 'undefined') {
    //       var n = result[region[0]].length
    //       t.els['result'].append('<div class="region collapsed" data-id="' + region[0] + '"><div class="region-name">' +
    //           region[1] + '<span class="caret"></span><span class="region-count">' +
    //           n + '&nbsp;' + gon.labels[n > 1 ? 'results' : 'result'] +
    //           '</span></div></div>')
    //         .appendTo()

    //       result[region[0]].forEach(function (place) {
    //         place.region_id = region[0]
    //         places.push(place)
    //         t.els['result'].append(pollution.components.place_card.builder(place, region[0])) // + (d.length === 2 ? d[1].html : ''))// '<div class="row">' ++ '</div>'
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
      var service_count
      var place_ids = []
      var age_filter_value = pollution.components.age.get(t.els['age'])
      var filtered_results = t.filter_results()

      pollution.components.loader.start()

      // show the results
      if(filtered_results.length === 0) {
        t.els['result'].html('<div class="not-found">' + gon.labels.not_found + '</div>')
        return
      }

      // get the places for each sub-service
      $services.each(function (i, service){

        service_count = 0

        // go through each subservice
        $(service).find('ul > li').each(function (j, subservice){
          place_ids.length = 0

          // only continue if the subservice is visible for the age filter
          if (age_filter_value === undefined || $(subservice).data(age_filter_value) === true){
            // reset the place ids
            $(subservice).attr('place-ids', null)

            // see if this service has any places
            filtered_results.forEach(function (place){
              if (place.services && place.services.includes($(subservice).data('id'))){
                place_ids.push(place.id)
              }
            })

            // save the place ids
            $(subservice).attr('place-ids', place_ids)
            // show the number next to service name
            $(subservice).find('.service-count').empty().text('(' + place_ids.length + ')')

            // update the overall service count
            service_count += place_ids.length
          }
        })

        // show the number next to service name
        $(service).find('a .name .service-count').empty().text('(' + service_count + ')')

      })

      pollution.components.loader.stop()

      // var places = []
      // gon.regions.forEach(function (region) {

      //   if(typeof result[region[0]] !== 'undefined') {
      //     var n = result[region[0]].length
      //     t.els['result'].append('<div class="region collapsed" data-id="' + region[0] + '"><div class="region-name">' +
      //         region[1] + '<span class="caret"></span><span class="region-count">' +
      //         n + '&nbsp;' + gon.labels[n > 1 ? 'results' : 'result'] +
      //         '</span></div></div>')
      //       .appendTo()

      //     result[region[0]].forEach(function (place) {
      //       place.region_id = region[0]
      //       places.push(place)
      //       t.els['result'].append(pollution.components.place_card.builder(place, region[0])) // + (d.length === 2 ? d[1].html : ''))// '<div class="row">' ++ '</div>'
      //     })
      //   }
      // })

      // pollution.components.map.render_markers('places_map', places)
      // if(t.first) {
      //   t.first = false
      //   t.map_switch(true)
      // } else if (t.dynamic_map) {
      //   t.map_move_end()
      // }
    },
    render_count: function (n) {
      var t = filter
      t.els['count'].html(n + '&nbsp;<span>' + gon.labels[n > 1 ? 'results' : 'result'] + '</span>')
    },
    map_move_end: function () {
      var t = filter
      if(!t.dynamic_map) { return }
      var mp = pollution.elements['places_map']
      var $result_container = t.els['result'].parent()

      $result_container.addClass('loader')

      var bounds = mp.getBounds()
      var tmp = [bounds._northEast.lat, bounds._northEast.lng, bounds._southWest.lat, bounds._southWest.lng]
      t.map = tmp
      var url = window.location.pathname + '?' + (jQuery.param(t.data) + (tmp.length ? '&' + jQuery.param({map: tmp}) : ''))
      // console.log(url)
      window.history.pushState({ }, null, url)

      pollution.elements['places_map_marker_group'].eachLayer(function (layer) {
        t.els['result'].find('.place-card[data-place-id="' + layer.options._place_id + '"]').toggleClass('hidden', !bounds.contains(layer.getLatLng()))
      });
      t.render_count(t.els['result'].find('.place-card:not(.hidden)').length)
      setTimeout(function() { $result_container.removeClass('loader') }, 200)
    },
    map_switch: function (value) {
      var t = filter
      if(value === true) {
        t.dynamic_map = true
        var $result_container = t.els['result'].parent()

        $result_container.addClass('loader')
        t.els['result'].addClass('plain')
        t.els['result'].find('.region').addClass('collapsed')

        t.map_move_end()
        $result_container.removeClass('loader')
      }
      else {
        t.dynamic_map = false
        t.map = []
        t.els['result'].removeClass('plain')
        t.els['result'].find('.place-card').addClass('hidden')
        t.render_count(t.els['result'].find('.place-card').length)
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






// # .records
// #       - ln = results.length #recods.length
// #       = ln
// #       %span= t('.result', count: ln)
// #   .place-cards
// #     - results.in_groups_of(2).each do |place_group|
// #       .row
// #         - if place_group[0].present?
// #           =
// #           - if place_group[1].present?
// #             = render partial: 'shared/place', locals: { place: place_group[1] }
