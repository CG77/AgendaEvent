{default attribute_base=ContentObjectAttribute}
{switch match=$attribute.content.enum_ismultiple}
{case match=1}
{section name=EnumList loop=$attribute.content.enum_list}
    <input type="hidden" name="{$attribute_base}_data_enumid_{$attribute.id}[]" value="{$EnumList:item.id}"/>
    <input type="hidden" name="{$attribute_base}_data_enumvalue_{$attribute.id}[]"
           value="{$EnumList:item.enumvalue|wash}"/>
    <input type="hidden" name="{$attribute_base}_data_enumelement_{$attribute.id}[]"
           value="{$EnumList:item.enumelement|wash}"/>
    <li>
        <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_{$EnumList:index}"
               class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}"
               type="checkbox" name="{$attribute_base}_select_data_enumelement_{$attribute.id}[]"
               value="{$EnumList:item.enumelement|wash}"
                {section name=EnumObjectList loop=$attribute.content.enumobject_list}
                    {switch match=$EnumList:item.enumelement}
                    {case match=$EnumList:EnumObjectList:item.enumelement}
                        checked="checked"
                    {/case}
                    {case}{/case}
                    {/switch}
                {/section}
                />
        <label>{$EnumList:item.enumelement|wash}</label>
    </li>
{/section}
{/case}
{case match=0}
{section name=EnumList loop=$attribute.content.enum_list}
    <input type="hidden" name="{$attribute_base}_data_enumid_{$attribute.id}[]" value="{$EnumList:item.id}"/>
    <input type="hidden" name="{$attribute_base}_data_enumvalue_{$attribute.id}[]"
           value="{$EnumList:item.enumvalue|wash}"/>
    <input type="hidden" name="{$attribute_base}_data_enumelement_{$attribute.id}[]"
           value="{$EnumList:item.enumelement|wash}"/>
    <li>
        <input
                {if is_set($prices) }
                data-target="#eventPrice-tab-panel-{$EnumList:index}"
                {/if}
                id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_{$EnumList:index}"
                class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}"
                type="radio" name="{$attribute_base}_select_data_enumelement_{$attribute.id}[]"
                value="{$EnumList:item.enumelement|wash}"
                {section name=EnumObjectList loop=$attribute.content.enumobject_list}
                    {switch match=$EnumList:item.enumelement}
                    {case match=$EnumList:EnumObjectList:item.enumelement}
                        checked="checked"
                    {/case}
                    {case}{/case}
                    {/switch}
                {/section}
                />
        <label>{$EnumList:item.enumelement}</label>
    </li>
{/section}
{/case}
{case}{/case}
{/switch}
{/default}
