  $('.place-card .ellipsis').on('click mouseenter', function () {
    var t = $(this).closest('.card-border')
    t.find('.front').addClass('invisible')
    t.find('.back').removeClass('hidden')
  })

  $('.card-border').on('mouseleave', function () {
    var t = $(this)
    t.find('.front').removeClass('invisible')
    t.find('.back').addClass('hidden')
  })

  $('.card-border .close').on('click', function () {
    var t = $(this).closest('.card-border')
    t.find('.front').removeClass('invisible')
    t.find('.back').addClass('hidden')
  })

function place_cards_builder(places) {
  var html = ''
  places.forEach(function(place) {
    html += place_card_builder(place)
  })
  return html
}

function place_card_builder(place) {
  // console.log(place)
  var template =
    '<div class="place-card" data-place-id="%id">' +
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
                '<strong>%service_name</strong>' +
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
  if(place.services.length > 1) {
    var other_services = place.services.slice().splice(place.services.length-1,1)
    back_template = '<div class="back hidden"><div class="close"></div><ul class="services">' +
        other_services.map(function(m) {
          var s = gon.labels.services.filter(function(f) { return f[0] === m })[0]
          return '<li class="service"><i class="' + s[2] + '"></i><span>' + s[1] + '</span></li>'
         }).join("")
    + '</ul></div>'
  }

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
    .replace(/%overall_rating/g, gon.labels.overall_rating)
    .replace(/%favorite/g , favorite_template)
    .replace(/%service_icon/g, service_first[2])
    .replace(/%service_name/g, service_first[1])
    .replace(/%back/g, back_template)

  // console.log(html)
  return html
  // - if place.services.length > 1

 // place: {
 //    id: place.id,
 //    name: place.name,
 //    image: missing_path,
 //    path: place_path(place.id),
 //    providers: {
 //      name: place.provider.name
 //      },
 //    address: place.address,
 //    phone: place.phone,
 //    coordinates: [place.latitude, place.longitude]
 //  },
  // .place-card{'data-place-id': place.id}
  //   .card-border
  //     .card
  //       .front
  //         .poster
  //           - title = t('app.common.alt', alt: place.name)
  //           = link_to image_tag(asset_path("png/missing.png"), alt: title, title: title, class: 'image'), place_path(place.id)
  //           - if true # place.favorized
  //             = render partial: "shared/favorite"
  //           = render partial: "shared/rating", locals: { rating: place.rating }
  //         .place-info
  //           = link_to place.name, place_path(place.id), class: 'name'
  //           .provider
  //             %span #{"by "}
  //             = link_to place.provider.name, root_path, 'data-filter': "provider=#{place.provider.id}"
  //           - ss = place.services
  //           - if ss.length >= 1
  //             - s = ss.first
  //             .first-service.service
  //               %i{ class: s.icon }
  //               %strong=s.name
  //               - if ss.length > 1
  //                 .ellipsis
  //           %ul.contact
  //             %li
  //               %span.icon.address
  //               = place.address
  //             %li
  //               %span.icon.phone
  //               = place.phone
  //       - if place.services.length > 1
  //         .back.hidden
  //           .close
  //           %ul.services
  //             = place.services.map { |s| "<li class='service'><i class='#{s.icon}'></i><span>#{s.name}</span></li>" }.join("").html_safe
  //             = place.services.map { |s| "<li class='service'><i class='#{s.icon}'></i><span>#{s.name}</span></li>" }.join("").html_safe
  //             = place.services.map { |s| "<li class='service'><i class='#{s.icon}'></i><span>#{s.name}</span></li>" }.join("").html_safe
  //             = place.services.map { |s| "<li class='service'><i class='#{s.icon}'></i><span>#{s.name}</span></li>" }.join("").html_safe
  //             = place.services.map { |s| "<li class='service'><i class='#{s.icon}'></i><span>#{s.name}</span></li>" }.join("").html_safe
  //             = place.services.map { |s| "<li class='service'><i class='#{s.icon}'></i><span>#{s.name}</span></li>" }.join("").html_safe
  //   - if with_rator
  //     = render partial: 'shared/rator'

}
