{default attribute_base=ContentObjectAttribute}
{let class_content=$attribute.contentclass_attribute.content}

{if $error}
    <span class="error">{$error}</span>
{/if}

    <input type="hidden" id="eventpage_place" name="{$attribute_base}_data_object_relation_id_{$attribute.id}" value="{$attribute.data_int}"/>
    <input type="hidden" id="parent_cities" value="{$attribute.contentclass_attribute.content.default_selection_node}">
    <input name="eventLocationId" id="eventLocationId" type="text" class="cityAutoComplete" value="{$attribute.value.name}" />
    <input id="eventpage_place_hidden" type="hidden" name="{$attribute_base}_data_object_relation_id_{$attribute.id}" value="{$attribute.data_int}" />
    <div class="btnField">
        <button type="button" id="eventLocationEdit" class="btn btnAction" data-toggle="modal" data-target="#locationEditModal">Editer ce lieu</button>
        <button type="button" id="eventLocationCreate" class="btn btnAction" data-toggle="modal" data-target="#locationCreateModal">Définir un autre lieu</button>
    </div>


{/let}
{/default}