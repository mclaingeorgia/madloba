/*global flash*/
//= require hook/ajax
//= require hook/click
//= require hook/keydown
//= require hook/resize
//
var pollution = {
  hooks: {
    click: [],
    keydown: [],
    resize: []
  },
  components: {
    nav: undefined,
    flash: undefined
  },
  elements: {
    contact_map: undefined,
    pin: L.icon({ iconUrl: gon.pin_path, iconSize: [28, 36], iconAnchor: [14,36] })
  }
}


/*
  On Enter and Space keydown for label that have role='button',
  click event fired to mimic default behavior ex: checkbox label
*/
// pollution.hooks.keydown.push(function(code, event) {
//   if ((code === 13) || (code === 32)) { // 13 = Return, 32 = Space
//     var $target = $(event.target)
//     console.log(event)
//     if(event.target.nodeName.toLowerCase() === 'label' && $target.is("[role='button']")) {
//       $target.trigger('click')
//     }
//   }
// })

/*
  For all elements that require height to be set up correctly,
  use [data-set-max-height] attribute
  'parent' value will calculate height based on parent elements position
*/
pollution.hooks.resize.push(function(windowWidth, windowHeight) {
  $('[data-set-max-height]').each(function() {
    var t = $(this)
    var v = t.attr('data-set-max-height')
    if(v === 'parent') {
      var tmpHeight = t.parent().outerHeight() + t.parent().position().top + 1
      t.css('max-height', windowHeight - tmpHeight )
    }
    else {
      t.css('max-height', windowHeight - 75 )
    }
  })
})


/*
  On load fire resize hook, that will set height using [data-set-max-height]
  attribute
*/
$(window).trigger('resize')
