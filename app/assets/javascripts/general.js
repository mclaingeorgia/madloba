$(document).ready(function() {

    // This is a test to see if the user is using clients like AdBlock.
    // The use of AdBlock blocks a lot of markups on this website, unfortunately (eg. everything that has 'ad' in the class name)
    // When AdBlock is detected, we display a popup indicating that AdBlock should be deactivated for this Madloba website.
    if ($('#ad-block').length && !$('#ad-block').height()) {
        $('#wrap').append('<div class="blocking-notification alert alert-dismissible alert-warning" role="alert">' +
        '<button type="button" class="close" data-dismiss="alert">×</button>' +
        '<h5>'+gon.vars["adblock_warning"]+'</h5>' +
        '<p>'+gon.vars["adblock_browser"]+'<br />'+gon.vars["adblock_affecting"]+'</p>' +
        '<p>'+gon.vars["adblock_turnoff"]+'</p>' +
        '</div>');
    }
    // Initially created in 'application.html.erb' layout, this div is now removed.
    $("#ad-block").remove();

    // Setup pages - event for modal window on Map page.
    $('#gmail_modal_link').click(function(){
        $('#gmail_modal').modal('show');
    });

    // Navigation bar: press Enter to valid form.
    $("#searchFormId input").keypress(function(event) {
        if (event.which == 13) {
            event.preventDefault();
            getLocationsPropositions();
        }
    });

    // Navigation bar: event tied to "up" arrow, to go back to the top of the page.
    $('#navbar-up-link').click(function(){
        $('html, body').animate({ scrollTop: 0 }, 1000);
    });

    //Checks if we need to show the arrow up, in the navigation bar, on mobile devices.
    show_hide_up_arrow();
    
    $(window).on("scroll", function() {
        show_hide_up_arrow();
    });

    // Character counter (class 'textarea_count'), for text area, in 'General settings', and on new ad form.
    $( ".textarea_count" ).keyup(function() {
        var maxlength = $(this).attr('maxlength');
        var textlength = $(this).val().length;
        $(".remaining_characters").html(maxlength - textlength);
    });

    $( ".textarea_count" ).keydown(function() {
        var maxlength = $(this).attr('maxlength');
        var textlength = $(this).val().length;
        $(".remaining_characters").html(maxlength - textlength);
    });

    // Character counter (class 'textarea_count'), for text area, in 'General settings', and on new ad form.
    $( ".textarea_count_ka" ).keyup(function() {
        var maxlength = $(this).attr('maxlength');
        var textlength = $(this).val().length;
        $(".remaining_characters_ka").html(maxlength - textlength);
    });

    $( ".textarea_count_ka" ).keydown(function() {
        var maxlength = $(this).attr('maxlength');
        var textlength = $(this).val().length;
        $(".remaining_characters_ka").html(maxlength - textlength);
    });

    // Navigation - Search form: Ajax call to get locations proposition, based on user input in this form.
    $("#btn-form-search").bind("click", getLocationsPropositions);

    // Navigation bar on device: closes the navigation menu, when click.
    $('#about-nav-link').on('click', function(){
        if($('.navbar-toggle').css('display') !='none'){
            $(".navbar-toggle").click()
        }
    });

    // Home page: When clicking on about, scroll to the home page upper footer.
    $("#about-nav-link").click(function(){
        $('html, body').animate({
            scrollTop: $("#upper-footer-id").offset().top
        }, 2000);
    });

    // Popover when "Sign in / Register" link is clicked, in the navigation bar.
    $('#popover').popover({
        html : true,
        placement : 'bottom',
        title: function() {
            return $("#popover-head").html();
        },
        content: function() {
            return $("#popover-content").html();
        }
    });

    // Type-ahead for the item text field, in the main navigation bar.
    // searched_ad_items object is initialized in home layout template.
    if (typeof searched_ad_items != 'undefined') {
        $('#item').typeahead(null, {
            display: 'value',
            source: searched_ad_items,
        });
    }


    // Offcanvas related scripts
    $('[data-toggle=offcanvas]').click(function() {
        $('.row-offcanvas').toggleClass('active');
    });


    // ***********************
    // Create/Edit an ad pages
    // ***********************
    // Function that binds events to the item drop down list (in ads#new and ads#edit pages)
    // These events consists of making ajax call to check what items exists, in order to
    // create a type-ahead for the search bar of that drop drown box.
    function bindTypeaheadToItemSelect(object){
        object.selectpicker({
                liveSearch: true
            })
            .ajaxSelectPicker({
                ajax: {
                    url: '/getItems',
                    type: "GET",
                    dataType: 'json',
                    data: function () {
                        var params = {item: '{{{q}}}', type: 'search_items'};
                        return params;
                    }
                },
                locale: {
                    emptyTitle: gon.vars['search_for_items'],
                    statusInitialized: gon.vars['start_typing_item'],
                    statusNoResults: gon.vars['no_result_create_item']
                },
                preprocessData: function(data){
                    var items = [];
                    var len = data.length;
                    // Populating the item drop-down box
                    for(var i = 0; i < len; i++){
                        var item = data[i];
                        if (typeof item.ad_id != 'undefined'){
                            // Typeahead sends back a service title
                            items.push({'value': item.ad_id, 'text': item.value, 'disable': false});
                        }else{
                            // Typeahead sends back a item name
                            items.push({'value': item.id, 'text': item.value, 'disable': false});
                        }

                    }
                    return items;
                },
                preserveSelected: false
            });
    }

    bindTypeaheadToItemSelect($('#items .selectpicker-items'));

    $('.typeahead').on('typeahead:selected', function(evt, item) {
        // When clicking on selection, if it is an ad title, redirect to this ad.
        if (typeof item['ad_id'] != "undefined"){
            var ad_id = item['ad_id'];
            window.location.href = App.host_url+"/ads/"+ad_id;
        }
    })

    // "Create ad" form: create message when image needs to be uploaded.
    $('#new_ad').submit(function() {
        var image_path = $('#ad_image').val();
        if (image_path != null && image_path != ''){
            $('#upload-in-progress').html('<i>'+gon.vars['new_image_uploading']+'</i>');
        }
    });

    // Events to be triggered when item field added or removed, in the ad form.
    $("#items a.add_fields").
        data("association-insertion-position", 'before').
        data("association-insertion-node", 'this');

    $('#items').on('cocoon:after-insert',
        function() {
            $(".ad-item-fields a.add_fields").
                data("association-insertion-position", 'before').
                data("association-insertion-node", 'this');
                $('.selectpicker').selectpicker('refresh');
                bindTypeaheadToItemSelect($('#items .selectpicker-items'));

            $('.ad-item-fields').on('cocoon:after-insert',
                function() {
                    $(this).children(".item_from_list").remove();
                    $(this).children("a.add_fields").hide();
                });
        });

    $('.ad-item-fields').bind('cocoon:after-insert',
        function(e) {
            e.stopPropagation();
            $(this).find(".item_from_list").remove();
            $(this).find("a.add_fields").hide();
            $('.selectpicker').selectpicker('refresh');
        });


    // On the "New ad" form, open automatically the new location form, if the user is anonymous,
    // or never created any location as a signed in user.
    if (typeof current_page != "undefined" && current_page == "new_ad"
         && typeof can_choose_existing_locations != "undefined" && can_choose_existing_locations == false){
        setTimeout(function() {
            $("#new_location_form a.add_fields").trigger('click');
            $("#locations_from_list").hide();
            $("#location a.add_fields").hide();
            initLeafletMap(map_settings_array);
            init_location_form(districts_bounds, map);
        },20);
    }

    // Create an ad: adding the location form dynamically, via Cocoon
    $("#new_location_form a.add_fields").
        data("association-insertion-position", 'before').
        data("association-insertion-node", 'this');

    $('#new_location_form').bind('cocoon:after-insert',
        function() {
            $("#locations_from_list").hide();
            $("#new_location_form a.add_fields").hide();
            // Call to the JS functions that will initialize the new location form and the map.
            initLeafletMap(map_settings_array);
            init_location_form(districts_bounds, map);
        });
    $('#new_location_form').bind("cocoon:after-remove", function() {
            $("#locations_from_list").show();
            $("#new_location_form a.add_fields").show();
    });


    // Function call to initialize the location form (Location edit form, all Ad forms).
    if (typeof districts_bounds != "undefined") {
        init_location_form(districts_bounds, map);
    }


    // This event replaces the 'zoomToBoundsOnClick' MarkerCluster option. When clicking on a marker cluster,
    // 'zoomToBoundsOnClick' would zoom in too much, and push the markers to the edge of the screen.
    // This event underneath fixes this behaviour, the markers are not pushed to the boundaries of the map anymore.
    if(typeof markers != 'undefined'){
        markers.on('clusterclick', function (a) {
            var bounds = a.layer.getBounds().pad(0.5);
            map.fitBounds(bounds);
        });
    }

    // This is to correct a behavior that was happening in Chrome: when clicking on the zoom control panel, in the home page, the page would scroll down.
    // When clicking on zoom in/zoom out, this will force to be at the top of the page
    $('#home-map-canvas-wrapper .leaflet-control-zoom-out, #home-map-canvas-wrapper .leaflet-control-zoom-in').click(function(){
        $("html, body").animate({ scrollTop: 0 }, 0);
    });

    // Ad show page: event triggered when clicking on "Add to favorite" button
    $('.add_to_favorite_button').click(function(){
        add_favorite($(this));
    });

    // Ad show page: event triggered when clicking on "Remove from favorite" button
    $('.remove_favorite_button').click(function(){
        remove_favorite($(this));
    });

    // Admin favorite page: event triggered when clicking on "Remove" link
    $('.remove_favorite').click(function(){
        remove_favorite($(this));
    });


});

