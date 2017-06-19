/* global $ */
/* eslint callback-return: 0 */

(function() {
  var services = {
    bind: function ($element, callback) {
      var t = services

      var $list = $element.find('.list')
      var $group = $element.find('.input-group')
      var state = {
        is_open: false,
        reset: [],
        order: JSON.parse($list.attr('data-order'))
      }
      var close_html = '<div class="close"></div>'

      $element.find('.toggle').click(function () {
        if(!state.is_open) {
          t.stop_events(true)
          $element.toggleClass('collapsed', state.is_open)
          state.is_open = !state.is_open
          state.reset = t.get($element)
        }
        else {
          $element.find('button.reset').trigger('click')
        }
      })

      $list.on('click', '.service .close', function () {
        var $s = $(this).parent()

        state.order.splice(state.order.indexOf(+$s.attr('data-order')),1)
        $s.remove()
        $group.find(".service[data-id='" + $s.attr('data-id') + "']").removeClass('hidden')
        $(window).trigger('resize')
        if(!state.is_open) {
          callback(t.get($element))
        }
      })

      $group.find('.service').click(function () {
       var $s = $(this)
       var oid = +$s.attr('data-order')
       var order_index
       var insert_position
       var $el = $s.clone().append(close_html)
       state.order.push(oid)
       state.order.sort(function (a, b) {  return a - b;  })
       order_index = state.order.indexOf(oid)

       insert_position = state.order[order_index === 0 ? order_index : order_index - 1]

       if(order_index === 0) {
         $list.prepend($el)
       }
       else {
         $el.insertAfter($list.find('.service[data-order="' + insert_position + '"]'))
       }

       $s.addClass('hidden')
       $(window).trigger('resize')
      })

      $element.find('button.apply').click(function () {
        t.stop_events(false)
        state.is_open = false
        $element.addClass('collapsed')
        callback(t.get($element))
      })

      $element.find('button.reset').click(function () {
       t.stop_events(false)
       state.is_open = false
       $element.addClass('collapsed')

       $list.empty()
       $group.find('.service').removeClass('hidden')
       state.order = []
       state.reset.forEach(function(sid) {
         var $s = $group.find('.service[data-id="' + sid + '"]')
         state.order.push($s.attr('data-order'))
         $list.append($s.clone().append(close_html).removeClass('hidden'))
         $s.addClass('hidden')
       })
       $(window).trigger('resize')
      })
    },
    get: function ($element) {
      var services = []
      $element.find('.list .service').each(function(i, service) { services.push(+service.dataset.id) })
      return services
    },
    stop_events: function(state) {
      $('main').toggleClass('stop_events', state)
      if(state) {

        $(document).on('click.stop_events', function () {
          var el = $(event.target)
          if(el.hasClass('app')) {
            $('.filter-service').addClass('highlighted')
          }
        })
      }
      else {
        $(document).off('click.stop_events')
        $('.filter-service').removeClass('highlighted')
      }

    }
  }
  pollution.components.services = services
}())
