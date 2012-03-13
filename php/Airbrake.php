<?php
include("../IronWorker.class.php");

$name = "airbrake-php";

$iw = new IronWorker('config.ini');
$iw->debug_enabled = true;

$zipName = "code/$name.zip";

$zipFile = IronWorker::zipDirectory(dirname(__FILE__)."/workers/airbrake", $zipName, true);

$res = $iw->postCode('airbrake.php', $zipName, $name);

$task_id = $iw->postTask($name, $payload);
echo "task_id = $task_id \n";
sleep(15);
$details = $iw->getTaskDetails($task_id);
print_r($details);
