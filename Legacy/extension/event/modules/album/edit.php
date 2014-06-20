<?php

$tpl = eZTemplate::factory();
$Module = $Params['Module'];

$moduleContent = eZModule::findModule( "content" );

$iObjectId = $Params['ObjectID'];
$moduleResult = $moduleContent->run( "edit", array( $Params['ObjectID'], $Params['EditVersion'], $Params['EditLanguage'] ), false, false );
$aResult = array();
$Result = array();

$aUri         = explode( "/", $moduleContent->redirectURI() );
while( $moduleContent->exitStatus() == eZModule::STATUS_REDIRECT && $aUri[1] == "content" && $aUri[2] == "edit" ) {
    $aUri         = explode( "/", $moduleContent->redirectURI() );
    $moduleResult = $moduleContent->run( "edit", array( $aUri[3],
                                                        $aUri[4],
                                                        $aUri[5] ), false, false );
    $bRedirect    = true;
}

if ( $bRedirect ) {
    $redirectUri = $moduleContent->redirectURI();
    $redirectUri = str_replace( "content", "album", $redirectUri );
    $Module->redirectTo( $redirectUri );
}
//echo"<pre>";print_r($moduleResult["content"]);echo"</pre>";die;
if( isset( $moduleResult['content'] ) ) {
    $tpl->setVariable( "content", $moduleResult['content'] );
    $Result['content'] = $tpl->fetch( "design:album/edit.tpl");

} else {
    $oContent = eZContentObject::fetch( $iObjectId );
    $dataMap = $oContent->dataMap();
    $imgAlias = $dataMap['image']->content()->aliasList();
    //var_dump($imgAlias);exit;
    $aSuccess["id"] = $iObjectId;
    $aSuccess["name"] = $oContent->name();
    $aSuccess["image"] = $imgAlias['original']['url'];
    $aSuccess["content"] = 'Votre image a été crée';
    $aResult["success"] = $aSuccess;
    $Result['content'] = json_encode($aResult);
}


return $Result;