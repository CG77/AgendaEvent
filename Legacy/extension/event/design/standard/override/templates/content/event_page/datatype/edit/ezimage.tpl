{default attribute_base='ContentObjectAttribute'}
{let attribute_content=$attribute.content}
    {if $error}
        <span class="error">{$error}</span>
    {/if}
    {* Current image. *}
    <div class="block">
        {if $attribute_content.original.is_valid}
            <p>{attribute_view_gui image_class=ezini( 'ImageSettings', 'DefaultEditAlias', 'content.ini' ) attribute=$attribute}</p>
            {if ne($attribute.object.content_class.identifier,'image')}<input class="button btn btnReset" type="submit" name="CustomActionButton[{$attribute.id}_delete_image]" value="{'Remove image'|i18n( 'design/standard/content/datatype' )}" />{/if}
        {/if}
    </div>

    {* New image file for upload. *}
    <div class="block">
        <input type="hidden" name="MAX_FILE_SIZE" value="{$attribute.contentclass_attribute.data_int1|mul( 1024, 1024 )}" />
        <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}_file" class="box ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier}" name="{$attribute_base}_data_imagename_{$attribute.id}" type="file" />
    </div>

{/let}
{/default}


