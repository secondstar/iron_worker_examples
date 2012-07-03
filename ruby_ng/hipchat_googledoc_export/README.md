# Hipchat to GoogleDrive export

This worker export history from your hipchat account to your GoogleDrive spreadsheets (one spreadsheet per months)

1. Be sure you've setup your Iron.io credentials, see main [README.md](https://github.com/iron-io/iron_worker_examples).
1. Run `iron_worker upload hipchat_export` to upload the worker code package to IronWorker.
1. Queue up a task:
  1. From command line: `iron_worker queue HipchatExport -p '{"hipchat_token":"YOURTOKEN","google_password":"YOURPASSWORD","google_username":"YOURUSERNAME"}'`
  1. Run `ruby run_hipchat_export.rb` to queue up a task.
1. Look at [HUD](https://hud.iron.io) to view your tasks running, check logs, etc.
