#!/bin/bash
# writesPointsPerMInute.sh

# What: Points written per minute from the last 24 hours, grouped by hour and hostname.
# Why: This allows us to see the number of points hitting each instance per minute.
echo -e "**************************************"
echo -e writesPointsPerMInute.sh
echo -e "**************************************"

INFLUXDB_USER="foo"
INFLUXDB_PASSWORD="bar"

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -u|--username)
    INFLUXDB_USER="$2"
    shift # past argument
    ;;
    -p|--password)
    INFLUXDB_PASSWORD="$2"
    shift # past argument
    ;;
    -o|--outdir)
    OUT_DIR="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

echo -e "Running query"
influx -username $INFLUXDB_USER -password $INFLUXDB_PASSWORD -database '_internal' -execute 'SELECT non_negative_derivative(mean("pointReq"), 60s) FROM "_internal"."monitor"."write" WHERE time > now() - 24h GROUP BY time(1h),"hostname" fill(0)' > $OUT_DIR/writesPointsPerMinute.txt

#ZIP it all up and send it
#tar -czf ${BASE_NAME}.tar.gz $OUT_DIR

echo "Done!!"
