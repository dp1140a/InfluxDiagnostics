#!/bin/bash

# What: Points written per minute from the last 24 hours, grouped by hour and hostname.
# Why: This allows us to see the number of points hitting each instance per minute.

INFLUXDB_USER="foo"
INFLUXDB_PASSWORD="bar"

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -u|--username)
    $INFLUXDB_USER="$2"
    shift # past argument
    ;;
    -p|--password)
    $INFLUXDB_PASSWORD="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

influx -username $INFLUXDB_USER -password $INFLUXDB_PASSWORD -execute "SELECT non_negative_derivative(mean('pointReq'), 60s) FROM '_internal'.'monitor'.'write' WHERE time > now() - 24h GROUP BY time(1h),'hostname' fill(0)
" > writesPointsPerMinute.txt

#ZIP it all up and send it
#tar -czf ${BASE_NAME}.tar.gz $OUT_DIR

echo "Done!!"
echo "Please send the tar file to Influxdata support"