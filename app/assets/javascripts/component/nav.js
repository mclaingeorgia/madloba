(function() {
  var nav = {
    el: undefined,
    toggle_el: undefined,
    menu_toggle_el: undefined,
    init: function () {
      var t = nav
      t.el = $('nav')
      t.toggle_el = t.el.find('.nav-toggle-button')
      t.menu_toggle_el = t.el.find('.nav-user-menu-link')
      t.bind()

      return t
    },
    toggle: function (forceState) {
      var t = nav

      var target = $('#' + t.toggle_el.attr('data-target'))
      if(typeof forceState !== 'undefined' && forceState === true) {
        t.toggle_el.addClass('collapsed').attr('aria-expanded', false)
        target.removeClass('flex')
      }
      else {
        var state = t.toggle_el.attr('aria-expanded')
        t.toggle_el.toggleClass('collapsed').attr('aria-expanded', !state)
        target.toggleClass('flex')
      }
    },

    // private
    bind: function () {
      var t = nav

      t.toggle_el.on('click', function () {
        t.toggle()
      })
      if(device.desktop()) {
        t.menu_toggle_el.on('mouseover', function (event) {
          console.log('mouseenter')
          $(this).parent().addClass('hover')
          event.preventDefault()
          event.stopPropagation()
        })
        t.menu_toggle_el.parent().on('mouseleave', function () {
          $(this).removeClass('hover')
          event.preventDefault()
          event.stopPropagation()
        })
      }
      else {
        t.menu_toggle_el.on('click', function () {
          $(this).parent().toggleClass('hover')
        })
      }
    }
  }

  nav.init()
  pollution.components.nav = nav
}())
