<?php
include("../IronWorker.class.php");

$name = "testBasic-php";

$iw = new IronWorker();

$iw->upload(dirname(__FILE__)."/workers/hello_world", 'testTask.php', $name);

$payload = array(
    'key_one' => 'Helpful text',
    'key_two' => 2,
    'options' => array(
        'option 1',
        'option 2',
        'option 3',
        'option 4',
        'option five'
    )
);

$task_id = $iw->postTask($name, $payload);

# Wait for task finish
$details = $iw->waitFor($task_id);
print_r($details);

$log = $iw->getLog($task_id);
echo $log;



