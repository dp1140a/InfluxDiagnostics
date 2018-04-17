#!/usr/bin/env bash
PACKAGE="github.com/influxdata/qprof"

# Check if GOlang is installed
if ! [ -x "$(command -v go)" ]; then
  echo 'Error: go is not installed. Please install Golang and run again' >&2
  exit 1
fi

go get $PACKAGE
platforms=("linux/amd64" "darwin/amd64")

for platform in "${platforms[@]}"
do
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}
    output_name=qprof'-'$GOOS'-'$GOARCH

    env GOOS=$GOOS GOARCH=$GOARCH go build -o $output_name $PACKAGE
    if [ $? -ne 0 ]; then
        echo 'An error has occurred! Aborting the script execution...'
        exit 1
    fi
done
