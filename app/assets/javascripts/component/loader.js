/* global $ */
/* eslint callback-return: 0 */

(function() {
  var loader = {
    el: $('main'),
    start: function () {
      loader.el.addClass('loader')
    },
    stop: function () {
      loader.el.removeClass('loader')
    }
  }
  pollution.components.loader = loader
}())
