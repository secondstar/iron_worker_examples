<?php

# the payload we get from github needs to be decoded first
$payload_raw = getPayload();
parse_str($payload_raw, $payload);
echo "Payload:";
print_r($payload);

# Then we can parse the json
$data = json_decode($payload['payload'], true);
echo "data:";
print_r($data);


# Do something exciting here
