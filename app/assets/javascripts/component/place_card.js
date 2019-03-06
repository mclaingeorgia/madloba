/* global $ */
/* eslint callback-return: 0 */

(function() {
  var place_card = {
    bind: function () {// element should be .rator
      $(document).on('click', '.place-card .ellipsis', function () {
        var t = $(this).closest('.card-border')
        t.find('.front').addClass('invisible')
        t.find('.back').removeClass('hidden')
      })

      $(document).on('mouseenter', '.place-card .card-border', function () {
        // update map marker
        var t = $(this)
        var place_id = t.closest('.place-card').data('place-id')
        $.each(pollution.elements.places_map_marker_group._layers, function (key, marker){
          if (marker.place_id === place_id){
            marker.setIcon(pollution.elements.pin_highlight)
          }
        })
      })

      $(document).on('mouseleave', '.card-border', function () {
        var t = $(this)
        t.find('.front').removeClass('invisible')
        t.find('.back').addClass('hidden')

        // reset map marker
        var place_id = t.closest('.place-card').data('place-id')
        $.each(pollution.elements.places_map_marker_group._layers, function (key, marker){
          if (marker.place_id === place_id){
            marker.setIcon(pollution.elements.pin)
          }
        })
      })

      $(document).on('click', '.card-border .close', function () {
        var t = $(this).closest('.card-border')
        t.find('.front').removeClass('invisible')
        t.find('.back').addClass('hidden')
      })
    },
    builder: function (place, service_id) {
      // console.log(place)
      var template =
        '<div class="place-card" data-place-id="%id" data-service-id="%service_id">' +
          '<div class="card-border">' +
            '<div class="card">' +
              '<div class="front">' +
                '<div class="poster">' +
                  '<a href="%path" title="%title"><img alt="%alt" class="image" src="%image"></a>' +
                  '%favorite' +
                  '%ratings' +
                '</div>' +
                '<div class="place-info">' +
                  '<a class="name" href="%path"  title="%title">%name</a>' +
                  // '%provider_template' +
                  '<div class="services">' +
                    '%age' +
                    // '%ellipsis' +
                  '</div>' +
                  '<ul class="contact">' +
                    '%phone_template' +
                    '%address_template' +
                    '<li class="map-toggle">' +
                      '<a class="hide-map mobile-hidden" href="javascript:void(0);" toggle-place-map="hide">' +
                        '<i></i>' +
                        gon.labels.hide_map +
                      '</a>' +
                      '<a class="show-map" href="javascript:void(0);" toggle-place-map="show">' +
                        '<i></i>' +
                        gon.labels.show_map +
                      '</a>' +
                    '</li>' +
                  '</ul>' +
                '</div>' +
                '<div class="map-view mobile-hidden" %map_coordinates>' +
                '</div>' +
              '</div>' +
              // '%back' +
            '</div>' +
          '</div>' +
        '</div>'



      var favorite_template = ''
      if(place.favorite) {
        favorite_template = '<div class="favorite" title="' + gon.labels.picked_as_favorite + '"></div>'
      }

      var rating_template = ''
      if(place.rating && place.rating > 0){
        rating_template += '<div class="rating5-container active" title="' + gon.labels.overall_rating + ': ' + place.rating + '">'
        for(var i=1; i<6; i++){
          rating_template += '<div class="rating5">'
          rating_template += '<i class="heart-dummy"></i>'

          cls = ''
          width = 0
          if (i > place.rating && i-place.rating >=1){
            // do nothing
          }else if (i > place.rating && i - place.rating < 1){
            cls = 'active'
            width = (place.rating - Math.floor(place.rating)).toFixed(2)*100
          }else{
            cls = 'active'
            width = 100
          }

          rating_template += '<i class="heart ' + cls + '" style="width: ' + width + '%"></i>'

          rating_template += '</div>'
        }


        rating_template += '</div>'
      }

      // var provider_template = ''
      // if(place.name !== place.provider.name) {
      //   provider_template = '<div class="provider">' +
      //                         '<span>%by&nbsp;</span>' +
      //                         '<a href="?what=%provider" title="%provider_title">%provider</a>' +
      //                       '</div>'
      //   provider_template = provider_template
      //     .replace(/%by/g, gon.labels.by)
      //     .replace(/%provider_title/g, gon.labels.view_all_provider_places)
      //     .replace(/%provider/g, place.provider.name)
      // }

      // var services_list = gon.labels.services
      //   .filter(function(service) {
      //     return place.service_ids.indexOf(service[0]) !== -1
      //   })
      // // console.log(services_list)
      // var front_template = services_list.slice(0,6).map(function(m) { return '<div class="service"><a href="?services[]=' + m[0] + '" title="' + m[1] + ' - ' + gon.labels.view_all_service_places + '"><i class="' + m[2] + '"></i></a></div>' }).join("")
      // // console.log(front_template)
      // var back_template = ''
      // var back_ellipsis_template = ''
      // if(services_list.length > 6) {
      //   back_template = '<div class="back hidden"><div class="close"></div><ul class="services">' +
      //     services_list.map(function(m) {
      //       return '<li class="service"><a href="?services[]=' + m[0] + '" title="' + m[1] + ' - ' + gon.labels.view_all_service_places + '"><i class="' + m[2] + '"></i><span>' + m[1] + '</span></a></li>'
      //     }).join("") +
      //     '</ul></div>'
      //   back_ellipsis_template = '<div class="ellipsis" title="' + gon.labels.view_all_services + '"></div>'
      // }

      var age_template = ''
      if (place.for_children){
        age_template += '<div class="service"><i class="children" title="' + gon.labels.children + '"></i></div>'
      }
      if (place.for_adults){
        age_template += '<div class="service"><i class="adults" title="' + gon.labels.adults + '"></i></div>'
      }

      var address_template = ''
      if(place.address !== '') {
        address_template = ('<li title="%address">' +
                            '<i class="address"></i>' +
                            '<span>%address</span>' +
                          '</li>').replace(/%address/g, place.address)
      }

      var phone_template = ''
      if(place.phone !== '') {
        phone_template = ('<li title="%phone">' +
                            '<i class="phone"></i>' +
                            '<span>%phone</span>' +
                          '</li>').replace(/%phone/g, place.phone)
      }

      var map_coordinates_tempalte = ''
      if (place.coordinates && place.coordinates.length === 2){
        map_coordinates_tempalte = ('id="place_map_' +
                                  place.id +
                                  '" data-latitude="' +
                                  place.coordinates[0] +
                                  '" data-longitude="' +
                                  place.coordinates[1] + '"')
      }


      var html = template
        .replace(/%id/g, place.id)
        .replace(/%name/g, place.name)
        .replace(/%title/g, gon.labels.view_place_details)
        .replace(/%address_template/g, address_template)
        .replace(/%phone_template/g, phone_template)
        .replace(/%path/g, place.path)
        // .replace(/%provider_template/g, provider_template)
        .replace(/%image/g, place.image)
        .replace(/%alt/g, gon.labels.alt.replace('%alt', place.name))
        .replace(/%ratings/g, rating_template)
        .replace(/%service_id/g, service_id)
        .replace(/%overall_rating/g, gon.labels.overall_rating)
        .replace(/%favorite/g , favorite_template)
        // .replace(/%services/g, front_template)
        // .replace(/%back/g, back_template)
        // .replace(/%ellipsis/g, back_ellipsis_template)
        .replace(/%age/g, age_template)
        .replace(/%map_coordinates/g, map_coordinates_tempalte)

      return html
    }
  }
  place_card.bind()
  pollution.components.place_card = place_card
}())
