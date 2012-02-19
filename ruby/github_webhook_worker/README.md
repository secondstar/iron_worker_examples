# Github Webhook Worker

This shows how to kick off a worker from a webhook. This example uses Github's Service Hooks.

## Getting started

- Modify the hipchat API key in github_webhook_worker.rb
- Upload the worker by running upload.rb in this directory
- Add the following url to github Service Hooks, Post-Receive URLs: https://worker-aws-us-east-1.iron.io/2/projects/MY_PROJECT_ID/tasks/webhook?code_name=GithubWebhookWorker&oauth=MY_IRON_TOKEN
- Click Update Settings
- Click Test Hook
- Check the worker status and logs in IronWorker at http://hud.iron.io to ensure it ran successfully.

That's it, now everytime someone commits, it'll execute the GithubWebhookWorker on IronWorker.

