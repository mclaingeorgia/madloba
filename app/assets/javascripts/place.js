/* global $ */

$(document).ready(function(){
  const $mp = $('#place_map_container')
  if($mp.length) {
    const coordinate = [$mp.attr("data-latitude"), $mp.attr("data-longitude")]

    const mp = L.map('place_map_container', {
      zoomControl: false
    }).setView(coordinate, 16);

    L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png', {
        attribution: '<a href="http://osm.org/copyright">OpenStreetMap</a>'
    }).addTo(mp);


    L.marker(coordinate, {icon:
      L.icon({
        iconUrl: '/assets/svg/pin.svg',
        iconSize: [28, 36],
        iconAnchor: [14,36]
      })
    }).addTo(mp)

    const map_container = $mp.parent()

    map_container.find('#map_zoom_in').click(function(){
      mp.setZoom(mp.getZoom() + 1)
    });

    map_container.find('#map_zoom_out').click(function(){
      mp.setZoom(mp.getZoom() - 1)
    });
  }

  $(".rator .heart").click(function(event) {
    const $r = $(this)
    const $rator = $r.closest('.rator')
    r = $r.attr("data-r")
    console.log("Do something with r", r)
    $rator.attr('data-r', r)
    event.stopPropagation();
  })
  $(".rator .close").click(function(event) {
    $rator = $(this).closest('.rator').attr("data-r", 0)
  })
})
