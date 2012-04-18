<?php
include("../IronWorker.class.php");

$name = "testTaskSimple-php";

$iw = new IronWorker('config.ini');

# Creating and uploading code package.
$iw->upload(dirname(__FILE__)."/workers/hello_world_simple", 'testTaskSimple.php', $name);

# Adding new task.
$task_id = $iw->postTask($name);

# Wait for task finish
$details = $iw->waitFor($task_id);
print_r($details);


