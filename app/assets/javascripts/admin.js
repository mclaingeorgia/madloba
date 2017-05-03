/* global $ */
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/extras/dataTables.responsive
//= require tinymce.min


$(document).ready(function(){
  $('.datatable').DataTable({
    language: {
        search: "_INPUT_",
        searchPlaceholder: "Search",
        lengthMenu: "_MENU_ Records Per Page"
    },
    autoWidth: false,
    responsive: true,
    dom: '<".datatable-filters"fl>rt<"datatable-pagination"p>',
    columnDefs: [
      { targets: 'sorting_disabled', orderable: false }
    ]
  })

  tinymce.init({
    selector: 'textarea.tinymce' ,
    menubar: false,
    statusbar: false,
    // cleanup: false,
    // browser_spellcheck: false,
    // gecko_spellcheck: false,
     allow_html_in_named_anchor: true,
     valid_elements: "*[*]",
  //    extended_valid_elements: 'span',
  //   valid_children : '+a[span]',
  //    valid_classes: {
  //   'span': 'caret'
  // },
    plugins: [ 'autolink lists link anchor code' ],
    toolbar: 'undo redo | insert | styleselect | bold italic | link | code'
  });

  if($('#locator_map').length) {

    var center_point = gon.default_point
    var lat = $("input[name$='[latitude]'")
    var lon = $("input[name$='[longitude]'")

    if (lat.length && lon.length) {
      center_point = [lat.first().val(), lon.first().val()]
    }

    var locator_map = L.map('locator_map', {
      zoomControl: false
    }).setView(center_point, 13);

    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: '<a href="http://osm.org/copyright">OpenStreetMap</a>'
    }).addTo(locator_map);


    var locator_marker = L.marker(center_point, {icon:
      L.icon({
        iconUrl: '/assets/svg/pin.svg',
        iconSize: [28, 36],
        iconAnchor: [14,36]
      })
    }).addTo(locator_map)

    $('#map_zoom_in').click(function(){

      locator_map.setZoom(locator_map.getZoom() + 1)
    });


    // zoom out function
    $('#map_zoom_out').click(function(){
      locator_map.setZoom(locator_map.getZoom() - 1)
    });

    locator_map.on('click', function(e) {
      locate(e.latlng)
    });
    $('#locator-find-me').click(function () {
      locator_map.locate({setView: true, maxZoom: 16});
    })
    locator_map.on('locationfound', function(e) {
      locate(e.latlng)
    });
    locator_map.on('locationerror', function(e) {
      $('#locator-find-me').addClass('disabled')
    });

    function locate(latlng) {
      $("input[name$='[latitude]'").val(latlng.lat)
      $("input[name$='[longitude]'").val(latlng.lng)
      locator_marker.setLatLng(L.latLng(latlng.lat, latlng.lng));
    }
  }


})

