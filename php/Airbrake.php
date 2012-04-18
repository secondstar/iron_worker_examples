<?php
include("../IronWorker.class.php");

$name = "airbrake-php";

$iw = new IronWorker('config.ini');
$iw->debug_enabled = true;

$iw->upload(dirname(__FILE__)."/workers/airbrake", 'airbrake.php', $name);

$payload = array('api_key' => AIRBRAKE_API_KEY);

$iw->postTask($name, $payload);
