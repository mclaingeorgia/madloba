/* global $ */
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.min
//* require jquery_ujs
//* require bootstrap-sprockets

//* require cocoon
//* require typeahead.bundle.min

//* require bootstrap-select.min
//* require ajax-bootstrap-select.min

// library for cookie management
//* require jquery.cookie
// data table plugin
//* require jquery.dataTables.min
// select or dropdown enhancer
//* require chosen.jquery.min
// library for making tables responsive
//* require responsive-tables
// autogrowing textarea plugin
//* require jquery.autogrow-textarea
// application script for Charisma theme
//* require charisma

//* require leaflet

//* require leaflet-sidebar.min
//* require leaflet-function-button
//* require leaflet.markercluster
//* require leaflet.awesome-markers
//* require bouncemarker

//* require bootstrap-notify
//* require bootstrap-switch.min

//* require_tree .

$(document).ready(function(){
  $('nav .nav-toggle-button').on('click', function () {
    const t = $(this)
    const state = t.attr('aria-expanded')
    const target = $('#' + t.attr('data-target'))

    t.toggleClass('collapsed').attr('aria-expanded', !state)
    target.toggleClass('flex')
    // target.toggle()

    console.log('click')
  })

  // $('.tabs ul li a').on('click', function () {
  //   const t = $(this)
  //   const link = t.attr('data-link')
  //   const tabs = t.closest('.tabs')
  //   const targetAttr = tabs.attr('data-target')
  //   const target = $('.tabs-content[data-target="' + targetAttr + '"]')
  //   console.log(link,targetAttr, target)


  //   tabs.find('ul li a').attr('aria-expanded', false)
  //   tabs.find('ul li').removeClass('active')
  //   t.parent().addClass('active')

  //   target.find('ul li').removeClass('active')
  //   target.find('ul li[data-link="' + link + '"]').addClass('active')

  //   t.attr('aria-expanded', true)
  // })

  $('.tabs a').on('click', function (event) {
    const t = $(this)
    const link = t.attr('data-link')
    const tabs = t.closest('.tabs')
    const targetAttr = tabs.attr('data-target')
    const target = $('.tabs-content[data-target="' + targetAttr + '"]')
    // console.log(link,targetAttr, target)


    tabs.find('a').attr('aria-expanded', false)
    tabs.find('.tab-link').removeClass('active')
    if (t.hasClass("tab-link")) {
      t.addClass('active')
    } else {
      t.closest('.tab-link').addClass('active')
    }

    target.find('ul li').removeClass('active')
    target.find('ul li[data-link="' + link + '"]').addClass('active')

    t.attr('aria-expanded', true)

    if (targetAttr === 'global' && history.pushState) {
      var newurl =  t.attr('href');
      window.history.pushState({ path: newurl }, '', newurl);
    }
    event.preventDefault()
  })
})
