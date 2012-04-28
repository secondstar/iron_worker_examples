<?php

require "../../IronWorker.class.php";

$worker = new IronWorker();

$worker->upload(dirname(__FILE__), 'hello_worker.php', 'HelloWorker');
