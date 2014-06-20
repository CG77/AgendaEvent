<?php
$Module = $Params['Module'];

$results = array();

$cities = eZContentObjectTreeNode::subTreeByNodeID(array(
    'ClassFilterType' => 'include',
    'ClassFilterArray' => array('event_place'),
    'AttributeFilter' => array( array( 'event_place/city', "like", '*'.$Params['City'].'*' )),
    'SortBy' => array('attribute', true ,'event_place/city')
),$Params['NodeID']);

$currentCity = "";
$result = null;
foreach($cities as $index=>$city){
    $dataMap = $city->ContentObject->dataMap();
    if ( $Params['Type'] == "place" ) {
        $result[$index]['id'] = $city->ContentObjectID;
        $result[$index]['name'] = $city->Name;
        $result[$index]['city'] = $dataMap['city']->DataText;
    } else {
        if ( $dataMap['city']->DataText != $currentCity ) {
            $result[$index]['city'] = $dataMap['city']->DataText;
            $result[$index]['zipcode'] = $dataMap['zipcode']->DataText;
        }
    }
    $currentCity = $dataMap['city']->DataText;
}

echo json_encode($result);
eZExecution::cleanExit();
