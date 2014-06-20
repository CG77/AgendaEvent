$( function() {
    manage_event_page.init();
    manage_event_place.init();
    if ($('#map-event-page').length > 0 ) { manage_detail_event.init(); }
    if( $('#parent_cities').length){city_autocomplete.init();}
    manage_event_album.init();
    manage_event_schedule.init();
    if ($("#map-canvas" ).length > 0 ) { manage_home_agenda.init(); }
    manage_myevents.init();
    if($('.eventpage_date').length > 0 ){
        var is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1;
        if(is_chrome){
            $('.eventpage_date').attr('type','text');
        }
    }
});

var manage_event_page = function() {

    function _init() {
        // Manage category (fill input hidden and filter subcategory)

        $( "#eventpage_tags" ).on( "change", function() {
            var current_this = $( this );
            var parent_id = $( this ).val();
            var parent_name = $( "#eventpage_tags option:selected" ).text();
            $('.ajax-loader').show();
            $.ajax( {
                url: "/Eventpage/AjxSubEvents/" + $( this ).val(),
                dataType: "json",
                success: function( data ) {
                    $( "#eventpage_sub_tags" ).html( "" );
                    $( "#eventpage_sub_tags" ).append( '<option value="0" selected="selected">Sélectionner une sous-catégorie</option>' );
                    for( var i = 0; i < data.length; i++ ) {
                        $( "#eventpage_sub_tags" ).append( '<option value="' + data[i].id + '">' + data[i].keyword + '</option>' );
                    }
                    $( "#eventpage_sub_tags").multiselect('rebuild');
                    $( "input:radio" ).uniform();
                    current_this.parent().parent().next(".field" ).find( ".tagnames" ).val( parent_name );
                    current_this.parent().parent().next(".field" ).find( ".tagpids" ).val( current_this.attr( "data-parentid" ) );
                    current_this.parent().parent().next(".field" ).find( ".tagids" ).val( parent_id );
                    $('.ajax-loader').hide();
                },
                error: function() {
                    alert( "Une erreur s'est produite" );
                }
            } );

        } );

        // Manage subcategory (fill input hidden)
        $( "#eventpage_sub_tags" ).on( "change", function() {
            var current_name = $( this ).parent().parent().find( ".tagnames" ).val();
            var current_pid = $( this ).parent().parent().find( ".tagpids" ).val();
            var current_id = $( this ).parent().parent().find( ".tagids" ).val();

            var selected_id = $( this ).val();
            var selected_name = $( "#eventpage_sub_tags option:selected" ).text();
            $( this ).parent().parent().find( ".tagnames" ).val( current_name + "|#" + selected_name );
            $( this ).parent().parent().find( ".tagpids" ).val( current_pid + "|#" + current_id );
            $( this ).parent().parent().find( ".tagids" ).val( current_id + "|#" + selected_id );
        } );

        // Manage Event place (fill input hidden)
        $( "#eventpage_place" ).on( "change", function() {
            var selected_id = $( this ).val();
            $( this ).parent().parent().find( "#eventpage_place_hidden" ).val( selected_id );
        } );

    }

    return {init: _init}
}();

var manage_event_place = function() {

    function _init() {

        // Open popin with the content edit for creation
        $( "#eventLocationCreate" ).on( "click", function() {
            $( "#locationCreateModal" ).find( ".modalBody" ).html( "" );
            var ezformtoken = $( 'input[name="ezxform_token"]' ).val();
            var nodeid = $("#container_node_id" ).val();
            $('.ajax-loader').show();
            $.ajax( {
                type: "POST",
                data: { NewButton: "Ajouter un lieu", ClassIdentifier: "event_place", NodeID: nodeid, ezxform_token: ezformtoken },
                url: "/place/action/",
                success: function( data ) {
                    $( "#locationCreateModal" ).find( ".modalBody" ).html( data );
                    $( "#locationCreateModal" ).modal( "show" );
                    $(".box select, .uForm input:checkbox, input:radio, input:file").uniform();
                    $('.ajax-loader').hide();
                },
                error: function() {
                    console.log( "error" );
                }
            } );
        } );

        // Submit form in the popin
        $( "body" ).on( "click", "#locationCreateSubmit", function() {
            var form = $( "#eventLocationAddForm" );
            var form_serialize = form.serialize() + "&PublishButton=1";
            $('.ajax-loader').show();
            $.post( form.attr( 'action' ), form_serialize, function( data ) {
                try {
                    var obj = JSON.parse( data );
                    $( "#locationCreateModal" ).find( ".modalBody" ).html( '<div class="modalWrapper"><label class="success">'+obj.success.content+'</label></div>' );
                    //Récupération de lieu ajouté dans le champ auto complete
                    $('#eventpage_place').val(obj.success.id);
                    $('#eventpage_place_hidden').val(obj.success.id);
                    $('.cityAutoComplete').val(obj.success.name);
                    setTimeout(function(){
                        $( "#locationCreateModal" ).modal( "hide" );
                    },3000);
                } catch( e ) {
                    $( "#locationCreateModal" ).find( ".modalBody" ).html( data );
                }
                $('.ajax-loader').hide();
            } );
        } );

        // Open popin with the content edit for edition
        $( "#eventLocationEdit" ).on( "click", function() {
            $( "#locationEditModal" ).find( ".modalBody" ).html( "" );
            var ezformtoken = $( 'input[name="ezxform_token"]' ).val();
            var objectid = $("#eventpage_place" ).val();
            var nodeid = $("#container_node_id" ).val();
            if ( objectid != 0 ) {
                $('.ajax-loader').show();
                $.ajax( {
                    type: "POST",
                    data: { EditButton: "Modifier un lieu", TopLevelNode: nodeid, ContentNodeID: nodeid, ContentObjectID: objectid, ezxform_token: ezformtoken },
                    url: "/place/action/",
                    success: function( data ) {
                        $( "#locationEditModal" ).find( ".modalBody" ).html( data );
                        $( "#locationEditModal" ).modal( "show" );
                        $(".box select, .uForm input:checkbox, input:radio, input:file").uniform();
                        $('.ajax-loader').hide();
                    },
                    error: function() {
                        console.log( "error" );
                    }
                } );
            } else {
                alert("Veuillez sélectionner un lieu à éditer");
                return false;
            }
        } );

        // Submit form in the popin
        $( "body" ).on( "click", "#locationEditSubmit", function() {
            var form = $( "#eventLocationEditForm" );
            var form_serialize = form.serialize() + "&PublishButton=1";
            $('.ajax-loader').show();
            $.post( form.attr( 'action' ), form_serialize, function( data ) {
                try {
                    var obj = JSON.parse( data );
                    $( "#locationEditModal" ).find( ".modalBody" ).html( '<div class="modalWrapper"><label class="success">'+obj.success.content+'</label></div>' );
                    //Récupération de lieu ajouté dans le champ auto complete
                    $('#eventpage_place').val(obj.success.id);
                    $('#eventpage_place_hidden').val(obj.success.id);
                    $('.cityAutoComplete').val(obj.success.name);
                    setTimeout(function(){
                        $( "#locationEditModal" ).modal( "hide" );
                    },3000);
                } catch( e ) {
                    $( "#locationEditModal" ).find( ".modalBody" ).html( data );
                }
                $('.ajax-loader').hide();
            } );
        } );
    }

    return {init: _init}
}();

