#!/bin/bash

# What: Hinted-handoff queue throughput per minute size on disk from the last 24 hours, grouped by hour, and all tags.
# Why: This will tell us how fast (or slow) the hinted-handoff queue is draining (or filling up)

INFLUXDB_USER="foo"
INFLUXDB_PASSWORD="bar"

influx -username $INFLUXDB_USER -password $INFLUXDB_PASSWORD -execute 'SELECT derivative(max("queueBytes"), 60s) FROM "_internal"."monitor"."hh_processor" WHERE time > now() - 24h GROUP BY time(1h),* fill(0)
' > hintedHandoffQueueThroughput.txt

#ZIP it all up and send it
#tar -czf ${BASE_NAME}.tar.gz $OUT_DIR

echo "Done!!"
echo "Please send the tar file to Influxdata support"