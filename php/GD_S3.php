<?php
include("../IronWorker.class.php");
/*
 * This example demonstrates drawing images using GD library and uploading result to Amazon S3 storage
 */

$config = parse_ini_file('../config.ini', true);

$name = "testGD_S3.php";

$iw = new IronWorker('config.ini');

# Creating and uploading code package.
$iw->upload(dirname(__FILE__)."/workers/draw_gd_and_upload_to_s3", 'gd_s3.php', $name);

$payload = array(
    's3' => array(
        'access_key' => $config['s3']['access_key'],
        'secret_key' => $config['s3']['secret_key'],
        'bucket'     => $config['s3']['bucket'],
    ),
    'image_url' => 'http://www.iron.io/assets/banner-mq-bg.jpg',
    'text'      => 'Hello from Iron Worker!'
);

# Adding new task.
$task_id = $iw->postTask($name, $payload);

# Wait for task finish
$details = $iw->waitFor($task_id);
print_r($details);

$log = $iw->getLog($task_id);
echo "Task log:\n $log\n";

