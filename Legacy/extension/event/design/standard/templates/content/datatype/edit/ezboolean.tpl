{default attribute_base=ContentObjectAttribute}
    {if $error}
        <span class="error">{$error}</span>
    {/if}
    <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" type="checkbox" name="{$attribute_base}_data_boolean_{$attribute.id}" {$attribute.data_int|choose( '', 'checked="checked"' )} value="" />
{/default}
