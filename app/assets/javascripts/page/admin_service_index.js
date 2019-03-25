(function() {
  var service_positions = {
    els: {},
    init: function () {
      var t = service_positions
      t.els['rows'] = $('body.services.index table tbody tr')
      t.els['roots'] = $(t.els['rows']).filter('.service-item')
      t.els['children'] = $(t.els['rows']).filter('.sub-service-item')

      t.bind()
      t.hide_arrows()

      return t
    },

    bind: function () {
      var t = service_positions

      // click on up arrow
      $(t.els['rows']).on('click', 'img.position.up', function(evt){
        t.move('up', $(evt.target).closest('tr'))
      })

      // click on down arrow
      $(t.els['rows']).on('click', 'img.position.down', function(evt){
        t.move('down', $(evt.target).closest('tr'))
      })

      // click on sub service
      $(t.els['active-sub-services']).on('click', 'input[type="checkbox"]', function(evt){
        t.toggle_submit_button()
      })
    },
    hide_arrows: function(){
      // the first and last sub-service arrows cannot be hidden via css so we have to do it with javascript

      var t = service_positions

      for(var i=0; i<t.els['roots'].length; i++){
        var $root = $(t.els['roots'][i])
        var rows = t.els['children'].filter('[data-group="' + $root.data('id') + '"]')
        if (rows){
          // turn on all arrows
          $(rows).find('img').css('visibility', 'visible')

          // hide first up
          $(rows[0]).find('img.up').css('visibility', 'hidden')

          // hide last down
          $(rows.slice(-1)).find('img.down').css('visibility', 'hidden')
        }
      }

    },
    update_url: function(url, id){
      return url.replace('%5Bid%5D', id)
    },
    call_url: function(url){
      $.ajax({
        type: "POST",
        dataType: "json",
        url: url,
        cache: false,
        success: function(json) {
        }
      });
    },
    move_row: function(direction, $row){
      var t = service_positions

      if ($row.hasClass('service-item')){
        // need to move the root service row and all of its sub-services
        if (direction === 'up'){
          // get group id of previous block
          var prev_group_id = $row.prev().data('group')

          // now move everything in the previous group to be after the last item of this gorup
          t.els['rows'].filter('[data-group="' + prev_group_id + '"]').insertAfter(t.els['rows'].filter('[data-group="' + $row.data('id') + '"]:last'))
        }else if (direction === 'down'){
          // get group id of next block (after last child record of this group)
          var next_group_id = t.els['rows'].filter('[data-group="' + $row.data('id') + '"]:last').next().data('group')

          // now move everything in the next group to be before the first item of this group ($row)
          t.els['rows'].filter('[data-group="' + next_group_id + '"]').insertBefore($row)
        }

      }else if ($row.hasClass('sub-service-item')){
        // just need to move one row
        if (direction === 'up'){
          $row.prev().insertAfter($row)
        }else if (direction === 'down'){
          $row.next().insertBefore($row)
        }
      }

    },
    move: function(direction, $tr){
      var t = service_positions

      // move the record
      var url
      if (direction === 'up'){
        url = gon.move_up_url
      }else if (direction === 'down'){
        url = gon.move_down_url
      }
      t.call_url(t.update_url(url, $tr.data('id')))

      //move the row
      t.move_row(direction, $tr)

      // update the arrow visibilities
      t.hide_arrows()
    }
  }

  service_positions.init()
}())