var manage_detail_event = function() {

    function _init() {
        google.maps.event.addDomListener( window, 'load', initMap );

        var scheduleObject = null;

        if ($('#event_schedule').length > 0 && $('#event_schedule').val().trim() !="") {
            scheduleObject = $.parseJSON( $('#event_schedule').val() );
            $(".time_schedule" ).html( "Horaires : " + scheduleObject.defaultTimes.join(", "))
        }

        $( ".eventDate" ).datepicker({
            showOtherMonths: true,
            selectOtherMonths: true,
            minDate: $("#event_begin_date" ).val(),
            maxDate: $("#event_end_date" ).val(),
            beforeShowDay: function( date ) {
                var css_class = "";
                var popup = ""
                var dateeventexn = $.datepicker.formatDate("dd/mm/yy", date);

                if ( $.inArray(date.getDay(), scheduleObject.excludedWeekdays ) >= 0 ) {
                    css_class = "excludedDay";
                    popup = "Date exclue";
                }

                if ( $.inArray(dateeventexn, scheduleObject.excludedDays ) >= 0 ) {
                    css_class = "excludedDay";
                    popup = "Date exclue";
                }

                if ( scheduleObject.dateExceptions[dateeventexn] != undefined && scheduleObject.dateExceptions[dateeventexn].length != 0) {
                    css_class = "event-exn";
                    popup = scheduleObject.dateExceptions[dateeventexn].join(", ");
                }

                return [true, css_class, popup];
            }
        } );
    }

    function initMap() {
        var myLatlng = new google.maps.LatLng( $("#event_place_latitude" ).val(), $("#event_place_longitude" ).val() );
        var mapOptions = {
            zoom: 10,
            center: myLatlng
        }
        var map = new google.maps.Map( document.getElementById('map-event-page'), mapOptions );

        var marker = new google.maps.Marker({
            position: myLatlng,
            map: map
        });
    }

    return {init:_init}
}();

var city_autocomplete = function() {
    function _init() {
        var nodeid = $( '#parent_cities' ).val();
        // Auto complete on event creation
        $( '#eventLocationId' ).on( 'keyup', function() {
            if ( $( '#parent_cities' ).length ) {
                var city_name = $( '#eventLocationId' ).val();
                $( ".cityAutoComplete" ).autocomplete( {
                    source: function( request, response ) {
                        $.ajax( {
                            dataType: "json",
                            url: "/place/cities/" + nodeid + "/" + city_name + "/place",
                            success: function( data ) {
                                var result = "";
                                if ( data ) {
                                    result = $.map( data, function( item ) {
                                        console.log(item);
                                        return {
                                            label: item.name,
                                            value: item.name,
                                            id: item.id,
                                            category: item.city
                                        };
                                    } );
                                } else {
                                    console.log("else");
                                    result = ["Pas de résultat"];
                                }
                                response( result );
                            },
                            error: function() {
                            }
                        } );
                    },
                    select: function( event, ui ) {
                        $( '#eventpage_place' ).val( ui.item.id );
                        $( '#eventpage_place_hidden' ).val( ui.item.id );
                    }
                } ).data( "uiAutocomplete" )._renderMenu = function( ul, items ) {
                    var self = this;
                    var category = null;
                    $.each( items, function( index, item ) {
                        if ( item.category != category ) {
                            category = item.category;
                            ul.append( "<li class='ui-autocomplete-group'>" + category + "</li>" );
                        }
                        self._renderItemData( ul, item );
                    } );
                };
            }
        } );

        // Auto complete on event search
        $( '#diaryWhere' ).on( 'keyup', function() {
            if ( $( '#parent_cities' ).length ) {
                var city_name = $( '#diaryWhere' ).val();
                $( ".cityAutoComplete" ).autocomplete( {
                    source: function( request, response ) {
                        $.ajax( {
                            dataType: "json",
                            url: "/place/cities/" + nodeid + "/" + city_name + "/city",
                            success: function( data ) {
                                response( $.map( data, function( item ) {
                                    return {
                                        label: item.city + " (" + item.zipcode + ")",
                                        value: item.city,
                                        id: item.city
                                    };
                                } ) );
                            },
                            error: function() {
                            }
                        } );
                    }
                } );
            }
        } )
    }

    return {init: _init}
}();

