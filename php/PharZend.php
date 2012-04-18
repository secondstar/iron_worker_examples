<?php
include("../IronWorker.class.php");

$name = "testPharZend-php";

$iw = new IronWorker('config.ini');

# Creating and uploading code package.
$iw->upload(dirname(__FILE__)."/workers/phar_zend_lib", 'pharZend.php', $name);

$task_id = $iw->postTask($name);

# Wait for task finish
$details = $iw->waitFor($task_id);
print_r($details);

# Check log
$log = $iw->getLog($task_id);
echo "Task log:\n $log\n";




