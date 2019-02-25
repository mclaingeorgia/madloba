/* global $ */
/* eslint callback-return: 0 */

(function() {
  var age = {
    current_age_selection: undefined,
    // hide services if they do not apply to the current age selection
    update_service_visibility: function($elements){
      var t = age
      if (t.current_age_selection == undefined){
        // show all
        $('.services li').show()
      }else{
        // show only services that have this age match
        var age_value = t.get($elements)
        $('.services li[data-' + age_value + '="true"]').show()
        $('.services li[data-' + age_value + '="false"]').hide()
      }
    },
    bind: function ($elements, callback) {// elements should be input[name='age']
      var t = age
      $elements.each(function(i, element){
        $(element).click(function(event) {
          // deselect the item if necessary
          if(t.current_age_selection == event.target){
            event.target.checked = false
            t.current_age_selection = undefined
          } else {
            t.current_age_selection = event.target
          }

          t.update_service_visibility($elements)
          callback(t.get($elements))
        })
      })
    },
    get: function ($elements) {
      var value
      // go through each radio button and look for checked item
      $elements.each(function(i, element){
        if ($(element).is(':checked')){
          value = $(element).val()
        }
      })
      return value
    }
  }
  pollution.components.age = age
}())
