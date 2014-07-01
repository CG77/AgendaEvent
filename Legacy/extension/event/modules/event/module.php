<?php

$Module = array( 'name' => 'Event page management',
                 'variable_params' => true );

$ViewList = array();

$ViewList['edit'] = array(
    'script' => 'edit.php',
    'functions' => array( 'edit', 'action' ),
    'params' => array( 'ObjectID', 'EditVersion', 'EditLanguage' )
);

$ViewList['action'] = array(
    'script' => 'action.php',
    'functions' => array( 'action', 'edit' ),
    'params' => array( )
);

$ViewList['delete'] = array(
    'script' => 'delete.php',
    'functions' => array( 'delete' ),
    'params' => array( 'objectID')
);

$ViewList['confirmation'] = array(
    'script' => 'confirmation.php',
    'functions' => array( 'confirmation' ),
    'params' => array( 'objectID')
);
$FunctionList = array();
$FunctionList['list'] = array();
$FunctionList['edit'] = array();
$FunctionList['delete'] = array();
$FunctionList['action'] = array();
$FunctionList['confirmation'] = array();