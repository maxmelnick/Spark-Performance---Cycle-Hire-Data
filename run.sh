#!/bin/bash

set -xe

# Download the data
mkdir -p /tmp/data/full-bike
aws s3 sync s3://cycling.data.tfl.gov.uk/usage-stats/ /tmp/data/full-bike

# Create a `tmp` directory for Spark logs.
mkdir -p /tmp/spark/logs

## Build the latest version of Spark locally
git clone https://github.com/apache/spark.git
cd spark
build/mvn -DskipTests clean package
cd ../

# Spark-Submit on a local Spark instance, with a command as follows. Make sure there's at least 8g RAM and 6 cores available to Spark.
./spark/bin spark-submit   \
--class com.scottlogic.blog.analysis.BikeDataAnalysis \
--master local[*]   \
--executor-memory 4g   \
--num-executors 2 \
--conf spark.executor.instances=2   \
--total-executor-cores 6   \
spark-shuffle-performance-1.0-SNAPSHOT.jar   10000