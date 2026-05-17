-- ============================================================
-- Cyclistic Bike-Share Analysis — 2022
-- Author: Krupal Patel
-- Tool: Google BigQuery (Standard SQL)
-- Description: Full analysis of Cyclistic trip data to compare
--              casual riders vs. annual members
-- ============================================================


-- ============================================================
-- STEP 1: MERGE MONTHLY DATA INTO QUARTERLY TABLES
-- ============================================================

-- Q1 2022 (January – March)
CREATE TABLE my-project-krupal3972.tripdata.Q1_2022 AS
SELECT * FROM my-project-krupal3972.tripdata.202201_tripdata
UNION DISTINCT
SELECT * FROM my-project-krupal3972.tripdata.202202_tripdata
UNION DISTINCT
SELECT * FROM my-project-krupal3972.tripdata.202203_tripdata;

-- Q2 2022 (April – June)
CREATE TABLE my-project-krupal3972.tripdata.Q2_2022 AS
SELECT * FROM my-project-krupal3972.tripdata.202204_tripdata
UNION DISTINCT
SELECT * FROM my-project-krupal3972.tripdata.202205_tripdata
UNION DISTINCT
SELECT * FROM my-project-krupal3972.tripdata.202206_tripdata;

-- Q3 2022 (July – September)
CREATE TABLE my-project-krupal3972.tripdata.Q3_2022 AS
SELECT * FROM my-project-krupal3972.tripdata.202207_tripdata
UNION DISTINCT
SELECT * FROM my-project-krupal3972.tripdata.202208_tripdata
UNION DISTINCT
SELECT * FROM my-project-krupal3972.tripdata.202209_tripdata;

-- Q4 2022 (October – December)
CREATE TABLE my-project-krupal3972.tripdata.Q4_2022 AS
SELECT * FROM my-project-krupal3972.tripdata.202210_tripdata
UNION DISTINCT
SELECT * FROM my-project-krupal3972.tripdata.202211_tripdata
UNION DISTINCT
SELECT * FROM my-project-krupal3972.tripdata.202212_tripdata;

-- Full Year Table
CREATE TABLE my-project-krupal3972.trip_data.whole_year AS
SELECT * FROM my-project-krupal3972.trip_data.Q1_2022
UNION DISTINCT
SELECT * FROM my-project-krupal3972.trip_data.Q2_2022
UNION DISTINCT
SELECT * FROM my-project-krupal3972.trip_data.Q3_2022
UNION DISTINCT
SELECT * FROM my-project-krupal3972.trip_data.Q4_2022;


-- ============================================================
-- STEP 2: RIDES PER MONTH BY MEMBER TYPE
-- ============================================================

SELECT
  EXTRACT(MONTH FROM started_at) AS month,
  member_casual,
  COUNT(*) AS rides_per_month
FROM my-project-krupal3972.trip_data.whole_year
GROUP BY month, member_casual
ORDER BY month;


-- ============================================================
-- STEP 3: RIDES PER QUARTER
-- ============================================================

SELECT
  EXTRACT(QUARTER FROM started_at) AS quarter,
  COUNT(*) AS trips_per_quarter
FROM my-project-krupal3972.trip_data.whole_year
GROUP BY quarter
ORDER BY quarter;


-- ============================================================
-- STEP 4: PERCENTAGE OF TOTAL RIDES BY MEMBER TYPE (FULL YEAR)
-- ============================================================

WITH cte AS (
  SELECT CAST(COUNT(ride_id) AS FLOAT64) AS total_num
  FROM my-project-krupal3972.trip_data.whole_year
)
SELECT
  member_casual,
  CASE
    WHEN member_casual = 'member' THEN ROUND(CAST((COUNT(*) / total_num) * 100 AS NUMERIC), 2)
    WHEN member_casual = 'casual' THEN ROUND(CAST((COUNT(*) / total_num) * 100 AS NUMERIC), 2)
  END AS percentage_of_total_rides_all_year
FROM my-project-krupal3972.trip_data.whole_year, cte
GROUP BY member_casual, cte.total_num;


-- ============================================================
-- STEP 5: PERCENTAGE OF RIDES BY MEMBER TYPE PER QUARTER
-- ============================================================

-- Repeat this query substituting Q1_2022, Q2_2022, Q3_2022, Q4_2022

WITH cte AS (
  SELECT CAST(COUNT(ride_id) AS FLOAT64) AS total_num
  FROM my-project-krupal3972.trip_data.Q1_2022  -- Change quarter here
)
SELECT
  member_casual,
  ROUND(CAST((COUNT(*) / total_num) * 100 AS NUMERIC), 2) AS percentage_of_rides
