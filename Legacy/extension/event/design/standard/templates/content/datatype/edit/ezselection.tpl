{default attribute_base=ContentObjectAttribute}
{let selected_id_array=$attribute.content}
    <input type="hidden" name="{$attribute_base}_ezselect_selected_array_{$attribute.id}" value="" />
    {if $error}
        <span class="error">{$error}</span>
    {/if}
    {section var=Options loop=$attribute.class_content.options}
        <li>
            <input value="{$Options.item.id}" type="checkbox" name="{$attribute_base}_ezselect_selected_array_{$attribute.id}[]" id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" />
            <label>{$Options.item.name}</label>
        </li>
    {/section}
{/let}
{/default}
