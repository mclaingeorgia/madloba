
  $('.tabs a').on('click', function (event) {
    console.log("click")
    var t = $(this)
    var link = t.attr('data-link')
    var tabs = t.closest('.tabs')
    var targetAttr = tabs.attr('data-target')
    var target = tabs.parent().find('.tabs-content[data-target="' + targetAttr + '"]')
    // console.log(link,targetAttr, target)


    tabs.find('a').attr('aria-expanded', false)
    tabs.find('.tab-link').removeClass('active')
    if (t.hasClass("tab-link")) {
      t.addClass('active')
    } else {
      t.closest('.tab-link').addClass('active')
    }

    target.find('> ul > li').removeClass('active')
    target.find('> ul > li[data-link="' + link + '"]').addClass('active')

    t.attr('aria-expanded', true)

    if (targetAttr === 'global' && history.pushState) {
      var newurl =  t.attr('href');
      var tmp = / \|.+/g.exec(document.title)
      var title = ''
      if (tmp.length) {
        title = t.text() + tmp[0]
      }
      document.title = title
      window.history.pushState({ path: newurl }, '', newurl);
    }
    event.preventDefault()
  })
