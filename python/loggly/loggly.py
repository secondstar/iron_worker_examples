import hoover
import logging
import sys
import json

payload = None
payload_file = None
for i in range(len(sys.argv)):
    if sys.argv[i] == "-payload" and (i + 1) < len(sys.argv):
        payload_file = sys.argv[i + 1]
        break

f = open(payload_file, "r")
contents = f.read()
f.close()

payload = json.loads(contents)

if 'loggly' in payload:
    loggly_settings = payload['loggly']
    i = hoover.LogglySession(loggly_settings['subdomain'], loggly_settings['username'], loggly_settings['password'])
    i.config_inputs() #inject loggly handler into logger chain

#and then usual yada-yada is going on
logger = logging.getLogger('worker_log')

# YOUR CODE HERE

logger.debug("Debug message")

#MORE CODE

logger.warn('Warning message')

logger.fatal('Unable to launch spaceship due to recent moon nazis invasion. Sorry for inconvenience.')
