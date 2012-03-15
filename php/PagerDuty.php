<?php
include("../IronWorker.class.php");

$name = "pagerDuty-php";

$iw = new IronWorker('config.ini');
$iw->debug_enabled = true;

$zipName = "code/$name.zip";

$zipFile = IronWorker::zipDirectory(dirname(__FILE__)."/workers/pager_duty", $zipName, true);

$res = $iw->postCode('pagerDuty.php', $zipName, $name);

$payload = array(
    'API_KEY' => PAGERDUTY_API_KEY
);

$iw->postTask($name, $payload);
