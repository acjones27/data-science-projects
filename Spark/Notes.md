## Spark meetup (Ironhack)

[slack link](slack-sparkbcn.herokuapp.com)

5th September
Letgo - Self-service data platforms with Spark, Kafka & Avro

### What is spark
Cluster Computing

Structured APIs
- Datasets
- DataFrames
- SQL

### How it works

Driver and workers
Cluster manager - e.g. yarn, kubernetes - manager of memory etc
Split data in partitions and divide between workers
Communication between driver and workers and between workers
Sends commands/operations to workers

### SparkSession
It's a Unit or a function e.g. write, read
Instruction to create

Hive - distributed DB - can do spark.sql("select * from ...")
spark.read.csv(...).load()


### Operations
Transformations
- Narrow (isolated)
- Wide (network communication between workers)
All Transformations in spark are lazy (don't execute until Action)

Actions
- Return a value to the Driver
E.g. Read, groupby, sum, sort, limit are Transformations
Collect is the Actions

### First Spark Application
[Github](https://github.com/marcraminv/spark-introduction-meetup)
Click the *launch-binder* button in the Readme

Code can be found in spark_tutorial_ironhack.ipynb
