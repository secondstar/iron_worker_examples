<?php
include("../IronWorker.class.php");

$name = "testMongo-php";

$config = parse_ini_file('../config.ini', true);

$iw = new IronWorker($config['iron_worker']);

# Creating and uploading code package.
$iw->upload(dirname(__FILE__)."/workers/mongo", 'mongo.php', $name);

$payload = array(
    'db' => $config['mongo']
);

$task_id = $iw->postTask($name, $payload);

# Wait for task finish
$details = $iw->waitFor($task_id);
print_r($details);

# Check log
$log = $iw->getLog($task_id);
echo "Task log:\n $log\n";



