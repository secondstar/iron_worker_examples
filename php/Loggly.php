<?php
include("../IronWorker.class.php");

$name = "loggly-php";

$iw = new IronWorker('config.ini');
$iw->debug_enabled = true;

$zipName = "code/$name.zip";

$zipFile = IronWorker::zipDirectory(dirname(__FILE__) . "/workers/loggly", $zipName, true);

$res = $iw->postCode('loggly.php', $zipName, $name);

for ($i = 1; $i <= 50; $i++)
{
    $payload = array('api_key' => LOGGLY_KEY, 'i' => $i);

    $iw->postTask($name, $payload);
}
