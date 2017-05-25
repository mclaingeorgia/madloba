(function() {
   var dialog = {
    el: undefined,
    content_el: undefined,
    is_open: false,
    callbacks: {
      contact: function () {
        pollution.elements.contact_map.invalidateSize()
      }
    },
    init: function () {
      var t = dialog
      t.el = $('dialog')
      t.content_el = t.el.find('.messages')
      t.bind()

      // on page load check if about or contact page if yes open dialog
      var active_dialog_page = $('[data-dialog-link="about"].active, [data-dialog-link="contact"].active')
      if(active_dialog_page.length === 1) {
        t.open(active_dialog_page.attr('data-dialog-link'))
      }

      return t
    },
    set: function (state, page) {
      var t = dialog

      var nav_menu = $('nav .nav-menu')
      var link = nav_menu.find('a[data-dialog-link="' + page + '"]')
      nav_menu.find('a').removeClass('active')

      if(state) {
        link.addClass('active')
      } else {
        if(typeof gon !== 'undefined' && gon.hasOwnProperty('is_faq_page') && gon.is_faq_page) {
          nav_menu.find('a.nav-menu-item-faq').addClass('active')
        }
      }

      return t
    },
    open: function (page) {
      var t = dialog

      t.close(true)
      t.set(true, page);

      t.is_open = true
      t.el.find('.dialog-page[data-bind="' + page + '"]').attr('data-showing', true)
      t.el.attr('open', 'open')

      if(t.callbacks.hasOwnProperty(page)) {
        t.callbacks[page]();
      }
      pollution.components.nav.toggle(true)

      return t
    },
    close: function (partial) {
      var t = dialog

      if(!t.is_open) { return }
      if(typeof partial === 'undefined') { partial = false }
      t.el.removeAttr('open')
      t.el.find('.dialog-page[data-showing]').removeAttr('data-showing')

      if(!partial) {
        t.set(false)
        t.is_open = false
      }
      return t
    },

    // private
    bind: function () {
      var t = dialog

      t.el.find('.dialog-close a').on('click', function (event) {
        t.close();
      })

      $('a[data-dialog-link]').on('click', function (event) {
        t.open($(this).attr('data-dialog-link'))
        event.stopPropagation()
      })

      pollution.hooks.click.push(function(event) {
        var el = $(event.target)
        if(t.is_open && (event.target.nodeName.toLowerCase() === 'dialog' ||
          (!el.hasClass('nav-toggle-button') &&
          el.closest('dialog').length === 0))) {
          t.close();
        }
      })

      pollution.hooks.keydown.push(function(code) {
        if (code === 27) { t.close() }
      })
    }
  }

  dialog.init()
  pollution.components.dialog = dialog
}())
