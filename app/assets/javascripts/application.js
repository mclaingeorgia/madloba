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

  $('.flash .close').on('click', function (event) {
    $(this).closest('.flash').remove()
  })

  $('.flash').delay(10000).fadeOut(2000, function () { $(this).remove(); })

  /* ------------------------------- dialog -------------------------------*/
    const dialog = $('dialog')
    const dialog_callbacks = {
      contact: function () {
        console.log("called")
        contact_map.invalidateSize()
      }
    }
    $('dialog .dialog-close a').on('click', function (event) {
      dialog_close();
    })
    function dialog_close () {
      dialog.removeAttr('open')
      dialog.find('.dialog-page[data-showing]').removeAttr('data-showing')
    }
    function dialog_open (page) {
      dialog_close();
      dialog.find('.dialog-page[data-bind="' + page + '"]').attr('data-showing', true)
      console.log(page, dialog_callbacks.hasOwnProperty(page))
      dialog.attr('open', true)
      if(dialog_callbacks.hasOwnProperty(page)) {
        dialog_callbacks[page]();
      }
    }
    $('a[data-dialog-link]').on('click', function () {
      const page = $(this).attr('data-dialog-link')
      dialog_open(page)
    })

    /* ------------------------------- dialog -------------------------------*/


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
})

let contact_map
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
