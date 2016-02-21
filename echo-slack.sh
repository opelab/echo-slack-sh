#!/bin/sh

set -eu

readonly DIR_TMP="${HOME}/tmp"

while getopts c:i:n:M:m:o: opts
do
    case $opts in
        c)
            CHANNEL=${OPTARG}
            ;;
        i)
            FACEICON=${OPTARG}
            ;;
        n)
            BOTNAME=${OPTARG}
            ;;
        o)
            ORG=${OPTARG}
            ;;
        M)
            MENSION=${OPTARG}
            ;;
        m)
            MESSAGE="${OPTARG}\n"
            ;;
        \?)
            usage_exit
            ;;
    esac
done

readonly CHANNEL=${CHANNEL:-"general"}
readonly BOTNAME=${BOTNAME:-"mybot"}
readonly FACEICON=${FACEICON:-"shell"}
readonly MESSAGE=${MESSAGE:-""}
readonly ORG=${ORG:-"unknown"}
readonly MENSION=${MENSION:-"none"}


# config file
readonly CONF_SLACK="${HOME}/.config/slack-${ORG}-${CHANNEL}.rc"
if [ -e ${CONF_SLACK} ];then
  . ${CONF_SLACK}
else
  echo "Error: ${CONF_SLACK} does not exist." 1>&2
  exit 2
fi

readonly FILE_TMP="${DIR_TMP}/slack-${ORG}-${CHANNEL}.tmp"

#get input stream
if [ ! -t 0 ]; then
  cat - |\
    tr '\n' '\\' |\
    sed 's/\\/\\n/g' \
    > ${FILE_TMP}

elif [ ! -z "${MESSAGE}" ]; then
  echo "${MESSAGE}" |\
    tr '\n' '\\' |\
    sed 's/\\$//' |\
    sed 's/\\/\\n/g' |\
    sed 's/\\nn$//g' \
    > ${FILE_TMP}
else
    echo "Error: MESSAGE is nothing." 1>&2
    exit 1
fi

# build message
if [ ${MENSION} == 'none' ]; then
  readonly MESSAGE_POST=$(cat ${FILE_TMP})
  readonly PAYLOAD_POST="{\"channel\": \"#${CHANNEL}\", \"username\": \"${BOTNAME}\", \"icon_emoji\": \":${FACEICON}:\", \"text\": \"${MESSAGE_POST}\" }"
else
  readonly MESSAGE_POST="@${MENSION} $(cat ${FILE_TMP})"
  readonly PAYLOAD_POST="{\"channel\": \"#${CHANNEL}\", \"username\": \"${BOTNAME}\", \"icon_emoji\": \":${FACEICON}:\", \"text\": \"${MESSAGE_POST}\", \"parse\": \"full\" }"
fi

#send to Incoming WebHooks
curl -s -S -X POST \
  --data-urlencode "payload=${PAYLOAD_POST}" ${URL_SLACK_WEBHOOK} >/dev/null

exit $?

