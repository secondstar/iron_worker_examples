from iron_worker import *

worker = IronWorker()

payload = {'pagerduty': {'query':'iron.io'}}

task = worker.queue(code_name='PythonWorker101', payload=payload)
