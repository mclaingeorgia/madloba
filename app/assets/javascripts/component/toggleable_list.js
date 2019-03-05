(function() {
  var toggleable_list = {
    el: undefined,
    init: function () {
      var t = toggleable_list
      t.el = $('.toggleable-list')

      t.bind()

      if(t.el.length && window.location.hash.length) {
        var hash = window.location.hash.replace('#', '')
        window.location.hash = ''
        t.el.find('> li > a[name="' + hash + '"]').trigger('click', true);
      }
      return t
    },
    // private
    bind: function () {
      var t = toggleable_list

      t.el.find('> li > a').on('click', function (event, forceOpen) {
        if(typeof forceOpen === 'undefined') { forceOpen = false }

        var tt = $(this)
        var name = tt.attr("name")
        var li = $(this).parent()
        var other_lis = $(li).siblings()

        if(forceOpen) {
          li.addClass('toggled')
          window.location.hash = name
        } else {
          li.toggleClass('toggled')
          // if hash already exists,
          // remove it
          // else add it
          if (window.location.hash == '#' + name){
            window.location.hash = ''
          }else{
            tt.attr("name", "")
            window.location.hash = name
            tt.attr("name", name)
          }
        }
        // close all other lis
        other_lis.removeClass('toggled')

        event.preventDefault()
      })


      $("a[href^='#']").click(function(event) {
        t.el.find('> li > a[name="' + $(this).attr('href').replace('#', '') + '"]').trigger('click', true);
      });
    }
  }

  toggleable_list.init()
}())
