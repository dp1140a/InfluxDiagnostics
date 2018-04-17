#!/bin/bash
#countsSeriesAndMeasurements.sh

# What: Series and measurement counts from the last 24 hours, grouped by hour, database, and hostname.
# Why: This allows us to see the current series and measurement count, as well as how much the series count has grown per hour over the last 24 hours
echo -e "**************************************"
echo -e countsSeriesAndMeasurements.sh
echo -e "**************************************"

INFLUXDB_USER="foo"
INFLUXDB_PASSWORD="bar"
OUT_DIR="output"

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
# echo $INFLUXDB_USER : $INFLUXDB_PASSWORD
influx -username $INFLUXDB_USER -password $INFLUXDB_PASSWORD -database '_internal' -execute 'SELECT last(numMeasurements) as last_measurement, last(numSeries) as last_series FROM "_internal"."monitor"."database" WHERE time > now() - 24h GROUP BY time(1h),"database","hostname" fill(0)' > $OUT_DIR/countsSeriesAndMeasurements.txt

echo "Done."
