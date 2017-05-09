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

