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
//= require jquery_ujs
//= require leaflet
//
//
//
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


//* require leaflet-sidebar.min
//* require leaflet-function-button
//* require leaflet.markercluster
//* require leaflet.awesome-markers
//* require bouncemarker

//* require bootstrap-notify
//* require bootstrap-switch.min

//* require_tree .
  var submitInvisibleRecaptchaForm = function () {
    console.log("here")
    document.getElementById("invisible-recaptcha-form").submit();
  };
$(document).ready(function(){

  var submitInvisibleRecaptchaForm = function () {
    console.log("here")
    document.getElementById("invisible-recaptcha-form").submit();
  };

  $( window ).resize(function() {
    resize()
  });

  function resize() {
    $('[data-set-max-height]').each(function() {
      var t = $(this)
      var v = t.attr('data-set-max-height')
      if(v === 'parent') {
        var height = t.parent().outerHeight() + t.parent().position().top + 1
        console.log(t.parent().outerHeight(),t.parent().position().top , $(window).height(), height)
        t.css('max-height', $(window).height() - height )
      }
      else {
        t.css('max-height', $(window).height() - 75 )
      }

    })
  }
  resize()

  var click_callbacks = []

  $(document).on('click', function (event) {
    var t = this
    click_callbacks.forEach(function(f) {
      f.call(event.toElement, event)
    })
  })

  var nav_toggle_button = $('nav .nav-toggle-button')
  function toggle_nav (forceState) {
    var target = $('#' + nav_toggle_button.attr('data-target'))
    if(typeof forceState !== 'undefined' && forceState === true) {
      nav_toggle_button.addClass('collapsed').attr('aria-expanded', false)
      target.removeClass('flex')
    }
    else {
      var state = nav_toggle_button.attr('aria-expanded')
      nav_toggle_button.toggleClass('collapsed').attr('aria-expanded', !state)
      target.toggleClass('flex')
      //dialog_close();
    }
  }
  nav_toggle_button.on('click', function () {
    toggle_nav()
  })

  // $('.tabs ul li a').on('click', function () {
  //   var t = $(this)
  //   var link = t.attr('data-link')
  //   var tabs = t.closest('.tabs')
  //   var targetAttr = tabs.attr('data-target')
  //   var target = $('.tabs-content[data-target="' + targetAttr + '"]')
  //   console.log(link,targetAttr, target)


  //   tabs.find('ul li a').attr('aria-expanded', false)
  //   tabs.find('ul li').removeClass('active')
  //   t.parent().addClass('active')

  //   target.find('ul li').removeClass('active')
  //   target.find('ul li[data-link="' + link + '"]').addClass('active')

  //   t.attr('aria-expanded', true)
  // })

  $('.tabs a').on('click', function (event) {
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

    target.find('ul li').removeClass('active')
    target.find('ul li[data-link="' + link + '"]').addClass('active')

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

  $('.flash .close').on('click', function (event) {
    $(this).closest('.flash').remove()
  })

  $('.flash').delay(10000).fadeOut(2000, function () { $(this).remove(); })

  /* ------------------------------- dialog -------------------------------*/
    var dialog = $('dialog')
    var dialog_callbacks = {
      contact: function () {
        window.contact_map = contact_map
        console.log("here")
        contact_map.invalidateSize()
      }
    }
    var dialog_state = false

    function dialog_close (partial) {
      if(!dialog_state) { return }
      if(typeof partial === 'undefined') { partial = false }
      dialog.removeAttr('open')
      dialog.find('.dialog-page[data-showing]').removeAttr('data-showing')

      if(!partial) {
        dialog_menu_state(false)
        dialog_state = false
      }

    }
    function dialog_open (page) {
      dialog_close(true);
      dialog_menu_state(true, page);
      dialog_state = true
      dialog.find('.dialog-page[data-bind="' + page + '"]').attr('data-showing', true)
      // console.log(page, dialog_callbacks.hasOwnProperty(page))
      dialog.attr('open', true)
      if(dialog_callbacks.hasOwnProperty(page)) {
        dialog_callbacks[page]();
      }
      toggle_nav(true)
    }
    function dialog_menu_state(state, page) {
      var nav_menu = $('nav .nav-menu')
      var link = nav_menu.find('a[data-dialog-link="' + page + '"]')
      nav_menu.find('a').removeClass('active')

      if(state) {
        link.addClass('active')
      } else {
        if(typeof gon !== 'undefined' && gon.hasOwnProperty('is_faq_page') && gon.is_faq_page) {
          nav_menu.find('a.nav-menu-item-faq').addClass('active')
        }
      }
    }


    click_callbacks.push(function(event) {
      var el = $(event.toElement)
      // console.log(el)
      if(dialog_state && (event.toElement.nodeName.toLowerCase() === 'dialog' ||
        (!el.hasClass('nav-toggle-button') &&
        el.closest('dialog').length === 0))) {
        dialog_close();
      }
    })

    $('dialog .dialog-close a').on('click', function (event) {
      dialog_close();
    })

    $('a[data-dialog-link]').on('click', function (event) {
      dialog_open($(this).attr('data-dialog-link'))
      event.stopPropagation()
    })

//     .hover(
//   function() {
//     $( this ).addClass( "hover" );
//   }, function() {
//     $( this ).removeClass( "hover" );
//   }
// );


    $(document).keydown(function(e) {
      var code = e.keyCode || e.which;
      if (code === 27) { dialog_close() }
    });

    /* ------------------------------- dialog -------------------------------*/
    /* ------------------------------- toggleable-list -------------------------------*/
      $('.toggleable-list > li > a').on('click', function (event, forceOpen) {
        if(typeof forceOpen === 'undefined') { forceOpen = false }

        var t = $(this)
        var name = t.attr("name")
        var li = $(this).parent()

        // console.log("here", forceOpen, name)
        if(forceOpen) {
          li.addClass('toggled')
          window.location.hash = name
        } else {
          li.toggleClass('toggled')
          t.attr("name", "")
          window.location.hash = name
          t.attr("name", name)
        }

        event.preventDefault()
      })


      $("a[href^='#']").click(function(event) {
        var t = $(this)
        // if(t.attr('href').replace('#','') !== t.attr('name')) {
          // console.log('.toggleable-list > li > a[name="' + $(this).attr('href').replace('#', '') + '"]')
        $('.toggleable-list > li > a[name="' + $(this).attr('href').replace('#', '') + '"]').trigger('click', true);
        // } else {
          // event.preventDefault()
        // }
      });

      if($('.toggleable-list').length && window.location.hash.length) {
        var hash = window.location.hash.replace('#', '')
        window.location.hash = ''
        $('.toggleable-list > li > a[name="' + hash + '"]').trigger('click', true);
      }
    /* ------------------------------- toggleable-list end -------------------------------*/

    contact_map = L.map('contact_map', {
      zoomControl: false
    }).setView([41.70978, 44.76133], 17);

    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: '<a href="http://osm.org/copyright">OpenStreetMap</a>'
    }).addTo(contact_map);


    L.marker([41.70995, 44.76134], {icon: pin}).addTo(contact_map)

    $('#contact_map_zoom_in').click(function(){
      contact_map.setZoom(contact_map.getZoom() + 1)
    });


    // zoom out function
    $('#contact_map_zoom_out').click(function(){
      contact_map.setZoom(contact_map.getZoom() - 1)
    });
        // .bindPopup('A pretty CSS3 popup.<br> Easily customizable.')
        // .openPopup();


    // L.marker([50.505, 30.57], {icon: myIcon}).addTo(map);

    // var contact_map = L.map('contact_map').setView([51.505, -0.09], 13);
    // L.tileLayer('https://api.mapbox.com/styles/v1/antarya/cj1eyowie00iu2rqssh9phros/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW50YXJ5YSIsImEiOiJjaXl5MDBhczAwMGYyMnFwbDA0eWEwdXYyIn0.7W7ecKO77P8GTP7f1wHrXQ', {foo: 'bar'})
    // .addTo(contact_map);

//     L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
//     attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
//     maxZoom: 18,
//     id: 'your.mapbox.project.id',
//     accessToken: 'your.mapbox.public.access.token'
// })

  // on page load check if about or contact page if yes open dialog
  var active_dialog_page = $('[data-dialog-link="about"].active, [data-dialog-link="contact"].active')
  if(active_dialog_page.length === 1) {
    dialog_open(active_dialog_page.attr('data-dialog-link'))
  }

  /* ------------------------------- popupable links -------------------------------*/
    var user_popup_is_open = false

    $(document).on("click", "[data-reattach]", function (e, post_url) {
      console.log(post_url)
      // navbarToggle();
      var t = $(this)
      //   data = {};
      // if (downloading) {
      //   data = { d: 1 };
      // }
      $.ajax({
        url: t.attr("href"),
        data: {
          post: post_url
        }
      }).success(function (d) {
        $(".form-placeholder").html(d)
        // console.log(d)
        user_popup_is_open = true
        // modal(d);
      }).error(function (e) {
        // console.log("error")
      });

      e.preventDefault();
      e.stopPropagation();
    });

    click_callbacks.push(function(event) {
      if(user_popup_is_open) {
        var t = $(this)
        // console.log("here", this)
        if (!t.closest(".form-placeholder").length) {
          user_popup_is_open = false
          $(".form-placeholder").html("")
        }
      }
    })


    $(document).on("click", "a[data-trigger]", function (event) {
      var t = $(this)
      var to_trigger = t.attr("data-trigger")
      console.log($("[data-reattach='" + to_trigger + "']"))
      $("[data-reattach='" + to_trigger + "']").trigger("click", t.attr('href'))
      event.preventDefault()
      event.stopPropagation()
    })

    $(document).on('ajax:success', 'form', function(e, data, status, xhr){
      console.log('ajax:success', e, data, status, xhr)
    });
    $(document).on('ajax:error', 'form', function(e, data, status, xhr){
      console.log('ajax:error', e, data, status, xhr)
    });
    // $("body").on("submit", ".nav-sign-in-form form", function (e) {
    //   console.log("form submit")
    //   var form = $(this);
    //   // if(form.attr("data-form-id").length) {
    //     $.ajax({
    //       type: "POST",
    //       url: form.attr("action"),
    //       data: form.serialize(),
    //       dataType: "json",
    //       success: function (data) {
    //          console.log("form back",data);
    //         // if (data.url) {
    //         //   js_modal_off();
    //         //   window.location.href = data.url;
    //         // } else {
    //         //   window.location.reload();
    //         // }
    //       },
    //       error: function (data) {
    //         console.log("error", data)
    //       }
    //     })
    //   // }
    // })
/* ------------------------------- popupable links end -------------------------------*/


  $('.place-card .ellipsis').on('click mouseenter', function () {
    var t = $(this).closest('.card-border')
    t.find('.front').addClass('invisible')
    t.find('.back').removeClass('hidden')
  })

  $('.card-border').on('mouseleave', function () {
    var t = $(this)
    t.find('.front').removeClass('invisible')
    t.find('.back').addClass('hidden')
  })
  $('.card-border .close').on('click', function () {
    var t = $(this).closest('.card-border')
    t.find('.front').removeClass('invisible')
    t.find('.back').addClass('hidden')
  })




  $('.filter-input .toggle').on('click', function () {
    var t = $(this)
    var p = t.closest('.filter-input')
    p.toggleClass('collapsed')
  })
  $('.filter-input .list .service .close').on('click', function () {
    var t = $(this)
    var service = t.parent()
    var service_id = service.attr('data-id')
    service.remove();
    var filter_input = p.closest('.filter-input')
    filter_input.find(".input-group service[data-id='" + service_id + "']").removeClass('hidden')
    // p.toggleClass('collapsed')
  })
  $('.filter-input .input-group .service').on('click', function () {
    var service = $(this)
    var service_id = service.attr('data-id')

    var filter_input = service.closest('.filter-input')
    filter_input.find('.list').append(service.clone().append('<div class="close"></div>'))
    service.addClass('hidden')

    // p.toggleClass('collapsed')
  })

})

