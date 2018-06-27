# Spark Performance Analysis Example
This project splits the London Cycle Hire Data into two subsets, Weekend Journeys and Weekday Journeys, and saves the result as Parquet. This action is implemented twice, both in a slow and quick fashion, as discussed in this [blog post](https://matdeb-sl.github.io/blog/2018/03/22/apache-spark-performance.html), and will produce ~2GB of output data.

## Download the source data

To work correctly you will need to download all the [data files](http://cycling.data.tfl.gov.uk/) and put them in a folder called `/tmp/data/full-bike`. The command below assumes you have the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) installed.

```
mkdir -p /tmp/data/full-bike
cd /tmp/data/full-bike
aws s3 sync s3://cycling.data.tfl.gov.uk/usage-stats/ .
```

## Prep the dependencies


Create a `tmp` directory for Spark logs.

```
mkdir -p /tmp/spark/logs
```

Build the latest version of Spark locally and add spark-submit to the PATH.

```
# clone spark from git
cd ~
git clone https://github.com/apache/spark.git
cd spark

# build spark
build/mvn -DskipTests clean package

# add spark bin to the PATH so spark-submit can be called from anywhere
export PATH=$PATH:~/spark/bin
```

Clone the repo.

```
cd ~
git clone https://github.com/maxmelnick/Spark-Performance---Cycle-Hire-Data.git
cd Spark-Performance---Cycle-Hire-Data
```



## Run the code in local mode

Spark-Submit on a local Spark instance, with a command as follows. Make sure there's at least 8g RAM and 6 cores available to Spark.

```
spark-submit   \
--class com.scottlogic.blog.analysis.BikeDataAnalysis \
--master local[*]   \
--executor-memory 4g   \
--num-executors 2 \
--conf spark.executor.instances=2   \
--total-executor-cores 6   \
spark-shuffle-performance-1.0-SNAPSHOT.jar   10000
```


## Analyze performance in the Spark UI

Open the Spark UI which is normally at http://<INSERT_HOSTNAME>:4040. Follow the details in the [blog post](https://matdeb-sl.github.io/blog/2018/03/20/apache-spark-performance.html) for more information on what to look for.


## Running on YARN

Alternatively it may be run on YARN by uncommenting line 19 in BikeDataAnalysis.java, and commenting line 18.

[Install Gradle](https://gradle.org/install/) to build the .jar.

> Here's an example install that worked on Centos 7:
> ```
> wget https://services.gradle.org/distributions/gradle-3.4.1-bin.zip
> sudo mkdir /opt/gradle
> sudo unzip -d /opt/gradle gradle-3.4.1-bin.zip
> export PATH=$PATH:/opt/gradle/gradle-3.4.1/bin
> gradle -v
> ```

From the root of the project, use Gradle to build the .jar.

```
gradle build
```

This will create the .jar in the build/libs folder.

```
cd build/libs
```

Run the code.

```
spark-submit   \
--class com.scottlogic.blog.analysis.BikeDataAnalysis \
--master yarn   \
--deploy-mode client  \
--executor-memory 4g   \
--num-executors 2 \
--conf spark.executor.instances=2   \
--total-executor-cores 6   \
spark-shuffle-performance-1.0-SNAPSHOT.jar   10000
```
