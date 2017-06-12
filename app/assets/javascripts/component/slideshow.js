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

      return t
    },
    open: function (src) {
      var t = slideshow
      t.image_el.attr('src', src)

      t.el.attr('open', 'open')
      return t
    },
    close: function () {
      var t = slideshow
      t.el.removeAttr('open')
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


      if(!device.desktop()) {
        t.content_el.swipe( {
          swipeLeft:function(event, direction, distance, duration, fingerCount) {
            t.next()
          },
          swipeRight:function(event, direction, distance, duration, fingerCount) {
            t.prev()
          }
        });
      }


      // t.content_el.on("swipe",function(event){
      //   console.log('swipe', event)
      // });
      pollution.hooks.keydown.push(function(code) {
        if (code === 27) { t.close() }
        else if (code === 37) { t.prev() }
        else if (code === 39) { t.next() }
      })
    }
  }

  slideshow.init()
  pollution.components.slideshow = slideshow
}())
