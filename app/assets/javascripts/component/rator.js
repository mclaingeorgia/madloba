/* global $ */
/* eslint callback-return: 0 */

(function() {
  var rator = {
    bind: function ($element, callback) {// element should be .rator
      $element.find(".heart").click(function(event) {
        var d = $(this).attr("data-r")
        $element.attr('data-r', d)
        callback(+d)
        event.stopPropagation()
      })
      $element.find(".reset").click(function(event) {
        $element.attr("data-r", 0)
        callback(0)
      })
    },
    get: function ($element) {
      return +$element.attr('data-r')
    }
  }
  pollution.components.rator = rator
}())
