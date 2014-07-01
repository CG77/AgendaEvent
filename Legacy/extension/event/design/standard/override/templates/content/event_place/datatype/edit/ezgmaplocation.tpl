{if is_set( $attribute_base )|not}
  {def $attribute_base = 'ContentObjectAttribute'}
{/if}
{* Make sure to normalize floats from db  *}
{def $latitude  = $attribute.content.latitude|explode(',')|implode('.')
     $longitude = $attribute.content.longitude|explode(',')|implode('.')}

{run-once}

<script type="text/javascript">
{literal}
function eZGmapLocation_MapControl( attributeId, latLongAttributeBase )
{
    var mapid = 'ezgml-map-' + attributeId;
    var latid  = 'ezcoa-' + latLongAttributeBase + '_latitude';
    var longid = 'ezcoa-' + latLongAttributeBase + '_longitude';
    var geocoder = null;
    var addressid = 'ezgml-address-' + attributeId;
    var zoommax = 13;

    var showAddress = function()
    {
        var my_address   = document.getElementsByClassName( 'ezcca-event_place_address' )[0].value;
        var my_zipcode   = document.getElementsByClassName( 'ezcca-event_place_zipcode' )[0].value;
        var my_city      = document.getElementsByClassName( 'ezcca-event_place_city' )[0].value;
        if (my_address === '' || my_zipcode === '' || my_city === '' ){
            alert('Veuillez renseigner une adresse pour pouvoir la localiser, merci.');
        }else{
            var address = my_address +","+ my_zipcode +","+ my_city;
            if ( geocoder )
            {
                geocoder.geocode( {'address' : address}, function( results, status )
                {
                    if ( status == google.maps.GeocoderStatus.OK )
                    {
                        map.setOptions( { center: results[0].geometry.location, zoom : zoommax } );
                        marker.setPosition(  results[0].geometry.location );
                        updateLatLngFields( results[0].geometry.location );
                    }
                    else
                    {
                        alert( address + " ne peut pas être localisée" );
                    }
                });
            }
        }
    };
    
    var updateLatLngFields = function( point )
    {
        document.getElementById(latid).value = point.lat();
        document.getElementById(longid).value = point.lng();
    };

    var startPoint = null;
    var zoom = 0;
    var map = null;
    var marker = null;
        
    if ( document.getElementById( latid ).value && document.getElementById( latid ).value != 0 )
    {
        startPoint = new google.maps.LatLng( document.getElementById( latid ).value, document.getElementById( longid ).value );
        zoom = zoommax;
    }
    else
    {
        startPoint = new google.maps.LatLng( 48.542105, 2.655399999999986 );
        zoom = zoommax;
    }
    
    map = new google.maps.Map( document.getElementById( mapid ), { center: startPoint, zoom : zoom, mapTypeId: google.maps.MapTypeId.ROADMAP } );
    marker = new google.maps.Marker({ map: map, position: startPoint, draggable: true });
    google.maps.event.addListener( marker, 'dragend', function( event ){

    	updateLatLngFields( event.latLng );
		document.getElementById( addressid ).value = '';
    })
    
    geocoder = new google.maps.Geocoder();
    google.maps.event.addListener( map, 'click', function( event )
    {
			marker.setPosition( event.latLng );
			map.panTo( event.latLng );
			updateLatLngFields( event.latLng );
			document.getElementById( addressid ).value = '';
     });


    document.getElementById( 'ezgml-address-button-' + attributeId ).onclick = showAddress;
 
}
{/literal}
</script>
{/run-once}

<script type="text/javascript">;
    eZGmapLocation_MapControl( {$attribute.id}, "{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" )
    $('.ezcca-event_place_accessibility' ).multiselect('rebuild');
</script>

<input type="hidden" id="ezgml-address-{$attribute.id}" size="62" name="{$attribute_base}_data_gmaplocation_address_{$attribute.id}" value="{$attribute.content.address}"/>
<input class="button btn btnAction" type="button" id="ezgml-address-button-{$attribute.id}" value="Localiser l'adresse"/>
{if $error}<span class="error">La localisation de l'adresse est obligatoire</span>{/if}

<input id="ezgml_hidden_address_{$attribute.id}" type="hidden" name="ezgml_hidden_address_{$attribute.id}" value="{$attribute.content.address}" disabled="disabled" />
<input id="ezgml_hidden_latitude_{$attribute.id}" type="hidden" name="ezgml_hidden_latitude_{$attribute.id}" value="{$latitude}" disabled="disabled" />
<input id="ezgml_hidden_longitude_{$attribute.id}" type="hidden" name="ezgml_hidden_longitude_{$attribute.id}" value="{$longitude}" disabled="disabled" />
<div id="ezgml-map-{$attribute.id}" style="width: 562px; height: 280px; margin-top: 2px;"></div>
<input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_latitude" class="box ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="hidden" name="{$attribute_base}_data_gmaplocation_latitude_{$attribute.id}" value="{$latitude}" />
<input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_longitude" class="box ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="hidden" name="{$attribute_base}_data_gmaplocation_longitude_{$attribute.id}" value="{$longitude}" />
