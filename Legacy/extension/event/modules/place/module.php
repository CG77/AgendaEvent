<?php

$Module = array( 'name' => 'Event place management',
                 'variable_params' => true );

$ViewList = array();

$ViewList['edit'] = array(
    'script' => 'edit.php',
    'functions' => array( 'action', 'edit' ),
    'params' => array( 'ObjectID', 'EditVersion', 'EditLanguage' )
);

$ViewList['action'] = array(
    'script' => 'action.php',
    'functions' => array( 'action', 'edit' ),
    'params' => array( )
);

$ViewList['cities'] = array(
    'script' => 'cities.php',
    'functions' => array( 'read' ),
    'params' => array( 'NodeID','City','Type')
);

$FunctionList = array();
$FunctionList['cities'] = array();
$FunctionList['read'] = array();
$FunctionList['edit'] = array();
$FunctionList['action'] = array();