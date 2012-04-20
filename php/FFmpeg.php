<?php
include("../IronWorker.class.php");

$name = "testFFmpeg-php";

$iw = new IronWorker('config.ini');

# Creating and uploading code package.
$iw->upload(dirname(__FILE__)."/workers/ffmpeg", 'ffmpeg.php', $name);

# Adding new task.
$task_id = $iw->postTask($name);

# Wait for task finish
$details = $iw->waitFor($task_id);
print_r($details);

# Get task log
$log = $iw->getLog($task_id);
echo "Task log:\n $log\n";
