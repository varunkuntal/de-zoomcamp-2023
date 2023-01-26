-- Week 1 Homework SQL Queries
-- Question 3 (SQL Question # 1): How many taxi trips were totally made on January 15?
SELECT 
	COUNT(*) AS total_trips_on_2019_01_15
FROM green_taxi_trips
WHERE DATE(lpep_pickup_datetime) = '2019-01-15'
AND DATE(lpep_dropoff_datetime) = '2019-01-15'

-- Question 4: Which was the day with the largest trip distance
SELECT DATE(lpep_pickup_datetime) FROM green_taxi_trips
WHERE trip_distance = (SELECT MAX(trip_distance) FROM green_taxi_trips)

-- Question 5: In 2019-01-01 how many trips had 2 and 3 passengers?
SELECT 
	SUM(CASE WHEN passenger_count = 2 THEN 1 ELSE 0 END) AS Two_passengers,
	SUM(CASE WHEN passenger_count = 3 THEN 1 ELSE 0 END) AS Three_passengers
FROM green_taxi_trips
WHERE DATE(lpep_pickup_datetime) = '2019-01-01'

-- Question 6: For the passengers picked up in the Astoria Zone which was the drop off zone that had the largest tip?
WITH astoria_puzone_tips AS
(SELECT gtt."PULocationID",
	tzl."Zone" AS PUZone,
	gtt."DOLocationID",
	tzla."Zone" AS DOZone,
	gtt.tip_amount
FROM public.green_taxi_trips AS gtt, public.taxi_zone_lookup AS tzl, public.taxi_zone_lookup AS tzla
WHERE gtt."PULocationID" = tzl."LocationID"
AND gtt."DOLocationID" = tzla."LocationID"
AND tzl."Zone" = 'Astoria')

SELECT
	* 
FROM astoria_puzone_tips
WHERE tip_amount = (SELECT MAX(tip_amount) FROM astoria_puzone_tips) 
