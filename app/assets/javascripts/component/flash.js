(function() {
  var flash = {
    el: undefined,
    content_el: undefined,
    init: function () {
      var t = flash
      t.el = $('#flash'),
      t.content_el = t.el.find('.messages')
      t.bind()

      if(t.el.find('.messages li').length) {
        t.open()
      }
      return t
    },
    set: function (messages) {
      var t = flash
      t.el.stop()
      t.close()
      var html = ""
      types = Object.keys(messages)
      types.forEach(function(type) {
          html += "<li class='message'><div class='flag " + type + "'></div><div class='text'>" +t.urldecode(messages[type]) + "</div></li>"
        })
      t.content_el.html(html)
      return t
    },
    open: function () {
      var t = flash
      t.el.attr('open', 'open').delay(5000).fadeOut(2000, function(){
        t.close()
      });
      return t
    },
    close: function () {
      var t = flash
      t.el.removeAttr('open')
      t.el.attr('style', '')
      t.content_el.empty()
      return t
    },
    // private
    bind: function () {
      var t = flash
      t.el.find('.close').on('click', function (event) {
        t.close()
      })
    },
    urldecode: function(url) {
      return decodeURIComponent(url.replace(/\+/g, ' '));
    }
  }

  flash.init()
  pollution.components.flash = flash
}())