var contact_map
    var pin = L.icon({
        iconUrl: '/assets/svg/pin.svg',
        //iconRetinaUrl: 'my-icon@2x.png',
        iconSize: [28, 36],
        // iconAnchor: [-14, -18],
        // popupAnchor: [-3, -76],
        // shadowUrl: 'my-icon-shadow.png',
        // shadowRetinaUrl: 'my-icon-shadow@2x.png',
        // shadowSize: [68, 95],
        // shadowAnchor: [22, 94]
    });



  //  }
  //     #in{
  //       position: absolute;
  //       top: 20px;
  //       left: 20px;
  //       padding-right: 10px;
  //       padding-left: 10px;
  //       z-index: 9000;
  //       background-color: #69D2E7;
  //       cursor:pointer;

  //     }
  //     #out{
  //       position: absolute;
  //       top: 70px;
  //       left: 20px;
  //       padding-right: 5px;
  //       padding-left: 10px;
  //       z-index: 9000;
  //       background-color: #A7DBDB;
  //       cursor:pointer;
  //     }

  //   </style>
  // </head>
  // <body>
  //   <div id="map"></div>
  //   <div id = 'in'><p>Click to Zoom in</p></div>
  //   <div id = 'out'><p>Click to Zoom out</p></div>


  //   <script type="text/javascript">
  //     var layer;
  //     var vector = [];
  //     var legend;

  //     function main() {

  //       var map = L.map('map', {
  //         zoomControl: false,
  //         center: [41.390205, 2.154007],
  //         zoom: 12,
  //         minZoom:9,
  //         maxZoom:13
  //       });

  //       // zoom in function
  //


