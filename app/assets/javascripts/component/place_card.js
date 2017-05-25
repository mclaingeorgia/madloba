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

      $(document).on('mouseleave', '.card-border', function () {
        var t = $(this)
        t.find('.front').removeClass('invisible')
        t.find('.back').addClass('hidden')
      })

      $(document).on('click', '.card-border .close', function () {
        var t = $(this).closest('.card-border')
        t.find('.front').removeClass('invisible')
        t.find('.back').addClass('hidden')
      })
    },
    builder: function (place, region_id) {
      // console.log(place)
      var template =
        '<div class="place-card hidden" data-place-id="%id" data-region-id="%region_id">' +
          '<div class="card-border">' +
            '<div class="card">' +
              '<div class="front">' +
                '<div class="poster">' +
                  '<a href="%path" title="%title"><img alt="%alt" class="image" src="%image"></a>' +
                  '%favorite' +
                  '<div class="rating">' +
                    '<div class="value" title="%overall_rating %rating/5">' +
                      '<span>%rating</span>' +
                      '/5' +
                    '</div>' +
                  '</div>' +
                '</div>' +
                '<div class="place-info">' +
                  '<a class="name" href="%path"  title="%title">%name</a>' +
                  '%provider_template' +
                  '<div class="services">' +
                    '%services' +
                    '%ellipsis' +
                  '</div>' +
                  '<ul class="contact">' +
                    '%address_template' +
                    '%phone_template' +
                  '</ul>' +
                '</div>' +
              '</div>' +
              '%back' +
            '</div>' +
          '</div>' +
        '</div>'



      var favorite_template = ''
      if(place.favorite) {
        favorite_template = '<div class="favorite" title="' + gon.labels.picked_as_favorite + '"></div>'
      }

      var provider_template = ''
      if(place.name !== place.provider.name) {
        provider_template = '<div class="provider">' +
                              '<span>%by&nbsp;</span>' +
                              '<a href="?what=%provider" title="%provider_title">%provider</a>' +
                            '</div>'
        provider_template = provider_template
          .replace(/%by/g, gon.labels.by)
          .replace(/%provider_title/g, gon.labels.view_all_provider_places)
          .replace(/%provider/g, place.provider.name)
      }

      var services_list = gon.labels.services
        .filter(function(f) {
          return place.services.indexOf(f[0]) !== -1
        })
      // console.log(services_list)
      var front_template = services_list.slice(0,6).map(function(m) { return '<div class="service"><a href="?services[]=' + m[0] + '" title="' + m[1] + ' - ' + gon.labels.view_all_service_places + '"><i class="' + m[2] + '"></i></a></div>' }).join("")
      // console.log(front_template)
      var back_template = ''
      var back_ellipsis_template = ''
      if(services_list.length > 6) {
        back_template = '<div class="back hidden"><div class="close"></div><ul class="services">' +
          services_list.map(function(m) {
            return '<li class="service"><a href="?services[]=' + m[0] + '" title="' + m[1] + ' - ' + gon.labels.view_all_service_places + '"><i class="' + m[2] + '"></i><span>' + m[1] + '</span></a></li>'
          }).join("") +
          '</ul></div>'
        back_ellipsis_template = '<div class="ellipsis" title="' + gon.labels.view_all_services + '"></div>'
      }


      var address_template = ''
      if(place.address !== '') {
        address_template = ('<li title="%address">' +
                            '<span class="icon address"></span>' +
                            '%address' +
                          '</li>').replace(/%address/g, place.address)
      }

      var phone_template = ''
      if(place.phone !== '') {
        phone_template = ('<li title="%phone">' +
                            '<span class="icon phone"></span>' +
                            '%phone' +
                          '</li>').replace(/%phone/g, place.phone)
      }


      var html = template
        .replace(/%id/g, place.id)
        .replace(/%name/g, place.name)
        .replace(/%title/g, gon.labels.view_place_details)
        .replace(/%address_template/g, address_template)
        .replace(/%phone_template/g, phone_template)
        .replace(/%path/g, place.path)
        .replace(/%provider_template/g, provider_template)
        .replace(/%image/g, place.image)
        .replace(/%alt/g, gon.labels.alt.replace('%alt', place.name))
        .replace(/%rating/g, place.rating)
        .replace(/%region_id/g, region_id)
        .replace(/%overall_rating/g, gon.labels.overall_rating)
        .replace(/%favorite/g , favorite_template)
        .replace(/%services/g, front_template)
        .replace(/%back/g, back_template)
        .replace(/%ellipsis/g, back_ellipsis_template)

      return html
    }
  }
  place_card.bind()
  pollution.components.place_card = place_card
}())
