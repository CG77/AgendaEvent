{def
    $authorizedAttributeEdit = array('title','tag', 'event_place','promoter','supported_by', 'main_image','copyright',
                                    'description', 'is_free', 'min_price','max_price', 'prices_informations', 'promoter_email', 'promoter_phone',
                                    'booking_email', 'booking_phone','album', 'introduction','begin_date','end_date','duration','timetable','promoter_website' )
    $attribute = ""
    $error = ""
    $attribute_categorys        = ezini( 'ClassAttributeSettings', 'CategoryList', 'content.ini' )
    $finals_error = array()
    $parentNodeId = $content_attributes_grouped_data_map.content.parent.contentclass_attribute.content.default_selection_node
    $event_place_container = $content_attributes_grouped_data_map.content.event_place_container.contentclass_attribute.content.default_selection_node
    $album_container = $content_attributes_grouped_data_map.content.parent.contentclass_attribute.content.default_selection_node
    $ParentNode = fetch( "content", "node", hash( 'node_id', $parentNodeId ) )
}

{foreach $validation.attributes as $index=>$error}
    {def $tmp_array = hash( $error.identifier, $error.description)}
    {set $finals_error = $finals_error|merge( $tmp_array) }
{/foreach}
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
<section class="lowerSection">
    <div id="utils">
        <div class="wrapper">
            {include uri="design:common/breadcrumb.tpl" ParentNode=$ParentNode}
            {include uri="design:common/social_tools.tpl"}
        </div>
    </div>

    <div class="wrapper">
        <section class="colMedium">
            {include uri="design:common/share_tools.tpl"}
            <article class="content">
                <header>
                    <h1>{$ParentNode.name}</h1>
                    <p class="heading">
                        Ajoutez un évènement.
                    </p>
                </header>
            </article>
            <div class="box formUnit paneFormUnit">
                <form class="uForm" name="editform" id="editform" enctype="multipart/form-data" method="post" action={concat( '/event/edit/', $object.id, '/', $edit_version, '/', $edit_language|not|choose( concat( $edit_language, '/' ), '/' ), $is_translating_content|not|choose( concat( $from_language, '/' ), '' ) )|ezurl}>
                    <input type="hidden" value="{$event_place_container}" id="container_node_id" />

                    <input type="hidden" value="{$album_container}" id="album_container_node_id" />
                    {foreach $content_attributes_grouped_data_map as $attribute_group => $content_attributes_grouped}
                        {if ne($attribute_group, "content")}
                        <fieldset>
                            <legend class="setTitle">{$attribute_categorys[$attribute_group]}</legend>
                            {if ne($attribute_group, "event_page_tarifs")}
                                {def $i = 0}
                                {foreach $content_attributes_grouped as $attributeIdentifier=>$attribute}
                                    {if $authorizedAttributeEdit|contains( $attributeIdentifier )}
                                        {set
                                            $error = ""
                                            $class = ""
                                        }
                                        {if eq($attribute.data_type_string, "ezselection")}
                                            {set $class = " radioGroup" }
                                            {if $attribute.class_content.enum_ismultiple}
                                                {set $class = " checkerGroup" }
                                            {/if}
                                        {/if}
                                        {if eq($attribute.data_type_string, "ezboolean")}
                                            {set $class = " checkerGroup" }
                                        {/if}
                                        <div class="field{$class}">
                                            {if and(ne($attributeIdentifier, "tag"),ne($attributeIdentifier, "supported_by")) }
                                                <label>{$attribute.contentclass_attribute.name|wash}{if eq( $attribute.is_required, 1) }<span class="reqNote"> *</span>{/if}</label>
                                            {/if}

                                            {if and(ne($attributeIdentifier, "tag"), ne($attributeIdentifier, "supported_by"), $attribute.contentclass_attribute.description ) }
                                                <button type="button" class="btn btnInfo" data-toggle="tooltip" data-original-title="{$attribute.contentclass_attribute.description}">info</button>
                                            {/if}

                                            {if and(eq( $attribute.is_required, 1), $attribute.has_content|not ) }
                                                {set $error = $finals_error[$attributeIdentifier]}
                                            {/if}
                                            {if eq($attribute.data_type_string, "ezselection")}
                                            {if $error}
                                                <span class="error">{$error}</span>
                                            {/if}
                                                <ul>
                                            {/if}
                                            {if eq($attributeIdentifier, "supported_by") }
                                                <p>
                                                    {attribute_edit_gui attribute=$attribute view_parameters=$view_parameters error=$error}
                                                    <label>{$attribute.contentclass_attribute.name|wash}</label>
                                                    {if $attribute.contentclass_attribute.description }
                                                    <button type="button" class="btn btnInfo" data-toggle="tooltip" data-original-title="{$attribute.contentclass_attribute.description}">info</button>
                                                    {/if}
                                                </p>
                                            {else}
                                                {attribute_edit_gui attribute=$attribute view_parameters=$view_parameters error=$error}
                                            {/if}
                                            {if eq($attribute.data_type_string, "ezselection")}
                                                </ul>
                                            {/if}
                                        </div>
                                        {set $i = inc($i) }
                                    {/if}
                                {/foreach}
                            {else}
                                {include uri="design:event/event_page_tarif.tpl" content_attributes_grouped=$content_attributes_grouped validation=$validation }
                            {/if}
                        </fieldset>
                        {/if}
                    {/foreach}
                    <div class="formFooter">
                        <p class="reqNote"><strong>*</strong> Champs obligatoires</p>
                        <div id="formSubmit" class="btnField">
                            <input class="defaultbutton btn btnSubmit" type="submit" name="PublishButton" value="Enregistrer" title="Enregisrer l'évènement" />
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal fade" id="locationCreateModal" tabindex="-1" role="dialog" aria-labelledby="locationCreateModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modalContent">
                        <div class="modalHeader">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        </div>
                        <div class="modalBody">
                            <span class="success"></span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="locationEditModal" tabindex="-1" role="dialog" aria-labelledby="locationEditModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modalContent">
                        <div class="modalHeader">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        </div>
                        <div class="modalBody">
                            <span class="success"></span>
                        </div>
                    </div>
                </div>
            </div>

            <div class="modal fade" id="ImageCreateModal" tabindex="-1" role="dialog" aria-labelledby="ImageCreateModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modalContent">
                        <div class="modalHeader">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        </div>
                        <div class="modalBody">
                            <span class="success"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal fade" id="ImageEditModal" tabindex="-1" role="dialog" aria-labelledby="ImageEditModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modalContent">
                        <div class="modalHeader">
                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        </div>
                        <div class="modalBody">
                            <span class="success"></span>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        {include uri="design:event/event_page_right_column.tpl" ParentNode=$ParentNode}
    </div>
</section>
<div class="ajax-loader"></div>
