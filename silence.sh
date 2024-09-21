#!/bin/bash

#!/bin/bash

function usage {
    echo "usage: $0 [-a start] [-e end] -n name -v value -u url -b bearer [-c] [-d days] [-h hours] [-m minutes] [-s seconds]"
    echo "  -a: start time"
    echo "  -n: name of label"
    echo "  -v: the value the label will match"
    echo "  -u: url of grafana instance"
    echo "  -b: bearer token"
    echo "  -c: use current date for start time"
    echo "  -e: end time"
    echo "  -d: number of days from start time for end time"
    echo "  -h: number of hours from start time for end time"
    echo "  -m: number of minutes from start time for end time"
    echo "  -s: number of seconds from start time for end time"
    echo "  Note: You must specify either -a or -c for the start time, and at least one of -e, -d, -h, -m, or -s for the end time."
    echo "  Note: The -d, -h, -m, and -s flags will be added together to calculate the end time."
    echo "  Here is an example: $0 -a \"September 6, 2024 3:16PM\" -n grafana_folder -v Prod8 -u vfl-061.engage.sas.com -b token -d 1 -h 2 -m 30 -s 45"
}

use_current_date=false
start_specified=false
start=""
end=""
days=0
hours=0
minutes=0
seconds=0
end_specified=false

while getopts ":a:e:n:v:u:b:cd:h:m:s:" opt; do
    case $opt in
        a) start="$OPTARG"
           start_specified=true
        ;;
        e) end="$OPTARG"
           end_specified=true
        ;;
        n) name="$OPTARG"
        ;;
        v) value="$OPTARG"
        ;;
        u) url="$OPTARG"
        ;;
        b) bearer="$OPTARG"
        ;;
        c) use_current_date=true
        ;;
        d) days="$OPTARG"
        ;;
        h) hours="$OPTARG"
        ;;
        m) minutes="$OPTARG"
        ;;
        s) seconds="$OPTARG"
        ;;
        \?) echo "Invalid option -$OPTARG" >&2
            usage
            exit 1
        ;;
        :) echo "Option -$OPTARG requires an argument." >&2
           usage
           exit 1
        ;;
    esac
done

if [ -z "$name" ] || [ -z "$value" ] || [ -z "$url" ] || [ -z "$bearer" ]; then
    usage
    exit 1
fi

# Check if both -S and -c options are used, which is not allowed
if $use_current_date && $start_specified; then
    echo "Error: You cannot use both -S and -c options." >&2
    usage
    exit 1
# If -c option is used, set the start time to the current date and time
elif $use_current_date; then
    start="$(date --iso-8601=seconds)"
# If -S option is used, parse the provided start time
elif $start_specified; then
    start="$(date -u -d "$start" --iso-8601=seconds)"
# If neither -S nor -c options are used, show an error and exit
else
    echo "Error: You must specify either -S or -c option." >&2
    usage
    exit 1
fi

# Check if -e is used along with any of -d, -h, -m, or -s, which is not allowed
if $end_specified && ([ "$days" -ne 0 ] || [ "$hours" -ne 0 ] || [ "$minutes" -ne 0 ] || [ "$seconds" -ne 0 ]); then
    echo "Error: You cannot use -e with any of -d, -h, -m, or -s options." >&2
    usage
    exit 1
# Check if none of the end time options (-e, -d, -h, -m, -s) are specified
elif ! $end_specified && [ "$days" -eq 0 ] && [ "$hours" -eq 0 ] && [ "$minutes" -eq 0 ] && [ "$seconds" -eq 0 ]; then
    echo "Error: You must specify at least one of -e, -d, -h, -m, or -s options." >&2
    usage
    exit 1
fi

# If -e option is used, parse the provided end time
if $end_specified; then
    end="$(date -u -d "$end" --iso-8601=seconds)"
# Otherwise, calculate the end time by adding the specified days, hours, minutes, and seconds to the start time
else
    end="$(date -u -d "$start +$days days +$hours hours +$minutes minutes +$seconds seconds" --iso-8601=seconds)"
fi

# Make a curl request to create a silence in Grafana
curl -s \
    -d '{
            "comment": "",
            "createdBy": "admin",
            "endsAt": "'"$end"'",
            "matchers": [
                {
                "isEqual": true,
                "name": "'"$name"'",
                "value": "'"$value"'",
                "isRegex": false
                }
            ],
            "startsAt": "'"$start"'"
        }' \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $bearer" \
    -H 'Accept: application/json' \
    "https://$url/api/alertmanager/grafana/api/v2/silences"

# curl -v \
# -H "Authorization: Bearer $bearer" \
# "https://$url/api/alertmanager/grafana/api/v2/silences"