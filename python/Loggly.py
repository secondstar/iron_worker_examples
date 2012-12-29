from iron_worker import *

worker = IronWorker()

package = CodePackage()
package.name = "LogglyExample"
package.merge("loggly", ignoreRootDir=True)
package.merge_dependency("hoover")
package.merge_dependency("httplib2")
package.executable = "loggly.py"

worker.upload(package)
payload = {'loggly': {'subdomain': 'LOGGLY_SUBDOMAIN', 'username': 'LOGGLY_USERNAME', 'password': 'LOGGLY_PASSWORD'}}

task = worker.queue(code_name='LogglyExample', payload=payload)
print task
