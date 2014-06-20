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
    $redirectUri = str_replace( "content", "place", $redirectUri );
    $Module->redirectTo( $redirectUri );
}
//echo"<pre>";print_r($moduleResult["content"]);echo"</pre>";die;
if( isset( $moduleResult['content'] ) ) {
    $tpl->setVariable( "content", $moduleResult['content'] );
    $Result['content'] = $tpl->fetch( "design:place/edit.tpl");
} else {
    $oContent = eZContentObject::fetch( $iObjectId );
    $aSuccess["id"] = $iObjectId;
    $aSuccess["name"] = $oContent->name();
    $aSuccess["content"] = 'Votre lieu a bien été créé';
    $aResult["success"] = $aSuccess;
    $Result['content'] = json_encode($aResult);
}

return $Result;