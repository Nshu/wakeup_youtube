#!/usr/bin/env bash

readonly WORKING_DIR="${HOME}/wakeup_youtube"
cd ${WORKING_DIR}
export PATH=${PATH}:/usr/local/bin

readonly PLAYLIST_URL="https://www.youtube.com/playlist?list=PLl_bkR2Yd2EF0TShPL2tl7mYb98hvt8OV"
readonly CACHE_DIR="local_cache"

# online video IDs
oIDs=$(youtube-dl --get-id ${PLAYLIST_URL}) || exit 0 # if youtube-dl failed, exit.s
#oIDs=$(cat oIDs_cache.txt)
echo ${oIDs} > oIDs_cache.txt

function all_download () {
    for oID in ${oIDs}
    do
        youtube-dl -x --audio-format wav -o "${CACHE_DIR}/%(id)s.%(ext)s" https://www.youtube.com/watch?v=${oID}
    done
}

function download_missing_video () {
    # saved video IDs
    sIDs=$(ls ${CACHE_DIR} | xargs -i basename {} .wav)

    # if sIDs is empty
    if [[ -z ${sIDs} ]]
    then
        all_download
        return 0
    fi

    for oID in ${oIDs}
    do
        is_oID_in_sID="false"
        for sID in ${sIDs}
        do
            echo "oID : ${oID}"
            echo "sID : ${sID}"
            if [[ ${oID} = ${sID} ]]
            then
                is_oID_in_sID="true"
                break
                #echo "oID : ${oID}, sID : ${sID}"
            else
                :
                #echo "oID : ${oID}, sID : ${sID}"
            fi
        done
        if [[ ${is_oID_in_sID} = "false" ]]
        then
            youtube-dl -x --audio-format wav -o "${CACHE_DIR}/%(id)s.%(ext)s" https://www.youtube.com/watch?v=${oID}
        fi
    done
}

function del_excess_video () {
    # saved video IDs
    sIDs=$(ls ${CACHE_DIR} | xargs -i basename {} .wav)

    # Delete excess video
    for sID in ${sIDs}
    do
        is_sID_in_oID="false"
        for oID in ${oIDs}
        do
            if [[ ${sID} = ${oID} ]]
            then
                is_sID_in_oID="true"
                break
            fi
        done
        if [[ ${is_sID_in_oID} = "false" ]]
        then
             rm ${CACHE_DIR}/${sID}.wav
        fi
    done
}

download_missing_video
del_excess_video
