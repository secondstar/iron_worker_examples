# Github Webhook Worker

This shows how to kick off a worker from a webhook. This example uses Github's Service Hooks.

## Getting started

- Download and put `iron.json` in current directory [more info](http://dev.iron.io/worker/reference/configuration/)
- Upload webhook via  [CLI](http://dev.iron.io/worker/reference/cli/) tool: `iron_worker upload github_webhook`
- Go to Github Service Hooks: github.com -> repository -> admin -> Service Hooks -> WebHook URLs
- Assemble webhook url:
```
https://worker-aws-us-east-1.iron.io/2/projects/<project_id>/tasks/webhook?code_name=GithubWebHook&oauth=<token>"
```
Where `<project_id>` and `<token>`are same as `iron.json` contain, `GithubWebHook` is name of your worker
- Enter webhook url
- Click Update Settings
- Click Test Hook
- Check the worker status and logs in IronWorker at http://hud.iron.io to ensure it ran successfully.