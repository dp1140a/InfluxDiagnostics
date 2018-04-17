
# Influxdb Diagnostics
A set of scripts that will run diagnostics queries on your installation of influxdb.  You can run the scripts individually or run the diagnostics script to run them all.  If you run them all the script will also place the output into a tarball for upload to Influxdata support

## Usage:

```bash
./[scriptName] [options]
```

## Options:
If you have set a username and password on influx db you must pass these in.  If not they are not necessary.  The user you pass in must also have READ access to the _internal database.

* -u --username The InfluxDB username
* -p --password The InfluxDB Password

## qprof
You can use the query profile tool in the qprof directory.  You will need to have Go installed.  Then run the setup.sh script .  This will compile two executables one for the linux and one for macos.  You can then run the qprof of your choice.  Please refer to [https://github.com/influxdata/qprof](https://github.com/influxdata/qprof) for details on how to use that tool.

## ToDo
* Add in additional queries
* Better docs for qprof
