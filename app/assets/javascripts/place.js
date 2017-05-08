/* global $ */

$(document).ready(function(){
  var $mp = $('#place_map_container')
  if($mp.length) {
    var coordinate = [$mp.attr("data-latitude"), $mp.attr("data-longitude")]

    var mp = L.map('place_map_container', {
      zoomControl: false
    }).setView(coordinate, 16);

    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: '<a href="http://osm.org/copyright">OpenStreetMap</a>'
    }).addTo(mp);


    L.marker(coordinate, {icon:
      L.icon({
        iconUrl: gon.pin_path,
        iconSize: [28, 36],
        iconAnchor: [14,36]
      })
    }).addTo(mp)

    var map_container = $mp.parent()

    map_container.find('#map_zoom_in').click(function(){
      mp.setZoom(mp.getZoom() + 1)
    });

    map_container.find('#map_zoom_out').click(function(){
      mp.setZoom(mp.getZoom() - 1)
    });
  }

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
})
