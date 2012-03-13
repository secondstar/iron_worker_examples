<?php
require_once dirname(__FILE__) . '/lib/Airbrake.class.php';
$brake = new Services_Airbrake('API_Key', 'production', 'curl');

// YOUR WORKER CODE HERE

try {
    //do something
}
catch (Exception $e) {
    $brake->notify(get_class($e), $e->getMessage(), $e->getFile(), $e->getLine(), $e->getTrace(), "worker");
}
