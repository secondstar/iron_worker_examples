#!/usr/bin/env bash 
export PYTHONPATH="$HOME/pips/lib/python2.7/site-packages:$PYTHONPATH" 
export PATH="$HOME/pips/bin:$PATH" 

#Extract the payload file location
while [ $# -gt 1 ]; do
	if [ "$1" = "-payload" ]; then
	  PAYLOAD_FILE="$2"
	  break
	fi

	shift
done

#Run the payload file to load the AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables
source $PAYLOAD_FILE

echo "Validating credentials"
validate-credentials.py
echo "Describe instances"
describe-instances.py -f instance-state-name=running -f tag-key=Name
echo "Create images"
create-images.py -f instance-state-name=running -f tag-key=Name
echo "Delete old AMIs"
delete-images.py --backup_retention 30 -f tag-key=Name