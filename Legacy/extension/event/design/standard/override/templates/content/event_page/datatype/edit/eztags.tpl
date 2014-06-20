{ezcss_require( array( 'tagssuggest.css', 'jqmodal.css', 'contentstructure-tree.css' ) )}
{ezscript_require( array( 'ezjsc::jquery', 'ezjsc::jqueryio', 'jquery-migrate-1.1.1.min.js', 'jqmodal.js', 'jquery.tagssuggest.js', 'tagssuggest-init.js' ) )}

{def $has_add_access = false()}
{def $root_tag = fetch( tags, tag, hash( tag_id, $attribute.contentclass_attribute.data_int1 ) )}

{def $user_limitations = user_limitations( 'tags', 'add' )}
{if $user_limitations['accessWord']|ne( 'no' )}
    {if is_unset( $user_limitations['simplifiedLimitations']['Tag'] )}
        {set $has_add_access = true()}
    {elseif $root_tag}
        {foreach $user_limitations['simplifiedLimitations']['Tag'] as $key => $value}
            {if $root_tag.path_string|contains( concat( '/', $value, '/' ) )}
                {set $has_add_access = true()}
                {break}
            {/if}
        {/foreach}
    {else}
        {set $has_add_access = true()}
        {set $root_tag = array()}
        {foreach $user_limitations['simplifiedLimitations']['Tag'] as $key => $value}
            {set $root_tag = $root_tag|append( fetch( tags, tag, hash( tag_id, $value ) ) )}
        {/foreach}
    {/if}
{/if}

{default attribute_base=ContentObjectAttribute}
    {def
        $parent_tags = fetch( tags, tree, hash( parent_tag_id, $attribute.contentclass_attribute.data_int1 ) )
        $tag_value = $attribute.value.tag_ids
    }
    <label>Catégorie<span class="reqNote"> *</span></label>
    {if $attribute.contentclass_attribute.description}
        <button type="button" class="btn btnInfo" data-toggle="tooltip" data-original-title="{$attribute.contentclass_attribute.description}">info</button>
    {/if}
    {if $error}
        <span class="error">{$error}</span>
    {/if}
    <select id="eventpage_tags" class="singleselect" data-parentid="{$attribute.contentclass_attribute.data_int1}">
        <option value="0">Sélectionner une catégorie</option>
    {foreach $parent_tags as $tag}
        {if eq($tag.parent_id, $attribute.contentclass_attribute.data_int1)}
            <option value="{$tag.id}" {if eq($tag.id,$tag_value.0)}selected="selected" {/if}>{$tag.keyword}</option>
        {/if}
    {/foreach}
    </select>
</div> {* fermeture du div ouvert dans le override *}
<div class="field">{* ce div est fermé dans le override *}
    <label>Sous-catégorie</label>
    <select id="eventpage_sub_tags" class="singleselect">
        <option value="0">Sélectionner une sous-catégorie</option>
        {if $tag_value|count()}
            {def
                $children_tags = fetch( tags, tree, hash( parent_tag_id, $tag_value.0 ) )
            }
            {if $children_tags|count()}
                {foreach $children_tags as $tagchild}
                    <option value="{$tagchild.id}" {if eq($tagchild.id,$tag_value.1)}selected="selected" {/if}>{$tagchild.keyword}</option>
                {/foreach}
            {/if}
        {/if}
    </select>
    <input id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="box ezcc-{$attribute.object.content_class.identifier} ezcca-{$attribute.object.content_class.identifier}_{$attribute.contentclass_attribute_identifier} tagnames" type="hidden" name="{$attribute_base}_eztags_data_text_{$attribute.id}" value="{$attribute.content.keyword_string|wash}"  />
    <input id="ezcoa2-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="box tagpids" type="hidden" name="{$attribute_base}_eztags_data_text2_{$attribute.id}" value="{$attribute.content.parent_string|wash}"  />
    <input id="ezcoa3-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}" class="box tagids" type="hidden" name="{$attribute_base}_eztags_data_text3_{$attribute.id}" value="{$attribute.content.id_string|wash}"  />
    <input type="hidden" class="eztags_subtree_limit" name="eztags_subtree_limit-{$attribute.id}" value="{$attribute.contentclass_attribute.data_int1}" />
    <input type="hidden" class="eztags_hide_root_tag" name="eztags_hide_root_tag-{$attribute.id}" value="{$attribute.contentclass_attribute.data_int3}" />
    <input type="hidden" class="eztags_max_tags" name="eztags_max_tags-{$attribute.id}" value="{if $attribute.contentclass_attribute.data_int4|gt( 0 )}{$attribute.contentclass_attribute.data_int4}{else}0{/if}" />
{/default}
