<?php
include("../IronWorker.class.php");

$name = "testPDO.php";

$config = parse_ini_file('../config.ini', true);

# Passing array of options instead of config file.
$iw = new IronWorker($config['iron_worker']);

# Creating and uploading code package.
$iw->upload(dirname(__FILE__)."/workers/PDO", 'Pdo.php', $name);

$payload = array(
    'connection'  => $config['pdo'],
    'yet_another' => array('value', 'value #2')
);

$task_id = $iw->postTask($name, $payload);

# Wait for task finish
$details = $iw->waitFor($task_id);
print_r($details);

$log = $iw->getLog($task_id);
echo "Task log:\n $log\n";

