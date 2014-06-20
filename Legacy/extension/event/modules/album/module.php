<?php

$Module = array( 'name' => 'Event place management',
                 'variable_params' => true );

$ViewList = array();

$ViewList['edit'] = array(
    'script' => 'edit.php',
    'functions' => array( 'edit' ),
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

$FunctionList = array();
$FunctionList['edit'] = array();
$FunctionList['action'] = array();
$FunctionList['delete'] = array();