/**
 * Event triggered when clicking on "Add to favorite" button
 * @param obj
 */
function add_favorite(obj){
    var btn = obj;
    var posting = $.post("/user/favorite/add", { ad_id: btn.attr('id') }, function(data) {status = data.status})
    posting.done(function() {
        if (status == 'ok'){
            // Districts were updated via
            btn.removeClass('add_to_favorite_button btn-warning').addClass('btn-danger remove_favorite_button');
            btn.html("<i class='glyphicon glyphicon-star'></i>&nbsp;"+gon.vars['remove_from_favorites']);
            $('#ad_star').show();
            btn.unbind();
            btn.on('click', function() {remove_favorite(obj)});
        }else{
            // Something bad happened. We're not submitting the page.
            $('#error_remove').html('Sorry, server error occured. Try again later.');
        }
    });
}

/**
 * Event triggered when clicking on "Remove from favorite" button
 * @param obj
 */
function remove_favorite(obj){
    var btn = obj;
    var is_in_admin = (obj.attr('class') == 'remove_favorite');
    var posting = $.post("/user/favorite/remove", { ad_id: btn.attr('id') }, function(data) {status = data.status})
    posting.done(function() {
        if (status == 'ok'){
            if (is_in_admin){
                // admin favorite page : remove the whole line
                btn.parent().remove();
            }else{
                // ads show page: change the button
                btn.addClass('add_to_favorite_button btn-warning').removeClass('btn-danger remove_favorite_button');
                btn.html("<i class='glyphicon glyphicon-star'></i>&nbsp;"+gon.vars['add_to_favorites']);
                btn.unbind();
                $('#ad_star').hide();
                btn.on('click', function() {add_favorite(obj)});
            }
        }else{
            // Something bad happened. We're showing an error message.
            $('#error_remove').html('Sorry, server error occured. Try again later.');
        }
    });
}

