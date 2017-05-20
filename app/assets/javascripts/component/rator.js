/* global $ */
/* eslint callback-return: 0 */

(function() {
  var rator = {
    bind: function ($element, callback) {// element should be .rator
      $element.find(".heart").click(function(event) {
        var d = $(this).attr("data-r")
        var cur_d = $element.attr('data-r')

        if(d !== cur_d) {
          $element.attr('data-r', d)
          callback(+d, $element)
        }
        event.stopPropagation()
      })
      $element.find(".reset").click(function(event) {
        $element.attr("data-r", 0)
        callback(0, $element)
      })
    },
    deferred_bind: function ($element, callback) {// element should be .rator
      $element.find(".heart").click(function(event) {
        var d = $(this).attr("data-r")
        var cur_d = $element.attr('data-r')

        if(d !== cur_d) {
          callback(+d, $element)
        }
        event.stopPropagation()
      })
      $element.find(".reset").click(function(event) {
        callback(0, $element)
      })
    },
    get: function ($element) {
      return +$element.attr('data-r')
    }
  }
  pollution.components.rator = rator
}())
