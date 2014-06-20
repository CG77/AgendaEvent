
{default attribute_base=ContentObjectAttribute}
{let selected_id_array=$attribute.content
$index = 0}

{* Always set the .._selected_array_.. variable, this circumvents the problem when nothing is selected. *} 
<input type="hidden" name="{$attribute_base}_ezselect_selected_array_{$attribute.id}" value="" />
{section var=Options loop=$attribute.class_content.options}
    <li>
        <input
                {if $attribute.contentclass_attribute_identifier|eq( is_free )}
                    data-target="#eventPrice-tab-panel-{$index}"
                    {set $index = inc($index)}
                {/if}
                name="{$attribute_base}_ezselect_selected_array_{$attribute.id}[]" type="radio"
                value="{$Options.item.id}"
                {if $selected_id_array|contains( $Options.item.id )}
                    checked="checked"
                {/if} />
        <label>{$Options.item.name|wash( xhtml )}</label>
    </li>
{/section}
{/let}
{/default}
