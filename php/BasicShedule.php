<?php
include("../IronWorker.class.php");

$name = "testBasic-Schedule-php";

$iw = new IronWorker('config.ini');

$iw->upload(dirname(__FILE__)."/workers/hello_world", 'testTask.php', $name);

$payload = array(
    'key_one' => 'Payload',
    'key_two' => 2
);

# 3 minutes later
$start_at = time()+3*60;

# Run task every 2 minutes 10 times
$schedule_id = $iw->postScheduleAdvanced($name, $payload, $start_at, 2*60, null, 10);

# Get schedule information
$schedule = $iw->getSchedule($schedule_id);
echo "Schedule:\n";
print_r($schedule);

echo "\ndone\n";



