<?php
include("../IronWorker.class.php");

$name = "pagerDuty-php";

$iw = new IronWorker('config.ini');

# Creating and uploading code package.
$iw->upload(dirname(__FILE__)."/workers/pager_duty", 'pagerDuty.php', $name);

$payload = array(
    'API_KEY' => PAGERDUTY_API_KEY
);

$iw->postTask($name, $payload);
