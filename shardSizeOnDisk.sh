#!/bin/bash

# What: Shard size on disk from the last 24 hours, grouped by hour, database, shard ID, and hostname.
# Why: This will tell us the approximate database size per hour, which can be used for identifying "hot spots" in a cluster or very large shards.

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

influx -username $INFLUXDB_USER -password $INFLUXDB_PASSWORD -execute 'SELECT last(diskBytes) AS diskBytes FROM "_internal"."monitor"."shard" WHERE time > now() - 24h GROUP BY time(1h),"id","database","hostname" fill(0)' > shardSizeOnDisk.txt

#ZIP it all up and send it
#tar -czf ${BASE_NAME}.tar.gz $OUT_DIR

echo "Done!!"
echo "Please send the tar file to Influxdata support"