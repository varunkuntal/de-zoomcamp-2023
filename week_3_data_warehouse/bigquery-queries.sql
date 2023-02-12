SELECT COUNT(DISTINCT affiliated_base_number) FROM `de-zoomcap-project.dezoomcamp.fhv-2019-varun`;

SELECT COUNT(*) FROM `de-zoomcap-project.dezoomcamp.fhv-2019-varun` 
WHERE PUlocationID IS NULL AND DOlocationID IS NULL;


SELECT DISTINCT affiliated_base_number
FROM `de-zoomcap-project.dezoomcamp.fhv-2019-varun`
WHERE DATE(pickup_datetime) >= '2019-03-01' AND
DATE(pickup_datetime) < '2019-04-01';


CREATE TABLE `de-zoomcap-project.dezoomcamp.fhv-2019-varun-pc`
PARTITION BY DATE(pickup_datetime)
CLUSTER BY affiliated_base_number
AS
SELECT *
FROM `de-zoomcap-project.dezoomcamp.fhv-2019-varun`;

SELECT DISTINCT affiliated_base_number
FROM `de-zoomcap-project.dezoomcamp.fhv-2019-varun-pc`
WHERE DATE(pickup_datetime) >= '2019-03-01' AND
DATE(pickup_datetime) < '2019-04-01';