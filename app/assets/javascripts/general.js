/*global flash*/
//= require hook/ajax
//= require hook/click
//= require hook/keydown
//= require hook/resize

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
    pin: L.icon({ iconUrl: gon.pin_path, iconSize: [28, 36], iconAnchor: [14,36], popupAnchor: [0, -36] }),
    pin_highlight: L.icon({ iconUrl: gon.pin_highlight_path, iconSize: [28, 36], iconAnchor: [14,36], popupAnchor: [0, -36] })
  }
}


 $(document).on("click", "[data-xhr]", function (event) {
  console.log('data-xhr click')
    xhr($(this))

    event.preventDefault();
    event.stopPropagation();
  })

function xhr($element) {
  console.log('called')
  var t = $element
  var caller = t.attr('data-xhr') || t.attr('data-xhr-redirected')
  var format = t.attr('data-xhr-format')
  var type = t.attr('data-xhr-method')
  if(typeof format === 'undefined') { format = 'html' }
  if(typeof type === 'undefined') { type = 'GET' }
  var url = t.attr('href')

  // console.log('data-xhr', caller, format, url)
  $.ajax({
    url: url,
    dataType: format,
    type: type,
    cache: false
  })
    .success(function (data) {
      if(format === 'html') {
        if(['sign_in', 'forgot' ].indexOf(caller) !== -1) {
          if(device.desktop()) {
            $(".form-placeholder").html(data)
            pollution.components.popup.set_state(1)
          }
          else {
            console.log(pollution.components, caller, data)
            pollution.components.dialog.create(caller, data).open(caller)
          }
        } else if(caller === 'ownership') {
          pollution.components.dialog.page(caller, data).open(caller)
        }
      }
    })
    .error(function (e) {
      console.log('data-xhr error', e)
    })
 }

if(gon.hasOwnProperty('history')) {
  if(gon.history === 'replace') {
    console.log('history updated')
    history.replaceState({}, null,  window.location.pathname)
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
  if(device.desktop()) {
    $('[data-set-max-height]').each(function() {
      var t = $(this)
      var v = t.attr('data-set-max-height')
      if(v === 'parent') {
        var p = t.parent()
        var tmpHeight = p.outerHeight() + p.offset().top + 1
        t.css('max-height', windowHeight - tmpHeight )
      }
      else {
        t.css('max-height', windowHeight - 75 )
      }
    })
  }
})


/*
  On load fire resize hook, that will set height using [data-set-max-height]
  attribute
*/
$(window).trigger('resize')



// Function from David Walsh: http://davidwalsh.name/css-animation-callback
function whichTransitionEvent(){
  var t,
      el = document.createElement("fakeelement");

  var transitions = {
    "transition"      : "transitionend",
    "OTransition"     : "oTransitionEnd",
    "MozTransition"   : "transitionend",
    "WebkitTransition": "webkitTransitionEnd"
  }

  for (t in transitions){
    if (el.style[t] !== undefined){
      return transitions[t];
    }
  }
}

var transitionEvent = whichTransitionEvent();


function whichAnimationEvent(){
  var t,
      el = document.createElement("fakeelement");

  var animations = {
    "animation"      : "animationend",
    "OAnimation"     : "oAnimationEnd",
    "MozAnimation"   : "animationend",
    "WebkitAnimation": "webkitAnimationEnd"
  }

  for (t in animations){
    if (el.style[t] !== undefined){
      return animations[t];
    }
  }
}

var animationEvent = whichAnimationEvent();