/**
 * This critical function initializes the location form (Location edit form, Ad forms)
 * as well as all the events tied to its relevant elements.
 */
function init_location_form(districts_bounds, map){

    if ($('#map').length > 0){
        $(".location_type_exact").click(function(){
            removes_location_layers();
            show_exact_address_section(map);
        });

        if($('.location_type_exact').is(':checked')) {
            show_exact_address_section(map);
        }

        $(".location_type_postal_code").click(function(){
            removes_location_layers();
            show_postal_code_section(map);
        });

        if($('.location_type_postal_code').is(':checked')) {
            show_postal_code_section(map);
        }

        $(".location_type_district").click(function(){
            removes_location_layers();
            show_district_section(map);
        });

        if($('.location_type_district').is(':checked')) {
            show_district_section(map);
        }
    }

    // "Postal code" functionality: display a help message to inform about what the area will be named,
    // after the postal code is entered.
    $('.location_postal_code').focusout(function() {
        if($('.location_type_postal_code').is(':checked')) {
            var area_code_length, postal_code_length;
            var postal_code = $('.location_type_postal_code').val();
            var postal_code_value = $('.location_postal_code').val();

            if(typeof area_code_length == 'undefined' && typeof postal_code_length == 'undefined'){

                $.get("/user/getAreaSettings", {}, function (data){
                    if (data['code'] != null && data['area'] != null){
                        // Based on the retrieved settings, we display which area code will be used for this ad.
                        area_code_length = data['area'];
                        if (postal_code.length >= area_code_length){
                            $('#postal_code_notification').html("<i>"+ gon.vars['area_show_up'] +"'"+postal_code_value.substring(0, area_code_length)+"'</i>");
                        }
                    }
                });

            }
        }
    });

    // Help messages for fields on "Create ad" form
    $('.help-message').popover();

    // Initializing onclick event on "Locate me on the map" button, when looking for location on map, based on user input.
    find_geocodes();
}


