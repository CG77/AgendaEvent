<?php

$Module = $Params['Module'];

$moduleContent    = eZModule::findModule( "content" );
$iObjectId = $Params['ObjectID'];

$bRedirect = false;

$moduleResult = $moduleContent->run( "edit", array( $Params['ObjectID'],
                                             $Params['EditVersion'],
                                             $Params['EditLanguage'] ), false, false );
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
    $redirectUri = str_replace( "content", "event", $redirectUri );
    $Module->redirectTo( $redirectUri );
}

if ( isset( $moduleResult['content'] ) ) {

    $Result['content']      = $moduleResult['content'];
    $Result["content_info"] = array(
        "persistent_variable" => array(
            "bodyClass" => "bodyPage bodyDiary bodyForm"
        ) );

    return $Result;

} else {

    if ( $aUri[1] == "content" && $aUri[2] == "view" ) {

        $nodeRedirect = eZContentObjectTreeNode::fetch( $aUri[4] );

        $Module->redirectTo( $nodeRedirect->attribute( 'url_alias' ) );
        return;
    }
}
