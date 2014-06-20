{default attribute_base=ContentObjectAttribute}
    {def
        $showhour = ""
        $showminutes = ""
    }
    {if ne( $attribute_base, 'ContentObjectAttribute' )}
        {def $id_base = concat( 'ezcoa-', $attribute_base, '-', $attribute.contentclassattribute_id, '_', $attribute.contentclass_attribute_identifier )}
    {else}
        {def $id_base = concat( 'ezcoa-', $attribute.contentclassattribute_id, '_', $attribute.contentclass_attribute_identifier )}
    {/if}
    <div class="oneLine duration">
        <label for="eventOtherDurationHours01" title="heure(s)">h</label>
        <select id="{$id_base}_hour" name="{$attribute_base}_time_hour_{$attribute.id}">
            {for 0 to 23 as $hour}
                {set $showhour = $hour}
                {if lt($hour,10)}
                    {set $showhour = concat( "0", $hour ) }
                {/if}
                <option value="{$hour}"{if and($attribute.content.is_valid, eq($attribute.content.hour, $hour))}selected="selected"{/if}>{$showhour}</option>
            {/for}
        </select>
        <label for="eventOtherDurationMins01" title="minute(s)">mn</label>
        <select id="{$id_base}_minute" name="{$attribute_base}_time_minute_{$attribute.id}">
            {for 0 to 59 as $minutes}
                {set $showminutes = $minutes}
                {if lt($minutes,10)}
                    {set $showminutes = concat( "0", $minutes ) }
                {/if}
                <option value="{$minutes}"{if and($attribute.content.is_valid, eq($attribute.content.minute, $minutes))}selected="selected"{/if}>{$showminutes}</option>
            {/for}
        </select>
        <input id="{$id_base}_second" type="hidden" name="{$attribute_base}_time_second_{$attribute.id}" value="0" />
    </div>
    {undef
        $showhour = ""
        $showminutes = ""
    }
{/default}