/**
 * Event triggered when click on "Locate me on the map" button,
 * on the "Create ad" form, and on the Ad edit form.
 */
function find_geocodes(){
    $('#findGeocodeAddressMapBtnId').button().click(function () {

        var location_type = 'exact';

        if ($('.location_type_postal_code').is(':checked')){
            // We're on the location edit page, and 'Postal code' or 'District' location type is checked.
            location_type = 'area';
        }

        // Ajax call to get geocodes (latitude, longitude) of an exact location defined by address, postal code, city...
        // This call is triggered by "Find this city", "Find this general location" buttons,
        // on Map settings page, location edit page, map setup page...
        $.ajax({
            url: "/getCityGeocodes",
            global: false,
            type: "GET",
            data: { street_number: $(".location_streetnumber").val(),
                address: $(".location_streetname").val(),
                city: $(".location_city").val(),
                postal_code: $(".location_postal_code").val(),
                region: $('.location_region option:selected').val(),
                city: $(".location_city").val(),
                state: $(".location_state").val(),
                country: $(".location_country").val(),
                type: location_type
            },
            cache: false,
            beforeSend: function(xhr) {
                xhr.setRequestHeader("Accept", "application/json");
                xhr.setRequestHeader("Content-Type", "application/json");
                $('#findGeocodeLoaderId').html(gon.vars['searching_location']);
            },
            success: function(data) {
                if (data != null && data.status == 'ok'){
                    // Geocodes were found: the location is shown on the map.
                    var myNewLat = Math.round(data.lat*100000)/100000
                    var myNewLng = Math.round(data.lon*100000)/100000

                    $(".latitude_hidden").val(myNewLat);
                    $(".longitude_hidden").val(myNewLng);

                    // Update the center of map, to show the general area
                    map.setView(new L.LatLng(myNewLat, myNewLng), data.zoom_level);

                }else{
                    // The address' geocodes were not found - the user has to pinpoint the location manually on the map.
                    $('#myErrorModal').modal('show');
                }
                // Displaying notification about location found.
                $('#findGeocodeLoaderId').html('<i>'+data.address_found+'</i>');
            }
        });

    });


}


/**
 * On the location form, removes layers representing a previously clicked exact location, postal code area,
 * or selected district.
 */
function removes_location_layers(){
    if (newmarker != null){map.removeLayer(newmarker);}
    if (selected_area != null){map.removeLayer(selected_area);}
    if (postal_code_circle != null){map.removeLayer(postal_code_circle);}
}

/**
 * Function used in the location form - show appropriate section when entering an exact address
 */
function show_exact_address_section(map){
    $("#postal_code_section").removeClass('hide');
    $("#district_section").addClass('hide');
    $(".exact_location_section").removeClass('hide');
    location_marker_type = 'exact';
    map.on('click', onMapClickLocation);
    $('#map_notification_postal_code_only').addClass('hide');
    $('#map_notification_exact').removeClass('hide');
}


/**
 * Function used in the location form - show appropriate section when choosing a postal code-based area
 */