FROM my-project-krupal3972.trip_data.Q1_2022, cte  -- Change quarter here
GROUP BY member_casual, cte.total_num;


-- ============================================================
-- STEP 6: RIDE FREQUENCY BY WEEKDAY AND MEMBER TYPE
-- ============================================================

SELECT
  member_casual,
  week_day,
  CASE
    WHEN member_casual = 'member' THEN COUNT(*)
    WHEN member_casual = 'casual' THEN COUNT(*)
  END AS week_day_count
FROM my-project-krupal3972.trip_data.whole_year
GROUP BY member_casual, week_day
ORDER BY member_casual, week_day_count DESC;


-- ============================================================
-- STEP 7: DAY WITH MAXIMUM RIDE FREQUENCY
-- ============================================================

WITH cte AS (
  SELECT COUNT(week_day) AS frequency
  FROM my-project-krupal3972.trip_data.whole_year
  GROUP BY week_day
)
SELECT MAX(frequency) AS max_rides_in_a_day
FROM cte;
-- Result: Sunday with 605,010 rides


-- ============================================================
-- STEP 8: TOP 3 END STATIONS BY MEMBER TYPE
-- ============================================================

WITH cte AS (
  SELECT
    member_casual,
    end_station_name,
    CASE
      WHEN member_casual = 'casual' THEN
        DENSE_RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(end_station_name) DESC)
      WHEN member_casual = 'member' THEN
        DENSE_RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(end_station_name) DESC)
    END AS rank
  FROM my-project-krupal3972.trip_data.whole_year
  WHERE end_station_name IS NOT NULL
  GROUP BY end_station_name, member_casual
)
SELECT *
FROM cte
WHERE rank <= 3
ORDER BY member_casual, rank;


-- ============================================================
-- STEP 9: TOP 3 START STATIONS BY MEMBER TYPE
-- ============================================================

WITH cte AS (
  SELECT
    member_casual,
    start_station_name,
    CASE
      WHEN member_casual = 'casual' THEN
        DENSE_RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(start_station_name) DESC)
      WHEN member_casual = 'member' THEN
        DENSE_RANK() OVER(PARTITION BY member_casual ORDER BY COUNT(start_station_name) DESC)
    END AS rank
  FROM my-project-krupal3972.trip_data.whole_year
  WHERE start_station_name IS NOT NULL
  GROUP BY start_station_name, member_casual
)
SELECT *
FROM cte
WHERE rank <= 3
ORDER BY member_casual, rank;


-- ============================================================
-- STEP 10: BIKE TYPE USAGE PER QUARTER BY MEMBER TYPE
-- ============================================================

SELECT
  rideable_type,
  member_casual,
  EXTRACT(QUARTER FROM started_at) AS quarter,
  COUNT(*) AS total_rides
FROM my-project-krupal3972.trip_data.whole_year
GROUP BY quarter, rideable_type, member_casual
ORDER BY quarter;


-- ============================================================
-- STEP 11: PERCENTAGE OF RIDES BY BIKE TYPE (FULL YEAR)
-- ============================================================

WITH cte AS (
  SELECT CAST(COUNT(ride_id) AS FLOAT64) AS total_num
  FROM my-project-krupal3972.trip_data.whole_year
)
SELECT
  rideable_type,
  CASE
    WHEN rideable_type = 'electric_bike' THEN ROUND(CAST((COUNT(*) / total_num) * 100 AS NUMERIC), 2)
    WHEN rideable_type = 'docked_bike'   THEN ROUND(CAST((COUNT(*) / total_num) * 100 AS NUMERIC), 2)
    WHEN rideable_type = 'classic_bike'  THEN ROUND(CAST((COUNT(*) / total_num) * 100 AS NUMERIC), 2)
  END AS percentage_of_total_rides_all_year
FROM my-project-krupal3972.trip_data.whole_year, cte
GROUP BY rideable_type, cte.total_num;


-- ============================================================
-- STEP 12: AVERAGE RIDE LENGTH BY MEMBER TYPE
-- ============================================================

SELECT
  member_casual,
  AVG(ended_at - started_at) AS average_ride_length
FROM my-project-krupal3972.trip_data.whole_year
GROUP BY member_casual;
-- Result:
--   Casual: 23 min 58 sec
--   Member: 12 min 26 sec


-- ============================================================
-- STEP 13: MAXIMUM RIDE LENGTH
-- ============================================================

SELECT MAX(travel_time) AS maximum_ride_length
FROM my-project-krupal3972.trip_data.whole_year;
-- Result: 23:58:35
