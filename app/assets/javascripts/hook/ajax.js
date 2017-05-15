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
      if(request.responseJSON.hasOwnProperty('reload') && request.responseJSON.reload === true) {
        console.log()

        if(request.responseJSON.hasOwnProperty('location')) {
          // var flash = ""
          // if(request.responseJSON.hasOwnProperty('flash')) {
          //   console.log(JSON.stringify(request.responseJSON.flash))
          //   flash = $.param({ flash: request.responseJSON.flash })
          //   console.log(flash, request.responseJSON.location + "?" + flash)
          // }
          location.replace(request.responseJSON.location)// + "?" + flash)
        }
        else {
          location.reload()
        }
      }
      else {
        if(request.responseJSON.hasOwnProperty('flash')) {
          pollution.components.flash.set(request.responseJSON.flash).open()
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
