<?php
/**
 * Created by PhpStorm.
 * User: o.benyoussef
 * Date: 24/06/14
 * Time: 12:43
 */


$tpl = eZTemplate::factory();
$Module = $Params['Module'];
$http = eZHTTPTool::instance();

$ini = eZINI::instance();

$Result['content'] = $tpl->fetch('design:event/confirmation.tpl');


