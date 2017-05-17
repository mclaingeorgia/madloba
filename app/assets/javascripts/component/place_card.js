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



function place_card_builder() {
  // id,
  // gon. app.common.alt with placeholder
  // image_path,
  // place_path(place.id)
  // place.rating
  // place.name
  // gon.labels by
  // place.provider.name with path to what
  // place.services s.icon, s.name,
  // place.address
  // place.phone
  // - with_rator ||= false
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
