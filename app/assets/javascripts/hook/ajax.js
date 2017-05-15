/*global $*/

(function () {
  /*
    If ajax response has flash object in responseJSON, open flash
  */
  $(document).ajaxComplete(function(event, request) {
    // if(request.getResponseHeader('X-Message') !== null) {
    //   request.getResponseHeader("X-Message-Type");
    // }
    console.log(request)
    if(request.hasOwnProperty('responseJSON')) {
      var json = request.responseJSON
      if(json.hasOwnProperty('reload') && json.reload === true) {
        console.log()

        if(json.hasOwnProperty('location')) {
          console.log(json.location)
          location.replace(json.location)// + "?" + flash)
        }
        else {
          console.log('reloaded')
          location.reload()
        }
      }
      else {
        if(json.hasOwnProperty('trigger')) {
          $('[data-reattach="' + json.trigger + '"]').trigger('click')
        }
        if(json.hasOwnProperty('flash')) {
          pollution.components.flash.set(json.flash).open()
        }
      }
    }
  });

  /*
    Accompany all ajax request with csrf-tokern
  */
  $(document).ajaxSend(function(e, xhr, options) {
    var token = $('meta[name="csrf-token"]').attr('content');
    if (token) xhr.setRequestHeader('X-CSRF-Token', token);
  });
})()
