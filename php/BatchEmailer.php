<?php
include("../IronWorker.class.php");

$name = "sendEmail-php";

$iw = new IronWorker('config.ini');

$iw->upload(dirname(__FILE__)."/workers/batch_emailer", 'sendEmail.php', $name);

$payload = array(
    'address' => "",
    'name'    => "Dear Friend",
    'subject' => 'PHPMailer Test Subject via mail(), basic',
    'reply_to' => array(
        'address' => "name@example.com",
        'name'    => "First Last"
    ),
    'from'     =>  array(
        'address' => "me@example.com",
        'name'    => "First Last"
    ),
);

# Send 5 different mails
for ($i = 1; $i <= 5;$i++){
    $payload['address'] = "name_$i@example.com";
    $payload['name']    = "Dear Friend $i";

    $task_id = $iw->postTask($name, $payload);
    echo "task_id = $task_id \n";

    # Wait for task finish
    $details = $iw->waitFor($task_id);
    print_r($details);

    $log = $iw->getLog($task_id);
    echo "Task log:\n $log\n";
}