var manage_event_album = function(){
    function _init(){
        // Open popin with the content edit for creation
        $( "#eventImageCreate" ).on( "click", function() {
            $( "#ImageCreateModal" ).find( ".modalBody" ).html( "" );
            var ezformtoken = $( 'input[name="ezxform_token"]' ).val();
            var nodeid = $("#album_container_node_id" ).val();
            $('.ajax-loader').show();
            $.ajax( {
                type: "POST",
                data: { NewButton: "Ajouter une image", ClassIdentifier: "image", NodeID: nodeid, ezxform_token: ezformtoken },
                url: "/album/action/",
                success: function( data ) {
                    $( "#ImageCreateModal" ).find( ".modalBody" ).html( data );
                    $("input:file").uniform();
                    $( "#ImageCreateModal" ).modal( "show" );
                    $('.ajax-loader').hide();
                },
                error: function() {}
            } );
        } );
        //Submit form creation
        $("body").on("click","#imageCreateSubmit",function(){
            var form = $('#eventImageAddForm')
            var values = new FormData(form[0]);
            values.append('PublishButton',1);
            $(this).attr("disabled", "disabled");
            $('.ajax-loader').show();
            $.ajax({
                type : form.attr( 'method' ),
                url : form.attr( 'action' ),
                data : values,
                processData : false,
                contentType : false,
                success : function(data) {
                    try{
                        var result = JSON.parse( data );
                        $( "#ImageCreateModal" ).find( ".modalBody" ).html( '<div class="modalWrapper"><label class="success">'+result.success.content+'</label></div>' );
                        setTimeout(function(){
                            $( "#ImageCreateModal" ).modal( "hide" );
                        },2000);
                        var attributeID = $('#attribute_id').val();
                        var attributeBase = $('#attribute_base').val();
                        $('.caAlbumMedialist').append('<li id="'+result.success.id+'" class="elementImage"><div class="caAlbumToolbar"><button type="button" class="btnPic btnPicDelete deleteAction" title="Supprimer"></button><button type="button" class="btnPic btnPicEdit editAction" title="Editer"></button></div><img src="/'+result.success.image+'" alt="" /><strong>'+result.success.name+'</strong><input type="hidden" name="'+attributeBase+'_data_object_relation_list_'+attributeID+'[]" value="'+result.success.id+'" /></li>');
                    }

                    catch(e){
                        $( "#ImageCreateModal" ).find( ".modalBody" ).html( data );
                        $("input:file").uniform();
                    }
                    $('.ajax-loader').hide();
                }
            });
        })

        // Open popin with the content edit for edition
        $(document).on('click','.editAction',function(){
            $( "#ImageEditModal" ).find( ".modalBody" ).html( "" );
            var ezformtoken = $( 'input[name="ezxform_token"]' ).val();
            var objectid = $(this).parent().parent().attr('id');
            var nodeid = $("#album_container_node_id" ).val();
            $('.ajax-loader').show();
            $.ajax( {
                type: "POST",
                data: { EditButton: "Modifier une image", TopLevelNode: nodeid, ContentNodeID: nodeid, ContentObjectID: objectid, ezxform_token: ezformtoken },
                url: "/album/action/",
                success: function( data ) {
                    $( "#ImageEditModal" ).find( ".modalBody" ).html( data );
                    $("input:file").uniform();
                    $( "#ImageEditModal" ).modal( "show" );
                    $('.ajax-loader').hide();
                },
                error: function() {
                    console.log( "error" );
                }
            } );
        })

        //Submit edtion image
        $("body").on("click","#imageEditSubmit",function(){
            var form = $('#eventImageEditForm')
            var values = new FormData(form[0]);
            values.append('PublishButton',1);
            $(this).attr("disabled", "disabled");
            $('.ajax-loader').show();
            $.ajax({
                type : form.attr( 'method' ),
                url : form.attr( 'action' ),
                data : values,
                processData : false,
                contentType : false,
                success : function(data) {
                    try{
                        var result = JSON.parse( data );
                        $( "#ImageEditModal" ).find( ".modalBody" ).html( '<div class="modalWrapper"><label class="success">'+result.success.content+'</label></div>' );
                        setTimeout(function(){
                            $( "#ImageEditModal" ).modal( "hide" );
                        },2000);
                        var attributeID = $('#attribute_id').val();
                        var attributeBase = $('#attribute_base').val();
                        $("#"+result.success.id).find('img').attr('src','/'+result.success.image);
                        $("#"+result.success.id).find('strong').html(result.success.name);
                    }

                    catch(e){
                        $( "#ImageEditModal" ).find( ".modalBody" ).html( data );
                        $("input:file").uniform();
                    }
                    $('.ajax-loader').hide();
                }
            });

        })

    }
    //Delete image
    $(document).on('click','.deleteAction',function(){
        //$("#dialog-confirm").html("Etes vous sûr de supprimer cet image ?");
        var objectID = $(this).parent().parent().attr('id');
        var ezformtoken = $( 'input[name="ezxform_token"]' ).val();
        if(confirm("Etes vous sûr de supprimer cet image ?")){
            $('.ajax-loader').show();
            $.ajax({
                type : 'POST',
                url : '/album/delete/'+objectID,
                data: 'ezxform_token='+ezformtoken,
                success : function(data) {
                    $('#'+objectID).remove();
                    $('.ajax-loader').hide();
                }
            });
        }
    })
    return {init:_init}
}();

