/*global $*/

/*
  Bind different actions to window resize,
  callback method receives window width and height
*/
(function () {
  $(window).resize(function() {
    var w = $(window).width()
    var h = $(window).height()

    pollution.hooks.resize.forEach(function(f) {
      f.call(null, w, h)
    })
  })
})()

