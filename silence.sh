#!/bin/bash

function usage {
    echo "usage: ./silence.sh start end name value url bearer"
    echo "  start: start time (use \"now\" for current date)"
    echo "  end: end time"
    echo "  name: name of label"
    echo "  value: the value the label will match"
    echo "  url: url of grafana instance"
    echo "  bearer: bearer token" 
    echo "  Here is an example: ./silence.sh "September 6, 2024 3:16PM"  "September 6, 2025 3:16PM" grafana_folder Prod8 vfl-061.engage.sas.com token"
}

usage

start=""
if [ "$1" = "now" ]; then
    start= "$(date --iso-8601=seconds)"
  else 
    start="$(date -u -d "$1" --iso-8601=seconds)"
fi 
end="$(date -u -d "$2" --iso-8601=seconds)"

curl -v \
    -d '{
            "comment": "",
            "createdBy": "admin",
            "endsAt": "'"$end"'",
            "matchers": [
                {
                "isEqual": true,
                "isRegex": false,
                "name": "'"$3"'",
                "value": "'"$4"'"
                }
            ],
            "startsAt": "'"$start"'"
        }' \
    -H 'Content-Type: application/json' \
    -H 'Accept: application/json' \
    -H "Authorization: Bearer $6" \
    "https://$5/grafana/api/alertmanager/grafana/api/v2/silences"