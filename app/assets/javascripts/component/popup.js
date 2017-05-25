(function() {
  var popup = {
    is_open: false,
    init: function () {
      var t = popup

      t.bind()

      return t
    },

    // private
    bind: function () {
      var t = popup

      pollution.hooks.click.push(function(event) {
        if(t.is_open) {
          var tt = $(event.target)
          if (!tt.closest(".form-placeholder").length) {
            t.is_open = false
            $(".form-placeholder").html("")
          }
        }
      })
    },
    set_state: function (state) {
      var t = popup
      t.is_open = state
    }
  }

  popup.init()
  pollution.components.popup = popup
}())
