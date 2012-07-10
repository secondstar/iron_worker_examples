# Worker 101

This covers most of the core concepts of using IronWorker including loading third party
dependencies.

1. Be sure you've setup your Iron.io credentials, see main [README.md](https://github.com/iron-io/iron_worker_examples).
1. Run `iron_worker upload worker101` to upload the worker code package to IronWorker.
1. Queue up a task:
  1. From command line: `iron_worker queue PHPWorker101 -p '{"query":"xbox"}'`
  1. Run `php enqueue.php` to queue up a task. Edit enqueue.php to change the Twitter query.
1. Look at [HUD](https://hud.iron.io) to view your tasks running, check logs, etc.