var manage_event_schedule = function () {

    function _init() {

        // Création de l'objet pour le stockage des informations horaires

        // Mode création
        //var scheduleObject = {
        // 'dateExceptions': {}, /* date avec horaire special */
        // 'defaultTimes': [], /* Horaires */
        // 'excludedDays': [], /* date exclus */
        // 'excludedWeekdays': [] /* Jours de de la semaine exclus */
        //};

        // Mode edit
        //var scheduleObject = {
        // 'dateExceptions': {'08/05/2014':["04:08","06:02","07:02"],'09/05/2014':["04:08","06:02","07:02"]}, /* date avec horaire special */
        // 'defaultTimes': ["06:05","10:05","14:05"], /* Horaires */
        // 'excludedDays': ['18/05/2014','16/05/2014'], /* date exclus */
        // 'excludedWeekdays': [0,1,2] /* Jours de de la semaine exclus */
        //};
        //$('#ezcoa-473_begin_date_date').val('05/05/2014');
        //$('#ezcoa-474_end_date_date').val('31/05/2014');

        // Mode edit
        if ($('.schedule-object-content').length > 0 && $('.schedule-object-content').val().trim() !="") {
            var scheduleObject = $.parseJSON( $('.schedule-object-content').val() );
            recapitulatif();
        }
        else {
            var scheduleObject = {
                'dateExceptions': {}, /* date avec horaire special */
                'defaultTimes': [], /* Horaires */
                'excludedDays': [], /* date exclus */
                'excludedWeekdays': [] /* Jours de de la semaine exclus */
            };
        }

        var first_date = $(".ezcca-event_page_begin_date" ).val();
        var last_date = $(".ezcca-event_page_end_date" ).val();

        // test date de debut et date de fin existe
        if ( first_date!="" && last_date != "" ) {
            $( "#pickerSchedule" ).removeClass('hidden-block');
            rangeDatepicker( first_date, last_date ); // // test validité date de debut et date de fin
            recapitulatif(); // Affiche le recapitulatif Dates et horaires
            horairesTime(); // Affiche les horaires de l'évenement
            joursExclus(); // active les jours exclus
        }

        /* Datepicker */
        // Datepicker pour la date de début et la date de fin
        $(".datepicker-agenda").datepicker({
            showOtherMonths: true,
            selectOtherMonths: true,
            onSelect: function( dateText, instance ) {
                // Lorsqu'on sélectionne une date dans les datepickers, on met à jour le datepicker récapitulatif
                var first_date = $(".ezcca-event_page_begin_date" ).val();
                var last_date = $(".ezcca-event_page_end_date" ).val();

                var first_date_elem = first_date.split("/");
                var last_date_elem = last_date.split("/");

                $(".begin_date_day" ).val( first_date_elem[0] );
                $(".begin_date_month" ).val( first_date_elem[1] );
                $(".begin_date_year" ).val( first_date_elem[2] );

                $(".end_date_day" ).val( last_date_elem[0] );
                $(".end_date_month" ).val( last_date_elem[1] );
                $(".end_date_year" ).val( last_date_elem[2] );

                if(first_date!="" && last_date!="") {
                    if ($.datepicker.parseDate('dd/mm/yy', last_date) > $.datepicker.parseDate('dd/mm/yy', first_date)) {
                        $( "#pickerSchedule" ).removeClass('hidden-block');
                    }
                    if ($.datepicker.parseDate('dd/mm/yy', first_date) > $.datepicker.parseDate('dd/mm/yy', last_date)) {
                        alert("La date de fin doit être ultérieure à la date de début");
                        last_date = first_date;
                        $(".ezcca-event_page_end_date").val(first_date);
                    }
                    if($( "#dateEvent").html()!="") {
                        $( "#dateEvent" ).datepicker('option',{minDate: first_date, maxDate: last_date});
                    }
                    else {
                        $( "#dateEvent" ).datepicker({minDate: first_date, maxDate: last_date});
                    }

                    $("#dateEvent").datepicker('refresh');

                    recapitulatif();
                }
            }
        });

        // Datepicker récapitulatif
        $('#dateEvent').datepicker();
        $("#dateEvent").datepicker("option",{
            onSelect: function( dateText, instance ) {
                var dateText = dateText;
                // Lorsqu'on sélectionne une date, on ouvre la popin
                $("#scheduleEventModalLabel" ).html( "Editer le " + dateText );
                $("#excludedDate" ).val( dateText );
                // Si la date était déjà exclu
                if ( $.inArray( dateText, scheduleObject.excludedDays ) >= 0 ) {
                    $("#excludedDate").prop("checked", true);
                    $("#excludedDate").uniform();
                    $("#exludedDate").parent().attr("class", "checked");
                    $(".field.singleSelectGroup.timetable.schedule" ).hide();
                    // Sinon on affiche la popin classique
                } else {
                    $("#excludedDate" ).prop("checked", false);
                    $("#excludedDate").uniform();
                    $("#excludedDate" ).parent().removeAttr("class");
                    $(".field.singleSelectGroup.timetable.schedule" ).show();

                    // on recupere les details horaire popin
                    var $add_date_exception_time = $('.addTimePopin');

                    $('.modalWrapper .schedule .duration').remove();

                    var add = function() {
                        addTimePop($add_date_exception_time, function() {
                            if (scheduleObject.dateExceptions[dateText] === undefined) scheduleObject.dateExceptions[dateText] = [];
                            return scheduleObject.dateExceptions[dateText];
                        });
                    }

                    if (scheduleObject.dateExceptions[dateText] === undefined || scheduleObject.dateExceptions[dateText].length == 0) add();
                    else {
                        for ( var i = 0, l = scheduleObject.dateExceptions[dateText].length; i < l; i++ ) {
                            addTimePop($add_date_exception_time, function() { return scheduleObject.dateExceptions[dateText]; }, scheduleObject.dateExceptions[dateText][i]);
                        }
                    }

                }
                // On affiche la popin
                $("#scheduleEventModal" ).modal("show");
            }
        });

        // Suppression d'une ligne horaire (hors popin)
        $("body").on("click", ".timetable-horaire .deleteTime", function(){

            var indexTimeHoraire = scheduleObject.defaultTimes.indexOf($('select.selectHour option:checked',$(this).parent()).val()+':'+$('select.selectMin option:checked',$(this).parent()).val() );
            if ( indexTimeHoraire > -1 ) {
                scheduleObject.defaultTimes.splice( indexTimeHoraire, 1 );
            }

            if ( $(".timetable-horaire .deleteTime" ).length > 1 ) {
                $(this).parent().remove();
            }
            else {
                $('#selectHour0 option[value="--"]',$(this).parent()).prop('selected', true);
                $('#selectMin0 option[value="--"]',$(this).parent()).prop('selected', true);
                $('#selectHour0',$(this).parent()).uniform();
                $('#selectMin0',$(this).parent()).uniform();
            }

            recapitulatif();
        });

        // Suppression d'une ligne horaire (popin)
        $("body").on("click", ".modalWrapper .deleteTime", function(){


            var indexTime = scheduleObject.dateExceptions[$('#excludedDate').val()].indexOf($('select.selectHour option:checked',$(this).parent()).val()+':'+$('select.selectMin option:checked',$(this).parent()).val() );
            if ( indexTime > -1 ) {
                scheduleObject.dateExceptions[$('#excludedDate').val()].splice( indexTime, 1 );
            }


            if ( $(".modalWrapper .deleteTime" ).length > 1 ) {
                $(this).parent().remove();
            }
            else {
                $('#popselectHour0 option[value="--"]',$(this).parent()).prop('selected', true);
                $('#popselectMin0 option[value="--"]',$(this).parent()).prop('selected', true);
                $('#popselectHour0',$(this).parent()).uniform();
                $('#popselectMin0',$(this).parent()).uniform();
            }

            recapitulatif();
        });

        // Traitement des checkbox "jours exclus"
        $(".selectDayExcluded" ).on("click", function(){
            excludedValues_tmp = new Array();
            $(".selectDayExcluded" ).each( function() {
                if ( $(this ).is( ":checked" ) ) {
                    excludedValues_tmp.push( parseInt($(this ).val()) );
                }
            });

            // On ajoute à l'objet javascript
            scheduleObject.excludedWeekdays = excludedValues_tmp;
            // On met à jour le datepicker récapitulatif
            excludedDayDatepicker();

            $( "#dateEvent").datepicker('refresh');

            recapitulatif();

        });

        // Traitement de l'exclusion d'une date spécifique via la popin
        $("body").on("click", "#excludedDate", function() {

            if ( $(this ).is( ":checked" ) ) {
                $(".field.singleSelectGroup.timetable.schedule").hide();
                scheduleObject.excludedDays.push( $(this ).val() );
                excludedDayDatepicker();
                dateText3 = $(this ).val();
                if (scheduleObject.dateExceptions[dateText3] === undefined ) {
                    //
                }
                else {
                    //supprimer les lignes horraires
                    $('.modalWrapper .deleteTime').trigger('click');

                    // supprimer les horaires de cette date tableau dateExceptions
                    delete scheduleObject.dateExceptions[dateText3];

                }
                $( "#dateEvent").datepicker('refresh');

            } else {
                var index = scheduleObject.excludedDays.indexOf( $(this ).val() );
                if ( index > -1 ) {
                    scheduleObject.excludedDays.splice( index, 1 );
                }
                excludedDayDatepicker();
                $(".field.singleSelectGroup.timetable.schedule" ).show();
                $("#dateEvent").datepicker('refresh');
            }

            recapitulatif();

        });

        // On ferme la popin au clic que enregistrer
        $("body").on("click", "#submitSchedule", function() {
            excludedDayDatepicker();
            $("#scheduleEventModal" ).modal("hide");
            recapitulatif();
        });

        // Ajout d'un nouvel horaire pour date special
        $("body").on( "click", ".addTimePopin", function() {
            var day_pop = $('#excludedDate').val();
            addTimePop( $(".addTimePopin"), function() { return scheduleObject.dateExceptions[day_pop]; } );
            recapitulatif();
        });

        // Ajout d'un nouvel horaire pour date
        $("body").on("click", ".addTime", function() {
            addTime( $(".addTime"), function() { return scheduleObject.defaultTimes; } );
            recapitulatif();
        });

        // Traitement à la sélection d'un horaire (heure et minute)
        $("body").on("change", ".timetable-horaire .scheduleSelect", function() {

            var id = $(this ).attr("data-id");
            // On stocke les heure et minutes dans l'objet javascript
            if ( $( ".timetable-horaire #selectHour"+id ).val() !== "--" && $( ".timetable-horaire #selectMin"+id ).val() !== "--" ) {
                scheduleObject.defaultTimes[id] = $( ".timetable-horaire #selectHour"+id ).val() + ":" + $( ".timetable-horaire #selectMin"+id ).val()
            }
            else if ( $( ".timetable-horaire #selectHour"+id ).val() == "--" && $( ".timetable-horaire #selectMin"+id ).val() == "--" ) {
                if ( scheduleObject.defaultTimes[id]!="" ) { scheduleObject.defaultTimes.splice(id, 1); }
            }

            recapitulatif();
        });

        // Traitement à la sélection d'un horaire (heure et minute) date Pop
        $("body").on("change", ".modalWrapper .timetable .scheduleSelect", function() {
            var id = $(this ).attr("data-id");
            var dateText2 = $('#excludedDate').val();

            // On stocke les heure et minutes dans l'objet javascript
            if ( $( ".modalWrapper .timetable #popselectHour"+id ).val() !== "--" && $( ".modalWrapper .timetable #popselectMin"+id ).val() !== "--" ) {
                valuetopush = $( ".modalWrapper .timetable #popselectHour"+id ).val() + ":" + $( ".modalWrapper .timetable #popselectMin"+id ).val();

                if (scheduleObject.dateExceptions[dateText2] === undefined || scheduleObject.dateExceptions[dateText2].length == 0) {
                    scheduleObject.dateExceptions[dateText2]= new Array();
                    scheduleObject.dateExceptions[dateText2][id]=valuetopush;
                }
                else {
                    if ( $.inArray(valuetopush, scheduleObject.dateExceptions[dateText2] ) >= 0 ) {
                        alert(valuetopush +' dejas existant');
                    }
                    else {
                        scheduleObject.dateExceptions[dateText2][id]=valuetopush;
                    }

                }

            }

            recapitulatif();
        });

        // Traitement change durée principal
        $("body").on("change", "#ezcoa-475_duration_hour,#ezcoa-475_duration_minute", function() {
            recapitulatif();
        });

        // fonction d'ajout d'un horaire (adaptation de l'existant)
        function addTime($add_button, timesProvider, initialValue) {
            var parent = $add_button.parent();
            var nbSelect = $(".timetable-horaire .oneLine.duration").length;
            var container = $("<div>").addClass("oneLine duration timetable");
            var hourLabel = $('<label>h</label>');
            var hourInput = $('<select id="selectHour'+nbSelect+'" class="scheduleSelect selectHour" data-id="'+nbSelect+'">');
            hourInput.append($("<option>").val("--").text("--"));
            for (var i = 0; i < 24; i++) {
                var hour = i < 10 ? '0' + i : i;
                hourInput.append($("<option>").val(hour).text(hour));
            }
            var minuteLabel = $("<label>mn</label>");
            var minuteInput = $('<select id="selectMin'+nbSelect+'" class="scheduleSelect selectMin" data-id="'+nbSelect+'">');
            minuteInput.append($("<option>").val("--").text("--"));
            for (i = 0; i < 60; i++) {
                var minute = i < 10 ? '0' + i : i;
                minuteInput.append($("<option>").val(minute).text(minute));
            }
            if (initialValue) {
                initialValue = initialValue.split(':');
                hourInput.val(initialValue[0]);
                minuteInput.val(initialValue[1]);
            }
            var deleteLink = $('<button type="button" class="btnPic btnPicDelete deleteTime" title="Supprimer cet horaire"><span>Supprimer</span></button>');
            container.append(hourLabel).append(hourInput).append(minuteLabel).append(minuteInput).append(deleteLink);
            parent.append(container);
            $(".box select").uniform();
        }

        // fonction d'ajout d'un horaire différent pour une date sepecial (popup) (adaptation de l'existant)
        function addTimePop($add_button, timesProvider, initialValue) {
            var parent = $add_button.parent();
            var nbSelect = $(".modalWrapper .oneLine.duration.timetable" ).length;
// if (!parent.hasClass("field")) parent = parent.parent();
            var container = $("<div>").addClass("oneLine duration timetable");
            var hourLabel = $('<label>h</label>');
            var hourInput = $('<select id="popselectHour'+nbSelect+'" class="scheduleSelect selectHour" data-id="'+nbSelect+'">');
            hourInput.append($("<option>").val("--").text("--"));
            for (var i = 0; i < 24; i++) {
                var hour = i < 10 ? '0' + i : i;
                hourInput.append($("<option>").val(hour).text(hour));
            }
            var minuteLabel = $("<label>mn</label>");
            var minuteInput = $('<select id="popselectMin'+nbSelect+'" class="scheduleSelect selectMin" data-id="'+nbSelect+'">');
            minuteInput.append($("<option>").val("--").text("--"));
            for (i = 0; i < 60; i++) {
                var minute = i < 10 ? '0' + i : i;
                minuteInput.append($("<option>").val(minute).text(minute));
            }
            if (initialValue) {
                initialValue = initialValue.split(':');
                hourInput.val(initialValue[0]);
                minuteInput.val(initialValue[1]);
            }
            var deleteLink = $('<button type="button" class="btnPic btnPicDelete deleteTime" title="Supprimer cet horaire"><span>Supprimer</span></button>');
            container.append(hourLabel).append(hourInput).append(minuteLabel).append(minuteInput).append(deleteLink);
            parent.append(container);
            $(".box select").uniform();
        }

        // Fonction d'exclusion d'une date sur le datepicker récapitulatif + Date à un horaire différent (event-exn)
        function excludedDayDatepicker() {
            $( "#dateEvent" ).datepicker("option",{
                beforeShowDay: function( date ) {
                    var css_class = "";
                    var excludedValues = scheduleObject.excludedDays;
                    var dateeventexn = $.datepicker.formatDate("dd/mm/yy", date);

                    if ( $.inArray(date.getDay(), scheduleObject.excludedWeekdays ) >= 0 ) { css_class = "excludedDay"; }

                    if ( $.inArray(dateeventexn, scheduleObject.excludedDays ) >= 0 ) { css_class = "excludedDay"; }

                    if ( scheduleObject.dateExceptions[dateeventexn] != undefined && scheduleObject.dateExceptions[dateeventexn].length != 0) { css_class = "event-exn"; }

                    return [true, css_class];
                }
            });
            $("#dateEvent").datepicker('refresh');
        }

        // Limite les dates du datepicker récapitulatif
        function rangeDatepicker( from, to ) {
            $( "#dateEvent" ).datepicker({minDate: from, maxDate: to});
            excludedDayDatepicker();
            setTimeout("$('#dateEvent').datepicker('refresh')", 100);
        }

        // Affiche le recapitulatif Dates et horaires
        function recapitulatif () {

            var weekday=new Array(7);
            weekday[0]="Dimanche";
            weekday[1]="Lundi";
            weekday[2]="Mardi";
            weekday[3]="Mercredi";
            weekday[4]="Jeudi";
            weekday[5]="Vendredi";
            weekday[6]="Samedi";

            var pasderepresentation = "",
                saufles = "",
                horaires = "",
                date_exceptions = "",
                date_debut_fin_event = "";



            for ( var i = 0, l = scheduleObject.excludedDays.length; i < l; i++ ) {
                pasderepresentation+="- Pas de représentation le "+scheduleObject.excludedDays[i]+"<br>";
            }


            // à quelle(s) heure(s) aura lieu l'évènement
            $(".timetable-horaire .duration" ).each( function(i) {
                if ( $('select.selectHour option:selected',$(this)).val()!="--" && $('select.selectMin option:selected',$(this)).val()!="--") {
                    virgule =true;
                    horaires+=$('select.selectHour option:selected',$(this)).val()+":"+$('select.selectMin option:selected',$(this)).val();
                    if(virgule && i<$(".timetable-horaire .duration").size()-1) horaires+=", "
                }
            });

            if(horaires!="") horaires = " à "+horaires;

            // Jours exclus
            if(scheduleObject.excludedWeekdays.length>=1) {
                var saufles = "- Sauf les ";
                for ( var i = 0, l = scheduleObject.excludedWeekdays.length; i < l; i++ ) {
                    saufles +=weekday[scheduleObject.excludedWeekdays[i]];
                    if(i<l-1) saufles +=", ";
                }
                saufles +="<br>";
            }

            // L’évènement a lieu à un horaire différent
            var nb_date_exp = Object.keys(scheduleObject.dateExceptions).length;
            if(nb_date_exp>0) {
                for(var k in scheduleObject.dateExceptions ) {
                    if(scheduleObject.dateExceptions[k]!="") {
                        date_exceptions+="- Le "+k+" à ";
                        date_exceptions+=scheduleObject.dateExceptions[k];
                        date_exceptions+="<br />";
                    }
                }
            }

            // Date de début et date de fin de l'évènement
            if($("input.ezcca-event_page_begin_date").val()!="" && $("input.ezcca-event_page_end_date").val() !="") {
                date_debut_fin_event = "du "+ $("input.ezcca-event_page_begin_date").val()+
                    " au "+$("input.ezcca-event_page_end_date").val();
            }


            $('#recap-datepicker-texte').html(
                "<strong>Récapitulatif : "+
                    date_debut_fin_event+
                    horaires+"</strong><br>"+
                    "- Durée : "+$('#ezcoa-475_duration_hour option:selected').val()+"h "+$('#uniform-ezcoa-475_duration_minute option:selected').val()+"mn<br>"+
                    saufles+
                    pasderepresentation+
                    date_exceptions

            );

            var scheduleObjectTmp = scheduleObject;
            scheduleObjectContent = JSON.stringify(scheduleObjectTmp);
            $('.schedule-object-content').val(scheduleObjectContent);

        }

        // Affiche les horaires de l'évenement
        function horairesTime () {

            // on recupere les details horaire hors popin
            var $add_horaires_time = $('.addTime');

            $('.timetable-horaire .duration').remove();

            var add2 = function() {
                addTime($add_horaires_time, function() {
                    if (scheduleObject.defaultTimes === undefined) { scheduleObject.defaultTimes = []; }
                    return scheduleObject.defaultTimes;
                });
            }

            if (scheduleObject.defaultTimes === undefined || scheduleObject.defaultTimes.length == 0) { add2(); }
            else {
                for ( var i = 0, l = scheduleObject.defaultTimes.length; i < l; i++ ) {
                    addTime($add_horaires_time, function() { return scheduleObject.defaultTimes; }, scheduleObject.defaultTimes[i]);
                }
            }

            if( scheduleObject.defaultTimes.length > 0 ){
                $('#eventOtherDuration-collapse-panel').addClass('in');
                $('#eventOtherDuration').prop( "checked", true );
                $(".box select, .uForm input:checkbox, input:radio, input:file").uniform();
            }
            else {
                $('#eventOtherDuration-collapse-panel').removeClass('in');
                $('#eventOtherDuration').prop("checked", false );
                $(".box select, .uForm input:checkbox, input:radio, input:file").uniform();
            }

        }

        // Affiche les jours exclus de la semaine
        function joursExclus() {
            if(scheduleObject.excludedWeekdays.length>0) {
                for ( var i = 0, l = scheduleObject.excludedWeekdays.length; i < l; i++ ) {
                    if($(".selectDayExcluded[value='"+scheduleObject.excludedWeekdays[i]+"']").is(":checked")) {}else{
                        $(".selectDayExcluded[value='"+scheduleObject.excludedWeekdays[i]+"']").click();}
                }
            }
        }

    }

    return {init:_init}
}();

