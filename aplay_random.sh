#!/usr/bin/env bash

readonly WORKING_DIR="${HOME}/wakeup_youtube"
cd ${WORKING_DIR}
export PATH=${PATH}:/usr/local/bin

readonly WAV_DIR="local_cache"

wavs=($(ls ${WAV_DIR}))
random=$RANDOM
wavs_l=${#wavs[@]}
play_index=$(( ${random} % ${wavs_l} ))

aplay -N -D hw:1,0 ${WAV_DIR}/${wavs[${play_index}]}

