(function() {
  var slideshow = {
    el: undefined,
    content_el: undefined,
    image_el: undefined,
    current_image: 0,
    count: 0,
    current_slides: undefined,
    init: function () {
      var t = slideshow
      t.el = $('#slideshow')
      t.content_el = t.el.find('.slideshow-image')
      t.image_el = t.content_el.find('img')
      t.bind()


// $(window).load(function(){
//  $('.container').find('img').each(function(){
//   var imgClass = (this.width/this.height > 1) ? 'wide' : 'tall';
//   $(this).addClass(imgClass);
//  })
// })
      // if(t.el.find('.messages li').length) {
      //   t.open()
      // }
      return t
    },
    set: function (messages) {
      var t = slideshow
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
    open: function (src) {
      var t = slideshow
      t.image_el.attr('src', src)

      t.el.attr('open', 'open')
        // .delay(5000).fadeOut(2000, function(){
        //   t.close()
        // });
      return t
    },
    close: function () {
      var t = slideshow
      t.el.removeAttr('open')
      // t.el.attr('style', '')
      t.image_el.attr('src', null)
      t.current_image = 0
      t.count = 0
      t.current_slides = undefined
      return t
    },
    prev: function () {
      var t = slideshow

      if(t.current_image <= 1) {
        t.current_image = t.count + 1
      }
      --t.current_image

      t.image_el.attr('src', t.current_slides.find('[data-slide][data-slide-n="' + t.current_image + '"]').first().attr('data-slide'))
    },
    next: function () {
      var t = slideshow

      if(t.current_image >= t.count) {
        t.current_image = 0
      }
      ++t.current_image
      t.image_el.attr('src', t.current_slides.find('[data-slide][data-slide-n="' + t.current_image + '"]').first().attr('data-slide'))
    },
    // private
    bind: function () {
      var t = slideshow
      $(document).on('click', '[data-slide]', function () {
        var slide = $(this)
        var slides_container = slide.closest('.slides')
        t.current_slides = slides_container
        t.count = 0
        slides_container.find('[data-slide]').each(function (i,d) {
          $(d).attr('data-slide-n', i + 1)
          ++t.count
        })
        t.current_image = +slide.attr('data-slide-n')
        t.open($(this).attr('data-slide'))
      })
      t.el.find('.slideshow-close').on('click', function (event) {
        t.close()
      })
      t.el.find('.slideshow-previous').on('click', function (event) {
        t.prev()
      })
      t.el.find('.slideshow-next').on('click', function (event) {
        t.next()
      })
      pollution.hooks.keydown.push(function(code) {
        if (code === 27) { t.close() }
      })
    }
  }

  slideshow.init()
  pollution.components.slideshow = slideshow
}())
