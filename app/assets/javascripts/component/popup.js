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

      $(document).on("click", "[data-reattach]", function (e, post_url) {
        var tt = $(this)
        $.ajax({
          url: tt.attr("href"),
          dataType: 'html'//,
        }).success(function (d) {
          $(".form-placeholder").html(d)
          t.is_open = true
        }).error(function (e) {
        }).complete(function (e,b) {
        });

        e.preventDefault();
        e.stopPropagation();
      });

      pollution.hooks.click.push(function(event) {
        if(t.is_open) {
          var tt = $(event.toElement)
          if (!tt.closest(".form-placeholder").length) {
            t.is_open = false
            $(".form-placeholder").html("")
          }
        }
      })

      $(document).on("click", "a[data-trigger]", function (event) {
        var tt = $(this)
        var to_trigger = tt.attr("data-trigger")
        console.log($("[data-reattach='" + to_trigger + "']"))
        $("[data-reattach='" + to_trigger + "']").trigger("click", tt.attr('href'))
        event.preventDefault()
        event.stopPropagation()
      })
    }
  }

  popup.init()
  // pollution.components.nav = nav
}())
