#!/usr/bin/env bash

W_DIR="${HOME}/wakeup_youtube"

bash ${W_DIR}/aplay_random.sh
while [ $? -gt 0 ]
do
  bash ${W_DIR}/aplay_random.sh
done 