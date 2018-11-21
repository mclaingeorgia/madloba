(function() {
  $('.menu .expand').click(function() {
    var $t = $(this)
    $t.closest('li').find('ul').toggleClass('open')
    $t.toggleClass('expanded')
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
