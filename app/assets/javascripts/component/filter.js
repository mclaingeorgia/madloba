

  $('.filter-input .toggle').on('click', function () {
    var t = $(this)
    var p = t.closest('.filter-input')
    p.toggleClass('collapsed')
  })
  $('.filter-input .list .service .close').on('click', function () {
    var t = $(this)
    var service = t.parent()
    var service_id = service.attr('data-id')
    service.remove();
    var filter_input = p.closest('.filter-input')
    filter_input.find(".input-group service[data-id='" + service_id + "']").removeClass('hidden')
    // p.toggleClass('collapsed')
  })
  $('.filter-input .input-group .service').on('click', function () {
    var service = $(this)
    var service_id = service.attr('data-id')

    var filter_input = service.closest('.filter-input')
    filter_input.find('.list').append(service.clone().append('<div class="close"></div>'))
    service.addClass('hidden')

    // p.toggleClass('collapsed')
  })


