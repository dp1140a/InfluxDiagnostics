#!/bin/bash
# writesHttpReqPerMinute.sh

# What: HTTP write requests per minute from the last 24 hours, grouped by hour and hostname.
# Why: By reviewing this output, along with the points per minute throughput, it should allow us to get an estimate for the batch size and request volume per instance
echo -e "**************************************"
echo -e writesHttpReqPerMinute.sh
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
influx -username $INFLUXDB_USER -password $INFLUXDB_PASSWORD -database '_internal' -execute 'SELECT non_negative_derivative(mean("writeReq"), 60s) FROM "_internal"."monitor"."httpd" WHERE time > now() - 24h GROUP BY time(1h),"hostname" fill(0)' > $OUT_DIR/writesHttpReqPerMinute.txt

#ZIP it all up and send it
#tar -czf ${BASE_NAME}.tar.gz $OUT_DIR

echo "Done!!"
