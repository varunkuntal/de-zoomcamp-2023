import requests
import tempfile
import logging
from google.cloud import bigquery

def hello_world(request):
    #project_id = 'de-zoomcap-project'
    #dataset_id = 'de-zoomcap-project.dezoomcamp'
    table_id = 'de-zoomcap-project.dezoomcamp.fhv-2019-varun'

    # Create a new BigQuery client
    client = bigquery.Client()


    for month in range(4, 13):
        # Define the schema for the data in the CSV.gz files
        url = 'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/fhv/fhv_tripdata_2019-{:02d}.csv.gz'.format(month)

        # Download the CSV.gz file from Github
        response = requests.get(url)

        write_disposition_string = "WRITE_APPEND" if month > 1 else "WRITE_TRUNCATE"

        job_config = bigquery.LoadJobConfig(
                schema=[
                    bigquery.SchemaField("dispatching_base_num", "STRING"),
                    bigquery.SchemaField("pickup_datetime", "TIMESTAMP"),
                    bigquery.SchemaField("dropOff_datetime", "TIMESTAMP"),
                    bigquery.SchemaField("PUlocationID", "STRING"),
                    bigquery.SchemaField("DOlocationID", "STRING"),
                    bigquery.SchemaField("SR_Flag", "STRING"),
                    bigquery.SchemaField("Affiliated_base_number", "STRING"),
                ],
                    skip_leading_rows=1,
                    write_disposition=write_disposition_string,
                    autodetect=True,
                    source_format="CSV",
                )

        # Load the data into BigQuery
        with tempfile.NamedTemporaryFile() as f:
            f.write(response.content)
            f.seek(0)

            job = client.load_table_from_file(
                f,
                table_id,
                location="US",
                job_config=job_config,
            )
            job.result()
            logging.info("Data for month %d successfully loaded into table %s.", month, table_id)


    return 'Data loaded into table {}.'.format(table_id)