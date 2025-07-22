param(
  [string]$NotebookPath = "delta_sync.py",
  [string]$PySparkHome  = "C:\Spark\spark-3.3.2-bin-hadoop3"
)

# Run the delta_sync script via spark-submit
& "$PySparkHome\bin\spark-submit" --master yarn `
    --conf spark.delta.logStore.class=org.apache.spark.sql.delta.storage.AzureLogStore `
    $NotebookPath
