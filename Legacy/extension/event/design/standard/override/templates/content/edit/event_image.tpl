{def
$authorizedAttributeEdit = array('name','image')
$attribute = ""
$error = ""
$finals_error = array()
$form = ""
$legend = ""
$legend_lib = ""
$button = ""
$button_lib = ""
}

{foreach $validation.attributes as $index=>$error}
    {def $tmp_array = hash( $error.identifier, $error.description)}
    {set $finals_error = $finals_error|merge( $tmp_array) }
{/foreach}
{if eq( $edit_version, 1 )}
    {set
    $form = "eventImageAddForm"
    $legend = "imageCreateModalLabel"
    $legend_lib = "Ajouter une image"
    $button = "imageCreateSubmit"
    $button_lib = "Ajouter une image"
    }
{else}
    {set
    $form = "eventImageEditForm"
    $legend = "imageEditModalLabel"
    $legend_lib = "Modifiez le lieu"
    $button = "imageEditSubmit"
    $button_lib = "Enregistrer l'image"
    }
{/if}
<div class="modalWrapper">
    <div class="box formUnit paneFormUnit">
        <form class="uForm" name="editform" id="{$form}" enctype="multipart/form-data" method="post" action={concat( '/album/edit/', $object.id, '/', $edit_version, '/', $edit_language|not|choose( concat( $edit_language, '/' ), '/' ), $is_translating_content|not|choose( concat( $from_language, '/' ), '' ) )|ezurl}>
            <fieldset class="fieldsetWith">
                <legend class="setTitle" id="{$legend}">{$legend_lib}&nbsp;:</legend>
                {foreach $authorizedAttributeEdit as $index=>$attributeIdentifier}
                    {set
                    $attribute = $content_attributes_grouped_data_map.content[$attributeIdentifier]
                    $error = ""
                    $class = ""
                    }
                    {if and(eq( $attribute.is_required, 1), $attribute.has_content|not ) }
                        {set $error = $finals_error[$attributeIdentifier]}
                    {/if}

                    {if eq($attributeIdentifier,'image')}
                        {set $error = $finals_error[$attributeIdentifier]}
                    {/if}

                    <div class="field{$class}">
                        <label>{$attribute.contentclass_attribute.name|wash}</label>
                        {attribute_edit_gui attribute=$attribute view_parameters=$view_parameters error=$error}
                    </div>
                {/foreach}
            </fieldset>

            <div class="formFooter">
                <div id="formSubmit02" class="btnField">
                    <button type="button" class="btn btnSubmit" id="{$button}" name="PublishButton" value="1">{$button_lib}</button>
                    <button type="reset" class="btn btnReset" data-dismiss="modal" aria-hidden="true">Annuler</button>
                </div>
            </div>
        </form>
    </div>
</div>

