(function() {
  var map = {
    default_options: {
      zoom: 16,
      coordinates: [41.74288345375358, 44.74130630493165],
      type: 'coordinate' // locator uses inputs, data uses data attributes,
      // coordinate uses options coordinates, coordinates - multiple markers from gon.coordinates

    },
    maps: [],
    init: function(id, options) { // id without #
      var t = map
      var $mp = $('#' + id)
      var lat
      var lon
      var opts = {}
      options = $.extend({}, t.default_options, options)
      var type = options.type
      var coordinates = options.coordinates
      if($mp.length) {

        if(type === 'locator') {
          lat = +$("input[name$='[latitude]'").val()
          lon = +$("input[name$='[longitude]'").val()
        }
        else if(type === 'data') {
          lat = +$mp.attr("data-latitude")
          lon = +$mp.attr("data-longitude")
        }
        else if(type === 'coordinate') {
          // already merged
        }

        if(lat > 0) { coordinates[0] = lat }
        if(lon > 0) { coordinates[1] = lon }

        var mp = L.map(id, {zoomControl: false, maxBounds: [ // only georgia can be selected
          [43.784728, 39.891357],
          [40.919480, 46.845703]
        ]}).setView(coordinates, options.zoom);

        // mp.fitBounds();


        pollution.elements[id] = mp

        L.tileLayer(gon.osm, { attribution: gon.osm_attribution })
          .addTo(mp)

        var markerGroup = L.layerGroup().addTo(mp)
        pollution.elements[id + '_marker_group'] = markerGroup

        if(type !== 'coordinates') {
          var marker = L.marker(coordinates, {icon: pollution.elements.pin })
            .addTo(markerGroup)
        }

        var map_container = $mp.parent()

        map_container.find('.map-zoomer .in').click(function(){
          mp.setZoom(mp.getZoom() + 1)
        });

        map_container.find('.map-zoomer .out').click(function(){
          mp.setZoom(mp.getZoom() - 1)
        });
      }

      if(options.locate) {
        mp.locate({setView: true, maxZoom: 12});
      }
      if(type === 'locator') {
        mp.on('click', function(e) {
          locate(e.latlng)
        });
        $('.map-locator').click(function () {
          mp.locate({setView: true, maxZoom: 16});
        })
        mp.on('locationfound', function(e) {
          locate(e.latlng)
        });
        mp.on('locationerror', function(e) {
          $('.map-locator').addClass('disabled')
        });

        function locate(latlng) {
          $("input[name$='[latitude]'").val(latlng.lat)
          $("input[name$='[longitude]'").val(latlng.lng)
          marker.setLatLng(L.latLng(latlng.lat, latlng.lng));
        }
      }
    },
    render_markers: function (id, locations) {
      if(pollution.elements.hasOwnProperty(id)) {
        var markerGroup = pollution.elements[id + '_marker_group']
        // console.log("-----------------------------",locations)
        locations.forEach(function(location) {
          // console.log(location.coordinates)
          var mrk = L.marker(location.coordinates.map(function(m) { return +m }), {icon: pollution.elements.pin, _place_id: location.id }).addTo(markerGroup)

          if(!device.desktop()) {
            mrk.bindPopup("<div class='header'>" + location.name + "</div>");
          }
          else {
            mrk.on('click', function() {
              var place_cards = $('.result').get(0)
              var place_card = $(place_cards).find('.place-card[data-place-id="' + location.id + '"]').get(0)

              if(typeof place_card.scrollIntoView === 'function') {
                place_card.scrollIntoView({block: "end", behavior: "smooth"});
              }
              else {
                place_cards.scrollTop = place_card.offsetTop - place_cards.offsetTop
              }
            })
          }
        })
      }
    }
  }


  // map.init('contact_map', { zoom: 17, coordinates: [41.70978, 44.76133], type: 'coordinate' })
  // map.init('locator_map', { zoom: 13, type: 'locator' })
  pollution.components.map = map
}())
