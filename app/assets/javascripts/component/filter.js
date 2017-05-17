/* global $ */

(function() {
  var filter = {
    el: undefined,
    names: ['what', 'where', 'services', 'rate', 'favorite', 'map'],
    data: {},
    els: {},
    init: function () {
      var t = filter
      t.el = $('#filter')

      t.names.forEach(function(name) {
        t.els[name] = t.el.find('[data-filter="' + name + '"]')
      })
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


      t.set_data('map', undefined)

      console.log('data to process_all', t.data)
    },
    process: function (type, value) {
      var t = filter

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
      }
      console.log('data to process', t.data)
      var url = window.location.pathname + '?' + jQuery.param(t.data)
      window.history.pushState({ }, null, url);
      t.process_send()
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
        t.process_callback('success', json)
      }).fail(function() {
        t.process_callback('error', json)
      })
    },
    process_callback: function (type, data) {
      var t = filter
      if(type === 'success') {

        console.log( "success", data )
        t.render_result(data.result)
      }
      else {
        console.log( "fail" )
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

      var groups = data.map( function(e,i) { return i%2===0 ? data.slice(i,i+2) : null; })
                    .filter(function(e){ return e; })

      groups.forEach(function (d) {
        t.els['result'].append('<div class="row">' + d[0].html + (d.length === 2 ? d[1].html : '') + '</div>')
        // <div class="place-card"><div class="card-border"><div class="card"></div></div></div>
        var locations = [d[0].location]
        if(d.length === 2) { locations.push(d[1].location) }
        pollution.components.map.render_markers('places_map', locations)
      })
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
