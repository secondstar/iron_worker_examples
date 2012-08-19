# Hello Worker for Go

This is the most basic example.

1. Be sure you've setup your Iron.io credentials, see main [README.md](https://github.com/iron-io/iron_worker_examples).
1. Run `iron_worker upload hello` to upload the worker code package to IronWorker.
1. Queue up a task:
  1. From command line: `iron_worker queue hello --payload '{"query":"xbox"}'`
1. Look at [HUD](https://hud.iron.io) to view your tasks running, check logs, etc.

