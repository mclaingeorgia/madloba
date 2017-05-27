/* global $ */
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/extras/dataTables.responsive
//= require component/place_card
//= require component/slideshow

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

})


$(".field-file").change(function(e) {
  var t = $(this)
  var p = t.closest('.fields-asset')
    p.find('.field-asset[data-asset-id="-1"]').remove()

    $.each(e.originalEvent.srcElement.files, function(i, file) {
      var asset = $('<div class="field-wrapper field-asset blink" data-asset-id="-1"></div>').insertAfter(t)
      var img = document.createElement("img")
      var reader = new FileReader()
      reader.onloadend = function () {
        asset.removeClass('blink')
        img.src = reader.result
      }
      reader.readAsDataURL(file)
      asset.append(img)
    })
})

$('.fields-asset .field-asset:not([data-asset-id="-1"]) img').click(function () {
  var asset = $(this).parent()
  var assets = asset.parent()
  assets.find('.field-asset.picked').removeClass('picked')
  asset.addClass('picked')
  $('#place_poster_id').val(asset.attr('data-asset-id'))
})

$('.field-array .field-add').click(function(event) {
  var field_array = $(this).parent()
  var max_inputs = +field_array.attr('data-max')

  if(field_array.find('input').length < max_inputs) {
    $cl = field_array.find('input:last-of-type').clone()
    $cl.val('')
    $cl.insertBefore($(this))
  }
  else {
    $(this).hide()
  }
  event.stopPropagation()
  event.preventDefault()
})

$(".field-tag .field-input").keydown(function(event) {
  var t = $(this)
  var tag_wrapper = t.parent().find('.field-inputs')
  var code = event.keyCode || event.which
  var v = t.val()
  console.log(code)
  if(code === 13 && !tag_wrapper.find('li input[value="' + v + '"]').length) {
    tag_wrapper.append('<li><label>' + v + '</label><input type="hidden" value="' + v + '" name="place[tags][]"><div class="close"></div></li>')
    t.val('')
  }
})

$(".field-tag .field-inputs").on('click', ' .close', function(event) {
  var t = $(this)
  console.log('clicked')
  t.parent().remove()
})
