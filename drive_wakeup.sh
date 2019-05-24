#!/usr/bin/env bash

readonly W_DIR="${HOME}/wakeup_youtube"

# if W_DIR is empty, exit
if [[ -z "$(ls ${W_DIR})" ]]; then
    exit 0
fi

bash ${W_DIR}/aplay_random.sh
while [ $? -gt 0 ]
do
  sleep 1
  bash ${W_DIR}/aplay_random.sh
done 
echo "finish"
