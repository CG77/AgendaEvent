{default attribute_base=ContentObjectAttribute}
    {def $current_value = "" }
    {if ne( $attribute_base, 'ContentObjectAttribute' )}
        {def $id_base = concat( 'ezcoa-', $attribute_base, '-', $attribute.contentclassattribute_id, '_', $attribute.contentclass_attribute_identifier )}
    {else}
        {def $id_base = concat( 'ezcoa-', $attribute.contentclassattribute_id, '_', $attribute.contentclass_attribute_identifier )}
    {/if}

    {if $attribute.content.is_valid}
        {set $current_value = concat($attribute.content.day,"/",$attribute.content.month,"/",$attribute.content.year) }
    {/if}

    <input class="eventpage_date ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier} datepicker-agenda"
           name="{$attribute_base}_date_year_{$attribute.id}" id="{$id_base}_date" required="required" type="date"
           value="{if $attribute.content.is_valid}{$current_value}{/if}"/>

    <input id="{$id_base}_year" class="{$attribute.contentclass_attribute_identifier}_year" type="hidden" name="{$attribute_base}_date_year_{$attribute.id}"
           value="{if $attribute.content.is_valid}{$attribute.content.year}{/if}"/>

    <input id="{$id_base}_month" class="{$attribute.contentclass_attribute_identifier}_month" type="hidden" name="{$attribute_base}_date_month_{$attribute.id}"
        value="{if $attribute.content.is_valid}{$attribute.content.month}{/if}"/>

    <input id="{$id_base}_day" class="{$attribute.contentclass_attribute_identifier}_day" type="hidden" name="{$attribute_base}_date_day_{$attribute.id}"
        value="{if $attribute.content.is_valid}{$attribute.content.day}{/if}"/>

    {undef $current_value}
{/default}