var manage_home_agenda = function(){

    function _init() {
        // Geolocalisation for each results elements
        $( "body" ).on( "click", ".btnGeoMarker", function() {
            var latitude = $(this ).attr( "data-latitude" );
            var longitude = $(this ).attr( "data-longitude" );
            var color = $(this ).attr( "data-color" );
            $("#mapLocationLabel" ).html( $(this ).attr( "data-title" ) );

            $("#mapLocationModal" ).on('shown.bs.modal', function () {
                var myLatlng = new google.maps.LatLng( parseFloat(latitude), parseFloat(longitude) );

                var mapOptions = {
                    zoom: 12,
                    center: myLatlng
                };

                var map = new google.maps.Map( document.getElementById('mapCanvasPopin'), mapOptions );

                var marker = new google.maps.Marker({
                    position: myLatlng,
                    map: map,
                    icon: "/bundles/cgfront/images/pic-map-marker-" + color + ".png"
                });
            }).modal('show');
        });

        $( "#showMyPosition" ).on("click", function() {
            $('.ajax-loader').show();
            navigator.geolocation.getCurrentPosition( clickPosition, noPosition );
        });

        $("#diaryWhere" ).on( "keyup", function() {
            $("#latitude" ).val( "" );
            $("#longitude" ).val( "" );
        });

        google.maps.event.addDomListener( window, 'load', initGlobaleMap(null) );
    }

    function clickPosition( position ) {
        $('.ajax-loader').hide();
        var myLatlng = new google.maps.LatLng( position.coords.latitude, position.coords.longitude );

        var mapOptions = {
            zoom: 12,
            center: myLatlng
        };

        var map = new google.maps.Map( document.getElementById( 'map-canvas' ), mapOptions );

        var marker = new google.maps.Marker( {
            position: myLatlng,
            map: map
        } );

        $.ajax( {
            dataType: "json",
            url: "https://maps.googleapis.com/maps/api/geocode/json?latlng="+position.coords.latitude+","+position.coords.longitude+"&sensor=false",
            success: function( data ) {
                $.each( data.results, function( index, location ) {
                    if ( $.inArray( "locality", location.types ) != -1 ) {
                        var city = location.address_components[0].long_name;
                        $("#diaryWhere" ).val( city );
                    }
                } );
            },
            error: function() {
            }
        } );

        $("#latitude" ).val(position.coords.latitude );
        $("#longitude" ).val(position.coords.longitude );

        initGlobaleMap(map);
    }

    function noPosition(error) {
        $('.ajax-loader').hide();
        $( "#myPositionModal" ).find( ".modalBody" ).html( '<div class="modalWrapper"><label class="success">Impossible de vous localiser</label><input type="hidden" value="'+error.message+'" id="errorMessage"/></div>' );
        $( "#myPositionModal" ).modal( "show" );
        setTimeout(function(){
            $( "#myPositionModal" ).modal( "hide" );
        },3000);
    }

    function initGlobaleMap( map ) {
        var myLatlng = new google.maps.LatLng( 48.542105, 2.655399999999986 );

        var mapOptions = {
            zoom: 9,
            center: myLatlng
        };

        if ( map == null ) {
            map = new google.maps.Map( document.getElementById( 'map-canvas' ), mapOptions );
        }

        var myMarkers = $.parseJSON( $("#mapsInfo" ).val() );
        var markers = [];
        var marker = "";

        var infowindow = new google.maps.InfoWindow( { maxWidth: 320 } );
        $.each( myMarkers, function(index, infos) {

            var content = "";
            var marker = "";
            $.each(infos, function( j, info) {

                marker = new google.maps.Marker( {
                    position: new google.maps.LatLng( info.latitude, info.longitude ),
                    map: map,
                    icon: "/bundles/cgfront/images/pic-map-marker-" + info.color + ".png"
                });

                var date = "";
                if ( info.begin_date ) {
                    date = info.begin_date + " - "
                }
                if ( info.end_date ) {
                    date = date + info.end_date + "<br>"
                }

                var image = info.image;
                content += '<img src="'+ image +'" class="image_popin_map" />';
                content += date + info.tag + "<br><b>" + info.title + "</b><br>" + info.introduction;
                content += "<hr>";
            });

            makeInfoWindowEvent( map, infowindow, content, marker );

            markers.push(marker);

        });
    }

    function makeInfoWindowEvent( map, infowindow, content, marker ) {
        google.maps.event.addListener( marker, 'click', function() {
            infowindow.setContent( content );
            infowindow.open( map, marker );
        });
    }

    return {init:_init,initGlobaleMap:initGlobaleMap}

}();

var manage_myevents = function() {

    function _init() {

        $("body" ).on( "click", ".deleteEvent", function() {
            if ( confirm( "Etes vous sur de vouloir supprimer cet évènement ?" ) ) {
                var objectID = $(this ).attr("data-id");
                var ezformtoken = $("#ezxform_token" ).val();
                $('.ajax-loader').show();
                $.ajax({
                    type : 'POST',
                    url : '/event/delete/'+objectID,
                    data: 'ezxform_token='+ezformtoken,
                    success : function(data) {
                        $( "#eventDeleteModal" ).find( ".modalBody" ).html( '<div class="modalWrapper"><label class="success">Votre évènement a bien été supprimé</label></div>' );
                        $( "#eventDeleteModal" ).modal( "show" );
                        $('#li_'+objectID).remove();
                        setTimeout(function(){
                            $( "#eventDeleteModal" ).modal( "hide" );
                        },3000);
                    },
                    error: function() {
                        $( "#eventDeleteModal" ).find( ".modalBody" ).html( '<div class="modalWrapper"><label class="success">Une erreur est survenue lors de la suppression</label></div>' );
                    }
                });
                $('.ajax-loader').hide();
            }
        });
    }

    return {init:_init}
}();
