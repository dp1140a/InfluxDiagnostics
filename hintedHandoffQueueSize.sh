#!/bin/bash

# What: Hinted-handoff queue size from the last 24 hours, grouped by hour, and all tags.
# Why: This will tell us how large the hinted-handoff queue was for each hour, broken out by target server.

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

influx -username $INFLUXDB_USER -password $INFLUXDB_PASSWORD -execute 'SELECT max("queueBytes") FROM "_internal"."monitor"."hh_processor" WHERE time > now() - 24h GROUP BY time(1h),* fill(0)' > hintedHandoffQueueSize.txt

#ZIP it all up and send it
#tar -czf ${BASE_NAME}.tar.gz $OUT_DIR

echo "Done!!"
echo "Please send the tar file to Influxdata support"