function show_postal_code_section(map){
    $(".exact_location_section").addClass('hide');
    $("#district_section").addClass('hide');
    $("#postal_code_section").removeClass('hide');
    location_marker_type = 'area';
    map.on('click', onMapClickLocation);
    $('#map_notification_postal_code_only').removeClass('hide');
    $('#map_notification_exact').addClass('hide');
}


/**
 * Function used in the location form - show appropriate section when choosing a district-based area
 */
function show_district_section(map){
    $(".exact_location_section").addClass('hide');
    $("#postal_code_section").addClass('hide');
    $("#district_section").removeClass('hide');
    $('#map_notification_postal_code_only').addClass('hide');
    $('#map_notification_exact').addClass('hide');
    location_marker_type = 'area';
    map.off('click', onMapClickLocation);
    $("#map_notification").addClass('hide');

    // Loading the district matching the default option in the district drop-down box.
    var id = $('.district_dropdown option:selected').val();
    var name = $('.district_dropdown option:selected').text();
    var bounds = districts_bounds[id];

    showSingleDistrict(name, bounds);

    // Location form: when choosing a district from the drop-down box, we need to display the area on the map underneath.
    $('#district_section').on('change', '.district_dropdown', function() {
        id = $('.district_dropdown option:selected').val();
        name = $('.district_dropdown option:selected').text();
        bounds = districts_bounds[id];

        showSingleDistrict(name, bounds);

    }).change();
}

/**
 * Before submitting the form with the location, we first do an Ajax call to see
 * if the Nominatim webservice comes back with several addresses.
 *
 * if it does, we show a modal window with this list of addresses. Once one is chosen,
 * the form is submitted.
 */
function getLocationsPropositions(){
    if ($('#location').val() != ''){
        // A location has been entered, let's use the Nominatim web service
        var locationInput = $('#location').val();
        $.ajax({
            url: "/getNominatimLocationResponses",
            global: false,
            type: "GET",
            data: { location: locationInput },
            cache: false,
            beforeSend: function(xhr) {
                xhr.setRequestHeader("Accept", "application/json");
                xhr.setRequestHeader("Content-Type", "application/json");
                $("#btn-form-search").html("Loading...");
            },
            success: function(data) {
                var modalHtmlText = "";
                if (data != null && data.length > 0){
                    if (typeof data[0]['error_key'] != 'undefined'){
                        // There's been an error while retrieving info from Nominatim,
                        // or there is no result found for this address.
                        $('#search_error_message').html('<strong>'+data[0]['error_key']+'</strong>');
                    }else{
                        // Address suggestions were found.
                        // We need to create the HTML body of the modal window, based on the location proposition from OpenStreetMap.
                        modalHtmlText = "<p>Choose one of the following available locations</p><ul></ul>";

                        // We also need to consider whether an item is being searched/given at the same time.
                        var item = $('#item').val();

                        for (var i = 0; i < data.length; i++) {
                            var proposed_location = data[i];
                            var url = "/search?lat="+proposed_location['lat']+"&lon="+proposed_location['lon']+"&loc="+proposed_location['display_name'];
                            if (item != ''){
                                url = url + "&item=" + item;
                            }
                            modalHtmlText = modalHtmlText + "<li><a href='"+encodeURI(url)+"'>"+proposed_location['display_name']+"</a></li>";
                        }

                        modalHtmlText = modalHtmlText + "</ul>";
                        $('#modal-body-id').html(modalHtmlText);
                        var options = {
                            "backdrop" : "static",
                            "show" : "true"
                        }
                        $('#basicModal').modal(options);
                    }

                }

                // Webservice response came back - button label goes back to "Search"
                $("#btn-form-search").html("Search");

            }
        });
    }else if (($('#item').val() != '') || ($('#user_action').val() != '')){
        // no location is being searched, but an item is. We need to submit the form with this information.
        $("#searchFormId").submit();
    }
}

/**
 * Checks if we need to show the arrow up, in the navigation bar, on mobile devices.
 */
function show_hide_up_arrow (){
    var scrollPos = $(window).scrollTop();
    if (scrollPos <= 0) {
        $("#navbar-up-link").hide();
    } else {
        $("#navbar-up-link").show();
    }
}