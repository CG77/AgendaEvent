<div class="nestedGroup tabGroup">
    <div class="field radioGroup">
        <div class="radioTabWrap">
            <ul>
                {attribute_edit_gui attribute=$content_attributes_grouped["is_free"] view_parameters=$view_parameters prices=true lib_data="eventPrice-tab-panel"}
            </ul>
            <!-- tabContent -->
            <div class="tabContent">
                <!-- tabPanel -->
                <div class="tabPanel fade in active" id="eventPrice-tab-panel-0">
                </div>
                <!-- /tabPanel -->
                <!-- tabPanel -->
                <div class="tabPanel fade" id="eventPrice-tab-panel-1">
                    <div class="field">
                        <label for="eventMinPrice">{$content_attributes_grouped["min_price"].contentclass_attribute.name|wash}</label>
                        <button type="button" class="btn btnInfo" data-toggle="tooltip" data-original-title="{$content_attributes_grouped["min_price"].contentclass_attribute.description}">info</button>
                        {attribute_edit_gui attribute=$content_attributes_grouped["min_price"] view_parameters=$view_parameters size=92}
                    </div>

                    <div class="field">
                        <label for="eventMaxPrice">{$content_attributes_grouped["max_price"].contentclass_attribute.name|wash}</label>
                        <button type="button" class="btn btnInfo" data-toggle="tooltip" data-original-title="{$content_attributes_grouped["max_price"].contentclass_attribute.description}">info</button>
                        {attribute_edit_gui attribute=$content_attributes_grouped["max_price"] view_parameters=$view_parameters size=92}
                    </div>
                </div>
                <!-- /tabPanel -->
            </div>
            <!-- /tabContent -->

            <div class="field">
                <label for="eventPricesDescription">{$content_attributes_grouped["prices_informations"].contentclass_attribute.name|wash}</label>
                <button type="button" class="btn btnInfo" data-toggle="tooltip" data-original-title="{$content_attributes_grouped["prices_informations"].contentclass_attribute.description}">info</button>
                {attribute_edit_gui attribute=$content_attributes_grouped["prices_informations"] view_parameters=$view_parameters}
            </div>
        </div>
    </div>
</div>