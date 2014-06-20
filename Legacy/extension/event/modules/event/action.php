<?php

$tpl = eZTemplate::factory();
$Module = $Params['Module'];
$http = eZHTTPTool::instance();

$ini = eZINI::instance();
$http->setPostVariable( "ContentLanguageCode", $ini->variable( "RegionalSettings", "Locale" ) );

$module = eZModule::findModule( "content" );

$moduleResult = $module->run( "action" );

$redirectUri = $module->redirectURI();

$redirectUri = str_replace( "content", "event", $redirectUri );

$Module->redirectTo( $redirectUri );

return;
