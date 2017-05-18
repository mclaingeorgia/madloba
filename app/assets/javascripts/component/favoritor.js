/* global $ */
/* eslint callback-return: 0 */

(function() {
  var favoritor = {
    bind: function ($element, callback) {// element should be .favoritor
      $element.click(function(event) {
        var current_d = $(this).attr("data-f")
        var d = current_d === 'true' ? false : true
        $element.attr('title', $element.attr('data-title-' + d))
        $element.attr('data-f', d)
        callback(d)
        event.stopPropagation()
      })
    },
    get: function ($element) {
      return $element.attr("data-f") === 'true' ? true : false
    }
  }
  pollution.components.favoritor = favoritor
}())
