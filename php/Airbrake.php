<?php
include("../IronWorker.class.php");

$name = "airbrake-php";

$iw = new IronWorker('config.ini');
$iw->debug_enabled = true;

$zipName = "code/$name.zip";

$zipFile = IronWorker::zipDirectory(dirname(__FILE__)."/workers/airbrake", $zipName, true);

$res = $iw->postCode('airbrake.php', $zipName, $name);

$payload = array('api_key' => AIRBRAKE_API_KEY);

$iw->postTask($name, $payload);
