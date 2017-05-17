/* global $ */

(function() {
  var filter = {
    el: undefined,
    names: ['what', 'where', 'services', 'rate', 'favorite'], // plus map
    data: {},
    els: {},
    result: [],
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

      t.prepaire_data()
      t.process_send()
      return t
    },
    prepaire_data: function () {
      var t = filter
      var value

      // search
      t.set_data('what', t.els['what'].val())
      t.set_data('where', t.els['where'].val())

      // services
      value = pollution.components.services.get(t.els['services'])
      t.set_data('services', (value.length > 0 ? value : undefined))

      // rate
      value = pollution.components.rator.get(t.els['rate'])
      if(value < 1 || value > 4) {
        value = undefined
      }
      t.set_data('rate', value)

      // favorite
      value = pollution.components.favoritor.get(t.els['favorite'])
      t.set_data('favorite', (value === 'true' ? true : undefined))


      var mp = pollution.elements['places_map']
      var map = JSON.parse(t.els['map'].attr('data-m'))

      if(map.length === 4) {
        mp.on('moveend', function () {
          var bounds = mp.getBounds()
          var tmp = [bounds._northEast.lat, bounds._northEast.lng, bounds._southWest.lat, bounds._southWest.lng, mp.getZoom()]
          var url = window.location.pathname + '?' + (jQuery.param(t.data) + (tmp.length ? '&' + jQuery.param({map: tmp}) : ''))
          window.history.pushState({ }, null, url)

          pollution.elements['places_map_marker_group'].eachLayer(function (layer) {
            t.els['result'].find('.place-card[data-place-id="' + layer.options._place_id + '"]').toggleClass('hidden', !bounds.contains(layer.getLatLng()))
          });
        })
        // mp.setZoom(zoom)
        mp.fitBounds([[map[0], map[1]],[map[2],map[3]]])
        // var bounds = mp.getBounds()
        // var tmp = [bounds._northEast.lat, bounds._northEast.lng, bounds._southWest.lat, bounds._southWest.lng, mp.getZoom()]
        // pollution.elements['places_map_marker_group'].eachLayer(function (layer) {
        //   t.els['result'].find('.place-card[data-place-id="' + layer.options._place_id + '"]').toggleClass('hidden', !bounds.contains(layer.getLatLng()))
        // });
      }

      console.log('data to process_all', t.data)
    },
    process: function (type, value) {
      var t = filter
      var map = []
      switch(type) {
        case 'search':
          t.set_data('what', t.els['what'].val())
          t.set_data('where', t.els['where'].val())

          break
        case 'rate':
          if(value < 1 || value > 4) {
            value = undefined
          }
          t.set_data('rate', value)

          break
        case 'favorite':
          t.set_data('favorite', (value === true ? true : undefined))

          break
        case 'services':
          t.set_data('services', (value.length > 0 ? value : undefined))

          break
        case 'map':
          var mp = pollution.elements['places_map']
          if(value === true) {
            mp.on('moveend', function () {
              var bounds = mp.getBounds()
              var tmp = [bounds._northEast.lat, bounds._northEast.lng, bounds._southWest.lat, bounds._southWest.lng]
              var url = window.location.pathname + '?' + (jQuery.param(t.data) + (tmp.length ? '&' + jQuery.param({map: tmp}) : ''))
              window.history.pushState({ }, null, url)

              pollution.elements['places_map_marker_group'].eachLayer(function (layer) {
                t.els['result'].find('.place-card[data-place-id="' + layer.options._place_id + '"]').toggleClass('hidden', !bounds.contains(layer.getLatLng()))
              });
              t.render_count(t.els['result'].find('.place-card:not(.hidden)').length)
            })
            var bounds = mp.getBounds()
            map = [bounds._northEast.lat, bounds._northEast.lng, bounds._southWest.lat, bounds._southWest.lng]
            pollution.elements['places_map_marker_group'].eachLayer(function (layer) {
              t.els['result'].find('.place-card[data-place-id="' + layer.options._place_id + '"]').toggleClass('hidden', !bounds.contains(layer.getLatLng()))
            });
            t.render_count(t.els['result'].find('.place-card:not(.hidden)').length)
          }
          else {
            map = []
            t.els['result'].find('.place-card.hidden').removeClass('hidden')
            mp.off('moveend')
            t.render_count(t.els['result'].find('.place-card:not(.hidden)').length)

          }

          // t.set_data('map', value)
          break
      }
      console.log('data to process', t.data)
      var url = window.location.pathname + '?' + (jQuery.param(t.data) + (map.length ? '&' + jQuery.param({map: map}) : ''))
      window.history.pushState({ }, null, url)
      if(type !== 'map') {
        t.process_send()
      }
    },
    process_send: function () {
      var t = filter

      pollution.components.loader.start()
      t.els['result'].html('')
      t.render_count(0)
      console.log(pollution.elements)
      if(pollution.elements.hasOwnProperty('places_map_marker_group')) {
        pollution.elements['places_map_marker_group'].clearLayers()
      }

      $.getJSON(location.pathname, t.data, function(json) {
        t.result = json.result
        t.process_callback('success', json)
      }).fail(function() {
        t.process_callback('error', json)
      })
    },
    process_callback: function (type, data) {
      var t = filter
      if(type === 'success') {

        // console.log( "success", data )
        // place_cards_builder(data.result)
        t.render_result(data.result)
      }
      else {
        t.render_result([])
        // console.log( "fail message" )
      }
      pollution.components.loader.stop()
    },
    // private
    bind: function () {
      var t = filter

      t.els['search'].click(function () {
        t.process('search')
      })

      pollution.components.rator.bind(t.els['rate'], function(v) {
        t.process('rate', v)
      })

      pollution.components.favoritor.bind(t.els['favorite'], function(v) {
        t.process('favorite', v)
      })

      pollution.components.services.bind(t.els['services'], function(v) {
        t.process('services', v)
      })
      t.els['map'].change(function () {
        t.process('map', $(this).is(":checked"))
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
    render_result: function (data) {
      var t = filter

      t.render_count(data.length)

      if(data.length === 0) {
        t.els['result'].html('<span>' + gon.labels.not_found + '</span>')
        return
      }
      // var groups = data.map( function(e,i) { return i%2===0 ? data.slice(i,i+2) : null; })
      //               .filter(function(e){ return e; })

      data.forEach(function (d) {
        t.els['result'].append(place_card_builder(d)) // + (d.length === 2 ? d[1].html : ''))// '<div class="row">' ++ '</div>'
        // <div class="place-card"><div class="card-border"><div class="card"></div></div></div>
        // if(d.length === 2) { locations.push(d[1].location) }
      })
      pollution.components.map.render_markers('places_map', data)
    },
    render_count: function (n) {
      var t = filter
      t.els['count'].html(n + '&nbsp;<span>' + gon.labels[n > 1 ? 'results' : 'result'] + '</span>')
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
