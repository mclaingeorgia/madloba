(function() {
  $('.menu .expand').click(function() {
    var $t = $(this)
    $t.closest('li').find('ul').toggleClass('open')
    var currText = $t.text()
    var toggleText = $t.attr('data-toggle')
    $t.text(toggleText)
    $t.attr('data-toggle', currText)
  })

  function resizeIframes() {
    $('.content iframe').each(function(i,d) {
      $(d).attr('height', $(d).width()/1.77)
    })
  }
  $(window).resize(function() {
    resizeIframes()
  })
  resizeIframes()
}())
