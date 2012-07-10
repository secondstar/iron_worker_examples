# Worker 101

This covers most of the core concepts of using IronWorker including loading third party
dependencies.

1. Be sure you've setup your Iron.io credentials, see main [README.md](https://github.com/iron-io/iron_worker_examples).
1. Run `iron_worker upload worker101` to upload the worker code package to IronWorker.
1. Queue up a task:
  1. From command line: `iron_worker queue PythonWorker101 --payload '{"query":"xbox"}'`
  1. Run `python enqueue.py` to queue up a task. Edit enqueue.py to change the Twitter query.
1. Look at [HUD](https://hud.iron.io) to view your tasks running, check logs, etc.
