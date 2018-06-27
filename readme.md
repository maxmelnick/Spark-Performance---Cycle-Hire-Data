# Spark Performance Analysis Example
This project splits the London Cycle Hire Data into two subsets, Weekend Journeys and Weekday Journeys, and saves the result as Parquet. This action is implemented twice, both in a slow and quick fashion, as discussed in this [blog post](https://matdeb-sl.github.io/blog/2018/03/22/apache-spark-performance.html), and will produce ~2GB of output data.

## Dependencies

* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/installing.html) installed.
* Enough space for the data and code files ~5GB
* Machine with at least 8g RAM and 6 cores available
* Tested on Centos 7. Use at your own risk otherwise.


## Run the code

`run.sh` is a utility script that...

1) Downloads the data
2) Builds Spark from source
3) Spark-Submits the code

```
./run.sh
```


## Analyze performance in the Spark UI

Open the Spark UI which is normally at http://<INSERT_HOSTNAME>:4040. Follow the details in the [blog post](https://matdeb-sl.github.io/blog/2018/03/22/apache-spark-performance.html) for more information on what to look for.