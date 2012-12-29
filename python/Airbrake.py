from iron_worker import *

worker = IronWorker()

package = CodePackage()
package.name = "AirbrakeExample"
package.merge("airbrake", ignoreRootDir=True)
package.merge_dependency("airbrakepy")
package.merge_dependency("xmlbuilder")
package.executable = "worker.py"

worker.upload(package)

task = worker.queue(code_name='AirbrakeExample')
print task
