/* global $ */
/* eslint callback-return: 0 */

(function() {
  var place_card = {
    bind: function () {// element should be .rator
      $(document).on('click mouseenter', '.place-card .ellipsis', function () {
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
        '<div class="place-card hidden" data-place-id="%id" data-region-id="%regiond_id">' +
          '<div class="card-border">' +
            '<div class="card">' +
              '<div class="front">' +
                '<div class="poster">' +
                  '<a href="%path"><img alt="%alt" title="%alt" class="image" src="%image"></a>' +
                  '%favorite' +
                  '<div class="rating">' +
                    '<div class="value" title="%overall_rating %rating/5">' +
                      '%rating' +
                      '<span>/5</span>' +
                    '</div>' +
                  '</div>' +
                '</div>' +
                '<div class="place-info">' +
                  '<a class="name" href="%path">%name</a>' +
                  '<div class="provider">' +
                    '<span>%by&nbsp;</span>' +
                    '<a href="/en?what=%provider_url">%provider</a>' +
                  '</div>' +
                  '<div class="first-service service">' +
                    '<i class="%service_icon"></i>' +
                    '<span>%service_name</span>' +
                    '%ellipsis' +
                  '</div>' +
                  '<ul class="contact">' +
                    '<li>' +
                      '<span class="icon address"></span>' +
                      '%address' +
                    '</li>' +
                    '<li>' +
                      '<span class="icon phone"></span>' +
                      '%phone' +
                    '</li>' +
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

      var service_first = gon.labels.services.filter(function(f) { return f[0] === place.services[0] })[0]

      var back_template = ''
      var back_ellipsis_template = ''

      if(place.services.length > 1) {
        var other_services = place.services.slice()
        other_services.splice(0,1)
        back_template = '<div class="back hidden"><div class="close"></div><ul class="services">' +
            other_services.map(function(m) {
              var s = gon.labels.services.filter(function(f) { return f[0] === m })[0]
              return '<li class="service"><i class="' + s[2] + '"></i><span>' + s[1] + '</span></li>'
             }).join("")
        + '</ul></div>'
        back_ellipsis_template = '<div class="ellipsis"></div>'
      }
      console.log(place.rating)
      var html = template
        .replace(/%id/g, place.id)
        .replace(/%name/g, place.name)
        .replace(/%phone/g, place.phone)
        .replace(/%address/g, place.address)
        .replace(/%path/g, place.path)
        .replace(/%by/g, gon.labels.by)
        .replace(/%provider/g, place.provider.name)
        .replace(/%image/g, place.image)
        .replace(/%alt/g, gon.labels.alt.replace('%alt', place.name))
        .replace(/%rating/g, place.rating)
        .replace(/%regiond_id/g, region_id)
        .replace(/%overall_rating/g, gon.labels.overall_rating)
        .replace(/%favorite/g , favorite_template)
        .replace(/%service_icon/g, service_first[2])
        .replace(/%service_name/g, service_first[1])
        .replace(/%back/g, back_template)
        .replace(/%ellipsis/g, back_ellipsis_template)

      return html
    }
  }
  place_card.bind()
  pollution.components.place_card = place_card
}())
