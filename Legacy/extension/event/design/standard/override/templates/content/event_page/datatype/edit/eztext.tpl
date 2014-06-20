{default attribute_base='ContentObjectAttribute'
         html_class='full'}

    <textarea
     id="ezcoa-{if ne( $attribute_base, 'ContentObjectAttribute' )}{$attribute_base}-{/if}{$attribute.contentclassattribute_id}_{$attribute.contentclass_attribute_identifier}"
     type="text"
     class="schedule-object-content hidden-block"
     name="{$attribute_base}_data_text_{$attribute.id}">{$attribute.content|wash}</textarea>
    {* exp of schedule-object-content content *}
    {*{literal}{"dateExceptions":{"09/05/2014":["03:05","09:13"]},"defaultTimes":["16:15","14:18"],"excludedDays":["10/05/2014","17/05/2014"],"excludedWeekdays":[1,2]}{/literal}*}

    <!-- nestedGroup -->
    <div class="nestedGroup collapseGroup">

        <div class="field checkerGroup">
            <ul>
                <li>
                    <input name="eventOtherDuration" id="eventOtherDuration" value="ajout-horaire" type="checkbox" data-toggle="collapse" data-target="#eventOtherDuration-collapse-panel" />
                    <label for="eventOtherDuration">Ajouter un horaire</label>
                    <!-- collapse -->
                    <div class="collapse collapsePanel" id="eventOtherDuration-collapse-panel">
                        <div class="field singleSelectGroup timetable timetable-horaire">
                            <div class="oneLine duration timetable">
                                <label>h</label><select id="selectHour0" class="scheduleSelect selectHour" data-id="0">
                                    <option value="--">--</option>
                                    {for 0 to 23 as $hour}
                                        {if lt($hour,10)}
                                            {set $hour = concat( "0", $hour ) }
                                        {/if}
                                        <option value="{$hour}">{$hour}</option>
                                    {/for}
                                </select><label>mn</label><select id="selectMin0" class="scheduleSelect selectMin" data-id="0">
                                    <option value="--">--</option>
                                    {for 0 to 59 as $minutes}
                                        {if lt($minutes,10)}
                                            {set $minutes = concat( "0", $minutes ) }
                                        {/if}
                                        <option value="{$minutes}">{$minutes}</option>
                                    {/for}
                                </select><button type="button" class="btnPic btnPicDelete deleteTime" title="Supprimer cet horaire"><span>Supprimer</span></button>
                            </div>
                            <button type="button" class="btnPic btnPicAdd addTime" title="Ajouter un autre horaire">
                                <span>Ajouter un autre horaire</span>
                            </button>
                        </div>
                    </div>
                    <!-- /collapse -->
                </li>
            </ul>
        </div>

    </div>
    <!-- /nestedGroup -->

    <div class="field checkerGroup">
        <p class="fieldTitle">Jours exclus</p>
        <ul class="inputLine">
            <li>
                <input name="eventExcludeDay01" id="eventExcludeDay01" value="0" type="checkbox" class="selectDayExcluded" />
                <label for="eventExcludeDay01">Lundi</label>
            </li>
            <li>
                <input name="eventExcludeDay02" id="eventExcludeDay02" value="1" type="checkbox" class="selectDayExcluded" />
                <label for="eventExcludeDay02">Mardi</label>
            </li>
            <li>
                <input name="eventExcludeDay03" id="eventExcludeDay03" value="2" type="checkbox" class="selectDayExcluded" />
                <label for="eventExcludeDay03">Mercredi</label>
            </li>
            <li>
                <input name="eventExcludeDay04" id="eventExcludeDay04" value="3" type="checkbox" class="selectDayExcluded" />
                <label for="eventExcludeDay04">Jeudi</label>
            </li>
            <li>
                <input name="eventExcludeDay05" id="eventExcludeDay05" value="4" type="checkbox" class="selectDayExcluded" />
                <label for="eventExcludeDay05">Vendredi</label>
            </li>
            <li>
                <input name="eventExcludeDay06" id="eventExcludeDay06" value="5" type="checkbox" class="selectDayExcluded" />
                <label for="eventExcludeDay06">Samedi</label>
            </li>
            <li>
                <input name="eventExcludeDay07" id="eventExcludeDay07" value="6" type="checkbox" class="selectDayExcluded" />
                <label for="eventExcludeDay07">Dimanche</label>
            </li>
        </ul>
    </div>

    <div id="pickerSchedule" class="hidden-block">
        <div id="dateEvent"></div>
        <div id="recap-datepicker">
            <div id="recap-datepicker-texte"></div>
        </div>
    </div>
    <div class="modal fade" id="scheduleEventModal" tabindex="-1" role="dialog" aria-labelledby="scheduleEventModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modalContent">
                <div class="modalHeader">
                    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                </div>
                <div class="modalBody">
                    <div class="modalWrapper">
                        <div class="box formUnit paneFormUnit">
                            <fieldset class="fieldsetWith">
                                <legend class="setTitle" id="scheduleEventModalLabel">Editer le </legend>
                                <div class="nestedGroup collapseGroup">
                                    <div class="field checkerGroup">
                                        <ul>
                                            <li>
                                                <input name="excludedDate" id="excludedDate" value="" type="checkbox" />
                                                <label for="excludedDate">Exclure cette date</label>

                                                <div class="field singleSelectGroup timetable schedule">
                                                    <!--div class="oneLine duration excludedtable timetable"><label for="popselectHour0" title="heure(s)">h</label><select name="popselectHour0" id="popselectHour0" class="scheduleSelect selectHour" data-id="0">
                                                            {for 0 to 23 as $hour}
                                                                {if lt($hour,10)}
                                                                    {set $hour = concat( "0", $hour ) }
                                                                {/if}
                                                                <option value="{$hour}">{$hour}</option>
                                                            {/for}
                                                        </select><label for="popselectMin0" title="minute(s)">mn</label><select name="popselectMin0" id="popselectMin0" class="scheduleSelect selectMin" data-id="0">
                                                            {for 0 to 59 as $minutes}
                                                                {if lt($minutes,10)}
                                                                    {set $minutes = concat( "0", $minutes ) }
                                                                {/if}
                                                                <option value="{$minutes}">{$minutes}</option>
                                                            {/for}
                                                        </select><button type="button" class="btnPic btnPicDelete deleteTimePopin" title="Supprimer cet horaire"><span>Supprimer</span></button>
                                                    </div-->
                                                    <button type="button" class="btnPic btnPicAdd addTimePopin" title="Ajouter un autre horaire">
                                                        <span>Ajouter un autre horaire</span>
                                                    </button>
                                                </div>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </fieldset>
                            <div class="formFooter">
                                <div id="formSubmit02" class="btnField">
                                    <button type="button" class="btn btnSubmit" id="submitSchedule">Enregistrer</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

{/default}
