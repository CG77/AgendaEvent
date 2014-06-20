{def
    $authorizedAttributeEdit = array('name','address', 'zipcode', 'city','google_map','accessibility', 'phone', 'email','website')
    $attribute = ""
    $error = ""
    $finals_error = array()
    $form = ""
    $legend = ""
    $legend_lib = ""
    $button = ""
    $button_lib = ""
    $identifier = ""
}

{foreach $validation.attributes as $index=>$error}
    {def $tmp_array = hash( $error.identifier, $error.description)}
    {set $finals_error = $finals_error|merge( $tmp_array) }
{/foreach}
{if eq( $edit_version, 1 )}
    {set
        $form = "eventLocationAddForm"
        $legend = "locationCreateModalLabel"
        $legend_lib = "Définissez un autre lieu"
        $button = "locationCreateSubmit"
        $button_lib = "Créer le lieu"
    }
{else}
    {set
        $form = "eventLocationEditForm"
        $legend = "locationEditModalLabel"
        $legend_lib = "Modifiez le lieu"
        $button = "locationEditSubmit"
        $button_lib = "Enregistrer le lieu"
    }
{/if}
<div class="modalWrapper">
    <div class="box formUnit paneFormUnit">
        <form class="uForm" name="editform" id="{$form}" enctype="multipart/form-data" method="post" action={concat( '/place/edit/', $object.id, '/', $edit_version, '/', $edit_language|not|choose( concat( $edit_language, '/' ), '/' ), $is_translating_content|not|choose( concat( $from_language, '/' ), '' ) )|ezurl}>
            <fieldset class="fieldsetWith">
                <legend class="setTitle" id="{$legend}">{$legend_lib}&nbsp;:</legend>
                {foreach $authorizedAttributeEdit as $index=>$attributeIdentifier}
                    {set
                        $attribute = $content_attributes_grouped_data_map.content[$attributeIdentifier]
                        $identifier = $attribute.contentclass_attribute.identifier
                        $error = ""
                        $class = ""
                    }
                    {if eq($attribute.data_type_string, "ezselection")}
                        {set $class = " checkerGroup" }
                    {/if}

                    {if or(eq($identifier,'address'),eq($identifier,'zipcode'),eq($identifier,'city'))}
                        {set $class = " mediapost" }
                    {/if}
                    <div class="field{$class}">
                        {if ne($attributeIdentifier, "google_map")}
                            <label>{$attribute.contentclass_attribute.name|wash}</label>
                        {/if}
                        {if and(eq( $attribute.is_required, 1), $attribute.has_content|not ) }
                            {set $error = $finals_error[$attributeIdentifier]}
                        {/if}
                        {if eq($attribute.data_type_string, "ezselection")}
                            <ul class="inputLine">
                        {/if}
                        {attribute_edit_gui attribute=$attribute view_parameters=$view_parameters error=$error}
                        {if eq($attribute.data_type_string, "ezselection")}
                            </ul>
                        {/if}
                    </div>
                {/foreach}
            </fieldset>

            <div class="formFooter">
                <div id="formSubmit02" class="btnField">
                    <button type="button" class="btn btnSubmit" id="{$button}" name="PublishButton">{$button_lib}</button>
                    <button type="reset" class="btn btnReset" data-dismiss="modal" aria-hidden="true">Annuler</button>
                </div>
            </div>
        </form>
    </div>
</div>

