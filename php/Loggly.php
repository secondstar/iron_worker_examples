<?php
include("../IronWorker.class.php");

$name = "loggly-php";

$iw = new IronWorker('config.ini');

# Creating and uploading code package.
$iw->upload(dirname(__FILE__)."/workers/loggly", 'loggly.php', $name);

for ($i = 1; $i <= 50; $i++)
{
    $payload = array('api_key' => LOGGLY_KEY, 'i' => $i);

    $iw->postTask($name, $payload);
}
