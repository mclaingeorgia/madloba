/*global $*/

/*
  Bind different actions to document keydown,
  callback method receives key code and event
*/
(function () {
  $(document).keydown(function (event) {
    var code = event.keyCode || event.which

    pollution.hooks.keydown.forEach(function(f) {
      f.call(null, code, event)
    })
  })
})()

