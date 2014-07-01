<?php
$Module = $Params['Module'];

$results = array();




$solrINI = eZINI::instance('solr.ini');
$siteINI = eZINI::instance();

$fullSolrURI = $solrINI->variable( 'SolrBase', 'SearchServerURI' );
// Autocomplete search should be done in current language and fallback languages
$validLanguages = $currentLanguage = $siteINI->variable( 'RegionalSettings', 'ContentObjectLocale' );

$params['fq'] = 'meta_language_code_ms:(' . $validLanguages .')';

$solrBase = new eZSolrBase( $fullSolrURI );



$currentCity = "";
$result = array();


if ( $Params['Type'] == "place" ) {

    $params = array(
        'q' => 'ezf_city_spell:*'.$Params['City'].'*',
        'group' => 'true',
        'group.field' => 'ezf_city_spell',
        'group.limit' => '50',
        'fl' => 'meta_id_si,attr_name_s,attr_zipcode_s',
        'rows' => '15'
    );
    $solrResult = $solrBase->rawSolrRequest( '/select', $params, 'php' );
    $groups = $solrResult['grouped']['ezf_city_spell']['groups'];

    foreach($groups as $group) {

        foreach($group['doclist']['docs'] as $eventPlace) {

            $city = ucfirst($group['groupValue']);

            $result[] = array(
                'id' => $eventPlace['meta_id_si'],
                'name' => $eventPlace['attr_name_s'],
                'city' => $city
            );
        }
    }
}
else {

    $params = array(
        'q' => 'ezf_city_spell:*'.$Params['City'].'*',
        'group' => 'true',
        'group.field' => 'ezf_city_spell',
        'group.limit' => '1',
        'fl' => 'attr_zipcode_s',
        'rows' => '15'
    );

    $solrResult = $solrBase->rawSolrRequest( '/select', $params, 'php' );
    $groups = $solrResult['grouped']['ezf_city_spell']['groups'];

    foreach($groups as $group) {

        foreach($group['doclist']['docs'] as $eventPlace) {

            $city = ucfirst($group['groupValue']);
            $result[] = array(
                'name' => $city,
                'zipcode' => $eventPlace['attr_zipcode_s']
            );
        }
    }

}

echo json_encode($result);
eZExecution::cleanExit();
