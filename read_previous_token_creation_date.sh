#!/bin/sh
if [ -f previous_instance_id.json ]; then
  cat previous_token_creation_date.json
else
  echo '{"token_creation_date": ""}'
fi
