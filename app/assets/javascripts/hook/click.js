/*global $*/

/*
  Bind different actions to document click,
  callback method receives event
*/
(function () {
  $(document).click(function (event) {
    pollution.hooks.click.forEach(function(f) {
      f.call(null, event)
    })
  })
})()

