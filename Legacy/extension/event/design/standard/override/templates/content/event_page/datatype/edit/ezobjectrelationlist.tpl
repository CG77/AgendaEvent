{* DO NOT EDIT THIS FILE! Use an override template instead. *}
{let class_content=$attribute.class_content
class_list=fetch( class, list, hash( class_filter, $class_content.class_constraint_list ) )
can_create=true()
new_object_initial_node_placement=false()
browse_object_start_node=false()}
    {default attribute_base=ContentObjectAttribute}
{if $class_content.selection_type|ne( 0 )} {* If current selection mode is not 'browse'. *}

    {let parent_node=cond( and( is_set( $class_content.default_placement.node_id ),
    $class_content.default_placement.node_id|eq( 0 )|not ),
    $class_content.default_placement.node_id, 1 )
    nodesList=cond( and( is_set( $class_content.class_constraint_list ), $class_content.class_constraint_list|count|ne( 0 ) ),
    fetch( content, tree,
    hash( parent_node_id, $parent_node,
    class_filter_type,'include',
    class_filter_array, $class_content.class_constraint_list,
    sort_by, array( 'name',true() ),
    main_node_only, true() ) ),
    fetch( content, list,
    hash( parent_node_id, $parent_node,
    sort_by, array( 'name', true() )
    ) )
    )
    }
    {switch match=$class_content.selection_type}

    {case match=1} {* Dropdown list *}
        <div class="buttonblock">
            <input type="hidden" name="single_select_{$attribute.id}" value="1" />
            {if ne( count( $nodesList ), 0)}
                <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]">
                    {if $attribute.contentclass_attribute.is_required|not}
                        <option value="no_relation" {if eq( $attribute.content.relation_list|count, 0 )} selected="selected"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}</option>
                    {/if}
                    {section var=node loop=$nodesList}
                        <option value="{$node.contentobject_id}"
                                {if ne( count( $attribute.content.relation_list ), 0)}
                                    {foreach $attribute.content.relation_list as $item}
                                        {if eq( $item.contentobject_id, $node.contentobject_id )}
                                            selected="selected"
                                            {break}
                                        {/if}
                                    {/foreach}
                                {/if}
                                >
                            {$node.name|wash}</option>
                    {/section}
                </select>
            {/if}
        </div>
    {/case}

    {case match=2} {* radio buttons list *}
        <input type="hidden" name="single_select_{$attribute.id}" value="1" />
    {if $attribute.contentclass_attribute.is_required|not}
        <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="no_relation"
    {if eq( $attribute.content.relation_list|count, 0 )} checked="checked"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}<br />{/if}
    {section var=node loop=$nodesList}
        <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$node.contentobject_id}"
                {if ne( count( $attribute.content.relation_list ), 0)}
                    {foreach $attribute.content.relation_list as $item}
                        {if eq( $item.contentobject_id, $node.contentobject_id )}
                            checked="checked"
                            {break}
                        {/if}
                    {/foreach}
                {/if}
                >
        {$node.name|wash} <br/>
    {/section}
    {/case}

    {case match=3} {* check boxes list *}
    {section var=node loop=$nodesList}
        <input type="checkbox" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$node.node_id}]" value="{$node.contentobject_id}"
                {if ne( count( $attribute.content.relation_list ), 0)}
                    {foreach $attribute.content.relation_list as $item}
                        {if eq( $item.contentobject_id, $node.contentobject_id )}
                            checked="checked"
                            {break}
                        {/if}
                    {/foreach}
                {/if}
                />
        {$node.name|wash} <br/>
    {/section}
    {/case}

    {case match=4} {* Multiple List *}
        <div class="buttonblock">
            {if ne( count( $nodesList ), 0)}
                <select name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" size="10" multiple>
                    {section var=node loop=$nodesList}
                        <option value="{$node.contentobject_id}"
                                {if ne( count( $attribute.content.relation_list ), 0)}
                                    {foreach $attribute.content.relation_list as $item}
                                        {if eq( $item.contentobject_id, $node.contentobject_id )}
                                            selected="selected"
                                            {break}
                                        {/if}
                                    {/foreach}
                                {/if}
                                >
                            {$node.name|wash}</option>
                    {/section}
                </select>
            {/if}
        </div>
    {/case}

    {case match=5} {* Template based, multi *}
        <div class="buttonblock">
            <div class="templatebasedeor">
                <ul>
                    {section var=node loop=$nodesList}
                        <li>
                            <input type="checkbox" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[{$node.node_id}]" value="{$node.contentobject_id}"
                                    {if ne( count( $attribute.content.relation_list ), 0)}
                                        {foreach $attribute.content.relation_list as $item}
                                            {if eq( $item.contentobject_id, $node.contentobject_id )}
                                                checked="checked"
                                                {break}
                                            {/if}
                                        {/foreach}
                                    {/if}
                                    >
                            {node_view_gui content_node=$node view=objectrelationlist}
                        </li>
                    {/section}
                </ul>
            </div>
        </div>
    {/case}

    {case match=6} {* Template based, single *}
        <div class="buttonblock">
            <div class="templatebasedeor">
                <ul>
                    {if $attribute.contentclass_attribute.is_required|not}
                        <li>
                            <input value="no_relation" type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" {if eq( $attribute.content.relation_list|count, 0 )} checked="checked"{/if}>{'No relation'|i18n( 'design/standard/content/datatype' )}<br />
                        </li>
                    {/if}
                    {section var=node loop=$nodesList}
                        <li>
                            <input type="radio" name="{$attribute_base}_data_object_relation_list_{$attribute.id}[]" value="{$node.contentobject_id}"
                                    {if ne( count( $attribute.content.relation_list ), 0)}
                                        {foreach $attribute.content.relation_list as $item}
                                            {if eq( $item.contentobject_id, $node.contentobject_id )}
                                                checked="checked"
                                                {break}
                                            {/if}
                                        {/foreach}
                                    {/if}
                                    >
                            {node_view_gui content_node=$node view=objectrelationlist}
                        </li>
                    {/section}
                </ul>
            </div>
        </div>
    {/case}
    {/switch}

    {if eq( count( $nodesList ), 0 )}
        {def $parentnode = fetch( 'content', 'node', hash( 'node_id', $parent_node ) )}
        {if is_set( $parentnode )}
            <p>{'Parent node'|i18n( 'design/standard/content/datatype' )}: {node_view_gui content_node=$parentnode view=objectrelationlist} </p>
        {/if}
        <p>{'Allowed classes'|i18n( 'design/standard/content/datatype' )}:</p>
        {if ne( count( $class_content.class_constraint_list ), 0 )}
            <ul>
                {foreach $class_content.class_constraint_list as $class}
                    <li>{$class}</li>
                {/foreach}
            </ul>
        {else}
            <ul>
                <li>{'Any'|i18n( 'design/standard/content/datatype' )}</li>
            </ul>
        {/if}
        <p>{'There are no objects of allowed classes'|i18n( 'design/standard/content/datatype' )}.</p>
    {/if}

        {* Create object *}
    {section show = and( is_set( $class_content.default_placement.node_id ), ne( 0, $class_content.default_placement.node_id ), ne( '', $class_content.object_class ) )}
        {def $defaultNode = fetch( content, node, hash( node_id, $class_content.default_placement.node_id ))}
        {if and( is_set( $defaultNode ), $defaultNode.can_create )}
            <div id='create_new_object_{$attribute.id}' style="display:none;">
                <p>{'Create new object with name'|i18n( 'design/standard/content/datatype' )}:</p>
                <input name="attribute_{$attribute.id}_new_object_name" id="attribute_{$attribute.id}_new_object_name"/>
            </div>
            <input class="button" type="button" value="Create New" name="CustomActionButton[{$attribute.id}_new_object]"
                   onclick="var divfield=document.getElementById('create_new_object_{$attribute.id}');divfield.style.display='block';
                           var editfield=document.getElementById('attribute_{$attribute.id}_new_object_name');editfield.focus();this.style.display='none';return false;" />
        {/if}
    {/section}

    {/let}
    {/default}
{else}{* Standard mode is browsing *}
    <div class="field checkerGroup">

        <ul>
            <li>
                <input name="eventAddAlbumItem01" id="eventAddAlbumItem01" value="ajout-horaire" type="checkbox" data-toggle="collapse" data-target="#eventAddAlbumItem01-collapse-panel-01" />
                <label for="eventAddAlbumItem01">Ajouter une photo</label>
                {*<!-- collapse -->*}
                {*<div id="dialog-confirm"></div>*}
                <input type="hidden" id="attribute_base" value="{$attribute_base}" />
                <input type="hidden" id="attribute_id" value="{$attribute.id}" />
                <div class="collapse collapsePanel" id="eventAddAlbumItem01-collapse-panel-01">
                    <ul class="noRwImg caAlbumMedialist">
                        {section name=Relation loop=$attribute.content.relation_list sequence=array( bglight, bgdark )}
                            {let object=fetch( content, object, hash( object_id, $:item.contentobject_id, object_version, $:item.contentobject_version ) )}
                            <li id="{$Relation:object.id}" class="elementImage">
                                <div class="caAlbumToolbar">
                                    <button type="button" class="btnPic btnPicDelete deleteAction" title="Supprimer"></button>
                                    <button type="button" class="btnPic btnPicEdit editAction" title="Editer"></button>
                                </div>
                                <img src={$Relation:object.data_map.image.content.reference.url|ezurl()} alt="" />
                                <strong>{$Relation:object.name|wash()}</strong>
                            </li>
                            {/let}
                        {/section}
                    </ul>
                    <div class="field">
                        <button type="button" id="eventImageCreate" class="btn btnAction" >Ajouter une image</button>
                    </div>
                </div>
                {*<!-- /collapse -->*}
            </li>
        </ul>
    </div>
    <div class="block" id="ezobjectrelationlist_browse_{$attribute.id}">
    {if is_set( $attribute.class_content.default_placement.node_id )}
        {set browse_object_start_node = $attribute.class_content.default_placement.node_id}
    {/if}
{/if}
{/let}
