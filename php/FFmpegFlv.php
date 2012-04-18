<?php
include("../IronWorker.class.php");

$name = "testFFmpeg-flv-php";

$iw = new IronWorker('config.ini');

# Creating and uploading code package.
$iw->upload(dirname(__FILE__)."/workers/ffmpeg_flv", 'ffmpeg.php', $name);

# Adding new task.
$payload = array(
    'input_file' => 'https://s3.amazonaws.com/iron-examples/video/iron_man_2_trailer_official.flv'
);
$task_id = $iw->postTask($name, $payload);

# Wait for task finish
$details = $iw->waitFor($task_id);
echo "Status: {$details->status}\n";

# Get task log
$log = $iw->getLog($task_id);
echo "Task log:\n $log\n";



