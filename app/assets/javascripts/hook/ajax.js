/*global $*/

(function () {
  /*
    If ajax response has flash object in responseJSON, open flash
  */
  $(document).ajaxComplete(function(event, request) {
    // if(request.getResponseHeader('X-Message') !== null) {
    //   request.getResponseHeader("X-Message-Type");
    // }
    console.log(request, request.responseText)
    if(request.hasOwnProperty('responseJSON')) {
      var json = request.responseJSON
      if(json.hasOwnProperty('reload') && json.reload === true) {

        if(json.hasOwnProperty('location')) {
          // console.log(json.location)
          location.replace(json.location)// + "?" + flash)
        }
        else {
          // console.log('reloaded')
          location.reload()
        }
      }
      else {
        if(json.hasOwnProperty('trigger')) {
          $('[data-xhr="' + json.trigger + '"]').trigger('click')
        }
        if(json.hasOwnProperty('flash')) {
          pollution.components.flash.set(json.flash).open()
        }
        if(json.hasOwnProperty('refresh')) {
          partial_refresher(json.refresh)
        }
        if(json.hasOwnProperty('remove_asset')) {
          $('[data-asset-id="' + json.remove_asset + '"]').remove()
        }
        // if(json.hasOwnProperty('remove_place')) {
        //   $('[data-place-id="' + json.remove_place + '"]').remove()
        // }
        if(json.hasOwnProperty('moderate') && json.moderate.hasOwnProperty('type')) {
          var type = json.moderate.type
          if (type === 'report') {
            var id = json.moderate.id
            var state = json.moderate.state
            var state_was = state === 'accept' ? 'decline' : 'accept'
            var stated = state === 'accept' ? 'accepted' : 'declined'
            var generated_url = ''
            var $report = $('[data-report-id="' + id + '"]')
            var previous_state = $report.attr('data-report-state')

            if(typeof previous_state !== 'undefined') {
              $report.attr('data-report-state', null)
              $report.find('.state span').text(gon.labels[stated]).parent().removeClass('hidden')
              $report.find('.actions a').first().remove()
              generated_url = gon.labels.place_report_path.replace('_id_', id).replace('_state_', state_was)
              $report.find('.actions a').removeClass(state).addClass(state_was).attr('href', generated_url).text(gon.labels[state_was])
              // console.log('move to processed')


              $report_view = $('.tabs-content [data-link="processed"] .report-view')
              $report_view.find('.no-data-found').remove()
              $report_view.append($report.detach())

              var $report_view_pendings = $('.tabs-content [data-link="pending"] .report-view')
              if(!$report_view_pendings.find('.report').length) {
                $report_view_pendings.find('.all-done').removeClass('hidden')
              }

            }
            else {
              console.log('already in processed')
              $report.find('.state span').text(gon.labels[stated])
              generated_url = gon.labels.place_report_path.replace('_id_', id).replace('_state_', state_was)
              $report.find('.actions a').removeClass(state).addClass(state_was).attr('href', generated_url).text(gon.labels[state_was])
            }

          } else if (type === 'upload') {
            var id = json.moderate.id
            var state = json.moderate.state
            var state_was = state === 'accept' ? 'decline' : 'accept'
            var stated = state === 'accept' ? 'accepted' : 'declined'
            var stated_was = state === 'accept' ? 'declined' : 'accepted'
            var generated_url = ''
            var $report = $('[data-upload-id="' + id + '"]')
            var previous_state = $report.attr('data-upload-state')

            if(typeof previous_state !== 'undefined') {
              $report.attr('data-upload-state', null)
              $report.find('.actions a').first().remove()
            }
            console.log($report.find('.state'))
            $report.find('.state').text(gon.labels[stated]).removeClass(stated_was).addClass(stated)
            generated_url = gon.labels.upload_state_path.replace('_id_', id).replace('_state_', state_was)
            $report.find('.actions a').removeClass(state).addClass(state_was).attr('href', generated_url).text(gon.labels[state_was])
          }

        }

      }
    }
  });

  function partial_refresher(options) {
    // console.log(options)
    if (typeof options['type'] !== undefined) {
      var type = options['type']
      // console.log(type)
      if (typeof options['to'] !== undefined) {
        var to = options['to']
        var $place
        if(type === 'rate') {
          if(Array.isArray(to) && to.length === 2) {
            var $rator = $('[data-place-id="' + options['place_id'] + '"] .rator')
            $place = $rator.closest('[data-place-id]')
            $rator.attr('data-r', to[0])
            $place.find('.rating .value span').text(to[1])
          }
        } else if (type === 'favorite') {
          var $favoritor = $('[data-place-id="' + options['place_id'] + '"] .favoritor')
          $place = $favoritor.closest('[data-place-id]')
          console.log(to, to === true)
          if(to === true || to === false) {
            $favoritor.attr('data-f', to).attr('href', $favoritor.attr('data-href-template').replace(/_v_/g, !to))
            $favoritor.attr('title', to ? gon.labels.unfavorite : gon.labels.favorite)
          }
        }
        // else if (type === 'ownership') {
        //   $('a.take-ownership').parent().html('<div class="take-ownership"><label>' + gon.labels.ownership_under_consideration + '</label>')
        // }
        else if (type === 'report') {
          $('a.report').parent().html('<div class="report"><label>' + gon.labels.report_under_consideration + '</label>')
        }
        else if (type === 'assign') {
          if(options['action'] === 'add') {
            $('[data-assign="' + options['target'] + '"] .field-list').append('<li data-assignee-id="' + to[0] + '"><span>' + to[1] + '</span><a data-type="json" data-confirm="' + gon.labels.are_you_sure + '" class="close" data-remote="true rel="nofollow" data-method="patch" href="' + to[2] + '"></a></li>')
          }
          else if (options['action'] === 'delete') {
            $('[data-assign="' + options['target'] + '"] .field-list li[data-assignee-id="' + to + '"]').remove()
          }
        }
      }
    }

  }
  /*
    Accompany all ajax request with csrf-tokern
  */
  $(document).ajaxSend(function(e, xhr, options) {
    var token = $('meta[name="csrf-token"]').attr('content');
    if (token) xhr.setRequestHeader('X-CSRF-Token', token);
  });
})()
