/* global $ */
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/extras/dataTables.responsive
//= require select2
//= require component/place_card
//= require component/rator
//= require component/favoritor
//= require component/slideshow
//= require component/tinymce
//= require jquery-ui/widgets/sortable

$(document).ready(function(){
  $('datatable').each(function(i,d) {
    $d = $(d)
    $d.DataTable({
      language: {
          search: "_INPUT_",
          searchPlaceholder: "Search",
          lengthMenu: "_MENU_ Records Per Page"
      },
      autoWidth: false,
      responsive: true,
      dom: $d.hasClass('simple') ? 'rt' : '<".datatable-filters"fl>rt<"datatable-pagination"p>',
      "order": []
    })
  })

})
// columnDefs: [  { visible: false, targets: [5,12,13] } ],

$(".field-file").change(function(event) {
  var t = $(this)
  var p = t.closest('.fields-asset')
    p.find('.field-asset[data-asset-id="-1"]').remove()
    var target = event.target || event.srcElement;
    $.each(target.files, function(i, file) {
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
  var ln = field_array.find('input').length
  if(ln < max_inputs) {
    $cl = field_array.find('input:last-of-type').clone()
    $cl.val('')
    $cl.insertBefore($(this))
  }

  if(ln + 1 >= max_inputs) {
    $(this).hide()
  }

  event.stopPropagation()
  event.preventDefault()
})

if($(".field-tag").length) {
  $(".field-tag .field-input").select2({
    multiple: true,
    minimumInputLength: 3,
    placeholder: gon.labels.search_placeholder,
    escapeMarkup: function(m) { return m },
    templateResult: function (data) {
      return data.text
    },
    templateSelection: function (style) {
      if(!style.hasOwnProperty('state')) {
        style.state = +$(style.element).attr('data-state')
      }
      return $('<span data-state="' + ['pending', 'accepted', 'declined'][style.state] + '">' + style.text + '</span>')
    },
    ajax: {
      url: gon.autocomplete.tags,
      delay: 250,
      data: function (params) {
        return { q: params.term }
      }
    }
  })
  function prepare_tag_input () {
    $(".field-tag .select2-container [data-state]").each(function(i,d) {
      var d = $(d)
      var p = d.parent()
      var state = d.attr('data-state')
      p.addClass('state-' + state).attr('title', p.attr('title') + ' (' +  gon.tag_states[state] + ')')
    })
  }
  prepare_tag_input()
  $(".field-tag .field-input").on('change', function () {
    setTimeout(prepare_tag_input, 100)
  })
}

$('.rator').each(function(i,d) {
  pollution.components.rator.deferred_bind($(d), function(v, $element) {
    $element.attr('href', $element.attr('data-href-template').replace(/_v_/g, v))
    xhr($element)
  })
})

$('.favoritor').each(function(i,d) {
  pollution.components.favoritor.deferred_bind($(d), function(v, $element) {
    $element.attr('href', $element.attr('data-href-template').replace(/_v_/g, v))
    xhr($element)
  })
})

$("[data-assign]").each(function(i,d) {
    var t = $(this)
    var assign_type = t.attr('data-assign')
    var related_id = t.attr('data-related-id')
    var select = t.find('.field-input select')
    select.select2({
      minimumInputLength: 3,
      allowClear: true,
      placeholder: gon.labels.search_placeholder,
      ajax: {
        url: gon.autocomplete[assign_type],
        delay: 250,
        data: function (params) {
          return { q: params.term, r: related_id }
        }
      }
    })

    t.find('.field-input a.assign').click(function (event) {
      var v = select.val()
      var t = $(this)
      if (v !== null) {
        var href = t.attr('href', t.attr('data-href-template').replace('_v_', v))
        xhr(t)
        event.preventDefault()
        event.stopPropagation()
      }
    })

})


$('#user_has_agreed').change(function() {
  var state = $(this).is(":checked")
  $('#new_user input[type="submit"]').attr('disabled', !state)
})

$('[name="user[is_service_provider]"').change(function() {
  var state = $(this).val()
  $('#user_providers').toggle(state)
  console.log('here', state)
})

