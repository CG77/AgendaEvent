{default attribute_base='ContentObjectAttribute'
         html_class='full'}
<textarea id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" name="{$attribute_base}_data_text_{$attribute.id}" cols="70" rows="{$attribute.contentclass_attribute.data_int1}">{$attribute.content|wash}</textarea>
{/default}
