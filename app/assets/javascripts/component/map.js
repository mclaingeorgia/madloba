(function() {

  var cmp = L.map('contact_map', { zoomControl: false})
                      .setView([41.70978, 44.76133], 17)
  pollution.elements.contact_map = cmp

  L.tileLayer(gon.osm, { attribution: gon.osm_attribution })
    .addTo(cmp)


  L.marker([41.70995, 44.76134], {icon: pollution.elements.pin })
    .addTo(cmp)



  $('.map_zoom_in').click(function() {
    var mp = pollution.elements[$(this).attr('data-map')]
    mp.setZoom(mp.getZoom() + 1)
  })

  $('.map_zoom_out').click(function(){
    var mp = pollution.elements[$(this).attr('data-map')]
    mp.setZoom(mp.getZoom() - 1)
  })

}())

// old code
  // var contact_map
  //     var pin = L.icon({
  //         iconUrl: gon.pin_path,
  //         //iconRetinaUrl: 'my-icon@2x.png',
  //         iconSize: [28, 36],
  //         // iconAnchor: [-14, -18],
  //         // popupAnchor: [-3, -76],
  //         // shadowUrl: 'my-icon-shadow.png',
  //         // shadowRetinaUrl: 'my-icon-shadow@2x.png',
  //         // shadowSize: [68, 95],
  //         // shadowAnchor: [22, 94]
  //     });
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


