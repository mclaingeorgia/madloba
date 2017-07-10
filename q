[1mdiff --git a/app/assets/javascripts/component/filter.js b/app/assets/javascripts/component/filter.js[m
[1mindex 72f9cd7..46b1fc1 100644[m
[1m--- a/app/assets/javascripts/component/filter.js[m
[1m+++ b/app/assets/javascripts/component/filter.js[m
[36m@@ -25,6 +25,8 @@[m
 [m
       t.prepaire_data()[m
       t.process_send()[m
[32m+[m[32m      t.map_highlight_region(false)[m
[32m+[m
       return t[m
     },[m
     prepaire_data: function () {[m
[36m@@ -211,6 +213,15 @@[m
       t.els['what'].keydown(search_keydown)[m
       t.els['where'].keydown(search_keydown)[m
 [m
[32m+[m[32m       $('#region_filter').select2({[m
[32m+[m[32m        width: '100%',[m
[32m+[m[32m        allowClear: true[m
[32m+[m[32m      })[m
[32m+[m[32m        .on('change', function (evt) {[m
[32m+[m[32m          t.process('search')[m
[32m+[m[32m          t.map_highlight_region()[m
[32m+[m[32m        })[m
[32m+[m
       t.els['search'].click(function () {[m
         t.process('search')[m
       })[m
[36m@@ -278,12 +289,14 @@[m
       } else if (t.dynamic_map) {[m
         t.map_move_end()[m
       }[m
[32m+[m
     },[m
     render_count: function (n) {[m
       var t = filter[m
       t.els['count'].html(n + '&nbsp;<span>' + gon.labels[n > 1 ? 'results' : 'result'] + '</span>')[m
     },[m
     map_move_end: function () {[m
[32m+[m[32m      console.log("map_move_end")[m
       var t = filter[m
       if(!t.dynamic_map) { return }[m
       var mp = pollution.elements['places_map'][m
[36m@@ -301,12 +314,13 @@[m
       pollution.elements['places_map_marker_group'].eachLayer(function (layer) {[m
         t.els['result'].find('.place-card[data-place-id="' + layer.options._place_id + '"]').toggleClass('hidden', !bounds.contains(layer.getLatLng()))[m
       });[m
[31m-[m
[32m+[m[32m      console.log("map move end")[m
       t.render_count(t.els['result'].find('.place-card:not(.hidden)').length)[m
       setTimeout(function() { $result_container.removeClass('loader') }, 200)[m
     },[m
     map_switch: function (value) {[m
       var t = filter[m
[32m+[m[32m        console.log('here')[m
       if(value === true) {[m
         t.dynamic_map = true[m
         var $result_container = t.els['result'].parent()[m
[36m@@ -316,7 +330,6 @@[m
         t.els['result'].find('.region').addClass('collapsed')[m
 [m
         t.map_move_end()[m
[31m-[m
         $result_container.removeClass('loader')[m
       }[m
       else {[m
[36m@@ -326,6 +339,25 @@[m
         t.els['result'].find('.place-card').addClass('hidden')[m
         t.render_count(t.els['result'].find('.place-card').length)[m
       }[m
[32m+[m[32m    },[m
[32m+[m[32m    map_highlight_region: function (fly) {[m
[32m+[m[32m      if(typeof fly === 'undefined') { fly = true }[m
[32m+[m[32m      console.log("map_highlight_region")[m
[32m+[m[32m      var t = filter[m
[32m+[m[32m      var region_ids = t.els['where'].val()[m
[32m+[m[32m      console.log(region_ids, gon.regions)[m
[32m+[m[32m      var fly_coordinates = ['41.44273', '45.79102'][m
[32m+[m[32m      var zoomTo = 7[m
[32m+[m[32m      if(region_ids !== null)  {[m
[32m+[m[32m        if(region_ids.length === 1) {[m
[32m+[m[32m          var r = gon.regions.filter(function(f) { return f[0] === +region_ids[0] })[0][m
[32m+[m[32m          fly_coordinates = [r[2], r[3]][m
[32m+[m[32m          zoomTo = 8[m
[32m+[m[32m        } else {[m
[32m+[m[32m          fly = false[m
[32m+[m[32m        }[m
[32m+[m[32m      }[m
[32m+[m[32m      pollution.components.map.set_view('places_map', fly_coordinates, zoomTo, fly)[m
     }[m
   }[m
   pollution.components.filter = filter[m
