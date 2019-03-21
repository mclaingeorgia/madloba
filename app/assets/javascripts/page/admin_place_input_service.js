//= require select2

(function() {
  var input_service = {
    els: {},
    is_dirty: false,
    restricted_geo_area_selector: 'input[name="place_service[is_restricited_geographic_area]"]',
    service_type_selector: 'input[name="place_service[service_type][]"]',
    age_restriction_selector: 'input[name="place_service[has_age_restriction]"]',
    can_be_used_by_selector: 'input[name="place_service[can_be_used_by]"]',
    init: function () {
      var t = input_service
      t.els['is_restricited_geographic_area'] = $(t.restricted_geo_area_selector)
      t.els['geographic_area_municipalities'] = $('.geographic_area_municipalities')
      t.els['service_type'] = $(t.service_type_selector)
      t.els['acts'] = $('.acts')
      t.els['age_restriction'] = $(t.age_restriction_selector)
      t.els['age_groups'] = $('.age_groups')
      t.els['can_be_used_by'] = $(t.can_be_used_by_selector)
      t.els['diagnoses'] = $('.diagnoses')
      t.els['service_links'] = $('ul.services li')

      t.bind()

      // intialize the view of the form in case there are existing values
      t.toggle_municipalities()
      t.toggle_acts()
      t.toggle_age_groups()
      t.toggle_diagnoses()

      // make the geographic_area_municipalities a select2 list
      $(document).ready(function() {
        $('.select2').select2({
          placeholder: gon.municipality_placeholder,
          width: '100%',
          multiple: true,
          allowClear: true
        });
      });

      return t
    },

    bind: function () {
      var t = input_service

      $(t.els['is_restricited_geographic_area']).on('click', function(evt){
        t.toggle_municipalities(true)
      })

      $(t.els['service_type']).on('click', function(evt){
        t.toggle_acts(true)
      })

      $(t.els['age_restriction']).on('click', function(evt){
        t.toggle_age_groups(true)
      })

      $(t.els['can_be_used_by']).on('click', function(evt){
        t.toggle_diagnoses(true)
      })

      // track when form changes are made
      $(":input").change(function(){
        t.is_dirty = true
      });

      $(t.els['service_links']).on('click', function(evt){
        t.load_next_service($(evt.target))
      })


    },
    reset_form_fields: function($container){
      var $fields = $container.find(':input')
      $fields.each(function(){
        $(this).val('')
            .prop('checked', false)
            .prop('selected', false)
      })
    },
    load_next_service($service_li){
      var t = input_service
      // if the active service was clicked on do nothing
      // else, check if form is dirty

      if (!($service_li).hasClass('active')){
        var leave_page = true
        if (t.is_dirty){
          // confirm user wants to leave
          leave_page = window.confirm(gon.confirm_leave_form)
        }
        if (leave_page){
          var url = $service_li.closest('ul').data('link')
          window.location.href = url.replace('%5Bitem_id%5D', $service_li.data('id'))
        }
      }
    },
    toggle_municipalities: function(reset_fields){
      var t = input_service

      // if value is true, than show municipalities
      var value = $(t.restricted_geo_area_selector + ':checked').val()
      if (value === 'true'){
        t.els['geographic_area_municipalities'].addClass('active')
      }else{
        t.els['geographic_area_municipalities'].removeClass('active')
        if (reset_fields){
          t.reset_form_fields(t.els['geographic_area_municipalities'])
        }
      }
    },
    toggle_acts: function(reset_fields){
      var t = input_service

      // if value is municipal or state, then show the acts section
      var values = $(t.service_type_selector + ':checked').map(function() {return this.value;}).get();
      if (values.includes('1') || values.includes('2')){
        t.els['acts'].addClass('active')
      }else{
        t.els['acts'].removeClass('active')
        if (reset_fields){
          t.reset_form_fields(t.els['acts'])
        }
      }
    },
    toggle_age_groups: function(reset_fields){
      var t = input_service

      // if value is true, than show age groups
      var value = $(t.age_restriction_selector + ':checked').val()
      if (value === 'true'){
        t.els['age_groups'].addClass('active')
      }else{
        t.els['age_groups'].removeClass('active')
        if (reset_fields){
          t.reset_form_fields(t.els['age_groups'])
        }
      }
    },
    toggle_diagnoses: function(reset_fields){
      var t = input_service

      // if value is diagnosis_without_status, than show diagnoses
      var value = $(t.can_be_used_by_selector + ':checked').val()
      if (value === 'diagnosis_without_status'){
        t.els['diagnoses'].addClass('active')
      }else{
        t.els['diagnoses'].removeClass('active')
        if (reset_fields){
          t.reset_form_fields(t.els['diagnoses'])
        }
      }
    }
  }

  input_service.init()
}())
