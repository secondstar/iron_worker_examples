# Gitlab and Datadog example

This example demonstrates starting a worker from a GitlabHQ webhook.

1. Setup your Iron.io credentials
2. Add Thyour Datadog API credentials to a file `datadog.yml`:

    ```yaml
    datadog:
        api_key: "your_key_here"
    ```
3. `iron_worker upload gitlab_to_datadog`
4. Add the webhooks url to the web hooks page in a gitlab project.
5. Test it!
6. Check your datadog events board.

Give it a go!
