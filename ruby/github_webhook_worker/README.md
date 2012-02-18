# Github Webhook Worker

This shows how to kick off a worker from a webhook. This example uses Github's Service Hooks.

NOT COMPLETE YET

## Getting started

- Upload the worker by running upload.rb in this directory
- Add the following url to github Service Hooks, Post-Receive URLs: https://worker-aws-us-east-1.iron.io/2/projects/MY_PROJECT_ID/tasks/webhook?code_name=GithubWebhookWorker&oauth=MY_IRON_TOKEN
- Click Update Settings
- Click Test Hook

