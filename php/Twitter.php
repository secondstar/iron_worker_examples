<?php
include("../IronWorker.class.php");

$name = "postToTwitter-php";

$iw = new IronWorker('config.ini');

# Creating and uploading code package.
$iw->upload(dirname(__FILE__)."/workers/post_to_twitter", 'postToTwitter.php', $name);

$payload = array(
    'message' => "Hello From PHPWorker at ".date('r')."!\n",
    'url'     => 'http://www.iron.io/'
);

$task_id = $iw->postTask($name, $payload);

# Wait for task finish
$details = $iw->waitFor($task_id);
print_r($details);

$log = $iw->getLog($task_id);
echo "Task log:\n $log\n";

