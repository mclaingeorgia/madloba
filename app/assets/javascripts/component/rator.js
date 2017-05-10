
  $(".rator .heart").click(function(event) {
    var $r = $(this)
    var $rator = $r.closest('.rator')
    r = $r.attr("data-r")
    console.log("Do something with r", r)
    $rator.attr('data-r', r)
    event.stopPropagation();
  })
  $(".rator .close").click(function(event) {
    $rator = $(this).closest('.rator').attr("data-r", 0)
  })
