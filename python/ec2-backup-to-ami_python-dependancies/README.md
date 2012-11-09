# EC2 backup to AMI - a sample showing how to use python dependacies via pip

This sample shows how to use a Python script that relies on 3rd party libraries installed via pip.

Its based on the advice given at: http://stackoverflow.com/questions/13285901/how-to-bundle-python-dependancies-in-ironworker

## To run

_NB!  These scripts will create AMIs of all running instances in your EC2 account (across all regions).  This will reboot all your instances!_

1. Be sure you've setup your Iron.io credentials, see main [README.md](https://github.com/iron-io/iron_worker_examples).
1. Run ```iron_worker upload ec2-backup-to-ami``` to upload the worker code package to IronWorker.
1. Queue up a task:
        ```iron_worker queue ec2-backup-to-ami --payload "export AWS_ACCESS_KEY_ID=xxxxx && export AWS_SECRET_ACCESS_KEY=xxxx"```
1. Look at [HUD](https://hud.iron.io) to view your tasks running, check logs, etc.

## How it works

1. Unlike with a Ruby worker, there is no build in functionality to manage 3rd party Python dependancies
1. However, by making your worker of type "binary", you can run a build step that does a pip installation to a local folder before your worker code runs
1. Then, launch your python exec via a shell script, which can setup the required paths and env vars
1. Note how the script uses the -payload param to "source" some additional environment variables into the Python script's run environment
1.  The Python scripts in question are actually installed as part of the [botocross](http://github.com/sopel/botocross) library

