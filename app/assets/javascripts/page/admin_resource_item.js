(function() {
  var resource_list = {
    el: undefined,
    init: function () {
      var t = resource_list
      t.el = $('.resource-list')

      t.bind()

      return t
    },
    // private
    bind: function () {
      var t = resource_list
      var wrapper = $('.resource-list-wrapper')
      var initial_length = +wrapper.attr('data-initial-length')
      var virtual_length = 0


      initTinymceLimited('textarea.tinymce-limited')

      $(document).on('click', '.choose-content-type input', function() {
        var $t = $(this)
        $t.closest('li').find('> .field').toggleClass('hidden')
        $t.closest('li').find('> .field > div.' + this.value).toggleClass('hidden')
        $t.closest('li').find('> div.' + (this.value == 'paragraph' ? 'visual' : 'paragraph')).remove()
        $t.closest('.choose-content-type').remove()
      })

      t.el.on('click', '> li .delete', function (event) {

        var tt = $(this)
        var index = tt.attr('data-index')
        var is_virtual = tt.attr('data-virtual') === 'true'
        var list = tt.closest('.resource-list-wrapper')
        if(!is_virtual) {
          list.append('<input type="hidden" value="1" name="resource_item[resource_contents_attributes][' + index + '][_destroy]">')
        }
        else {
          --virtual_length
        }
        wrapper.find('.orders [name="resource_item[resource_contents_attributes][' + index + '][order]"]').remove()
        list.find('.resource-list li[data-index="' + index + '"]').remove()
        tt.closest('.ui-sortable-handle').remove()

        event.preventDefault()
      })

      // t.el.on('change', '.resource-list-text input', function() {
      //   var input = $(this)
      //   input.closest('li').find('.toggle').html(input.val() + ' <span class="caret"></span>')
      // })

      $('#add_resource_list_item').click(function (event) {

        var ln = initial_length + virtual_length
        ++virtual_length
        var newItem
        gon.locales.forEach(function(locale) {
          newItem = $(gon.resource_item_template.replace(/_index_/g, ln).replace(/_locale_/g, locale))

          wrapper.find('[data-link="' + locale + '"] > ul').append(newItem)
          initTinymceLimited(newItem.find('textarea')[0])
        })
        wrapper.find('.orders').append('<input class="field-input hidden" type="hidden" value="' + (ln+1) + '" name="resource_item[resource_contents_attributes][' + ln + '][order]">')

        // console.log('click', $(t.el[0].children[0]).clone())
      })

      function reorderItems(before, after) {
        wrapper.find('[data-link="' + gon.locales[0] + '"] ul li').each(function (i, d) {
          var index = $(d).attr('data-index')
          wrapper.find('.orders [name="resource_item[resource_contents_attributes][' + index + '][order]"]').val(i+1)
        })
        // console.log(before, after)
      }

      var sortableIndexBefore
      var sortableIndexAfter
      $( "ul.sortable" ).sortable({
        axis: 'y',
        start:function(ev,ui){
          sortableIndexBefore = ui.item.index()

          $(ui.item).find('textarea').each(function () {
              tinymce.execCommand('mceRemoveEditor', false, $(this).attr('id'));
           });

          var link = ui.item.closest('li[data-link]').attr('data-link')
          var wrapper = ui.item.closest('.resource-list-wrapper')
          var opposite_link = link == 'ka' ? 'en' : 'ka'
          var opposite_list = wrapper.find('> li[data-link="' + opposite_link + '"] ul')[0]
          console.log($(opposite_list.children[sortableIndexBefore]).find('textarea'))
          $(opposite_list.children[sortableIndexBefore]).find('textarea').each(function () {
            tinymce.execCommand('mceRemoveEditor', false, $(this).attr('id'));
          });
          console.log(sortableIndexBefore)
        },
        stop:function(ev,ui){
          $(ui.item).find('textarea').each(function () {
            tinymce.execCommand('mceAddEditor', true, $(this).attr('id'));
          });
          sortableIndexAfter = ui.item.index()
          var link = ui.item.closest('li[data-link]').attr('data-link')
          var wrapper = ui.item.closest('.resource-list-wrapper')
          var opposite_link = link == 'ka' ? 'en' : 'ka'
          var opposite_list = wrapper.find('> li[data-link="' + opposite_link + '"] ul')[0]
          if(sortableIndexBefore !== sortableIndexAfter) {
            if(sortableIndexBefore < sortableIndexAfter){
              $(opposite_list.children[sortableIndexAfter]).after(opposite_list.children[sortableIndexBefore]);
            } else {
              $(opposite_list.children[sortableIndexAfter]).before(opposite_list.children[sortableIndexBefore]);
            }
            reorderItems(sortableIndexBefore, sortableIndexAfter)
          }

          $(opposite_list.children[sortableIndexAfter]).find('textarea').each(function () {
            tinymce.execCommand('mceAddEditor', true, $(this).attr('id'));
          })
        }
      });

    }
  }

  resource_list.init()
}())
