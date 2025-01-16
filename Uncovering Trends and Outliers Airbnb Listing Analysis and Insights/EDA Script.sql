-- Create Database 
CREATE DATABASE AIRBNB;

USE AIRBNB;

-- Create Table
CREATE TABLE airbnb_data (
    CITY VARCHAR(20),
    PRICE DECIMAL(10, 4),
    DAY VARCHAR(8),
    ROOM_TYPE VARCHAR(20),
    SHARED_ROOM TINYINT,
    PRIVATE_ROOM TINYINT,
    PERSON_CAPACITY INT,
    SUPERHOST TINYINT,
    MULTIPLE_ROOMS TINYINT,
    BUSINESS TINYINT,
    CLEANLINESS_RATING DECIMAL(10, 4),
    GUEST_SATISFACTION INT,
    BEDROOMS INT,
    CITY_CENTER_KM DECIMAL(8, 4),
    METRO_DISTANCE_KM DECIMAL(8, 4),
    ATTRACTION_INDEX DECIMAL(10, 4),
    NORMALISED_ATTRACTION_INDEX DECIMAL(8, 4),
    RESTAURANT_INDEX DECIMAL(10, 4),
    NORMALISED_RESTAURANT_INDEX DECIMAL(8, 4)
);

-- Loading Data
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Airbnb Europe Dataset.csv'
INTO TABLE airbnb_data
FIELDS TERMINATED BY ',' 
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(CITY, PRICE, DAY, ROOM_TYPE, @shared_room, @private_room, PERSON_CAPACITY, 
 @superhost, MULTIPLE_ROOMS, BUSINESS, CLEANLINESS_RATING, GUEST_SATISFACTION, 
 BEDROOMS, CITY_CENTER_KM, METRO_DISTANCE_KM, ATTRACTION_INDEX, NORMALISED_ATTRACTION_INDEX, 
 RESTAURANT_INDEX, NORMALISED_RESTAURANT_INDEX)
SET 
    SHARED_ROOM = IF(@shared_room = 'TRUE', 1, 0),
    PRIVATE_ROOM = IF(@private_room = 'TRUE', 1, 0),
    SUPERHOST = IF(@superhost = 'TRUE', 1, 0);
    
    
SELECT * FROM airbnb_data
LIMIT 5;


-- 1. How many records are there in the dataset?
SELECT COUNT(*) AS no_of_records
FROM airbnb_data;

-- 2. How many unique cities are in the European dataset?
SELECT COUNT(DISTINCT CITY) AS cities
FROM airbnb_data;

--  What are the names of the cities in the dataset?
SELECT DISTINCT CITY AS cities
FROM airbnb_data;

-- 4 How many bookings are there in each city?
SELECT city, COUNT(city) AS Number_OF_Booking
FROM airbnb_data
GROUP BY city
ORDER BY 2 DESC; 

-- 5 What is the total booking revenue for each city?
SELECT CITY, ROUND(SUM(PRICE)) AS total_booking_revenue
FROM airbnb_data
GROUP BY CITY
ORDER BY 2 DESC;

-- 6  What is the average guest satisfaction score for each city?
SELECT CITY, ROUND(AVG(GUEST_SATISFACTION),1) AS avg_guest_satisfication
FROM airbnb_data
GROUP BY CITY
ORDER BY 2 DESC;

-- 7 What are the minimum, maximum, average, and median booking prices

-- MINIMUM PRICE
SELECT ROUND(MIN(PRICE),2) AS min_price 
FROM airbnb_data;

-- MAXIMUM PRICE 
SELECT ROUND(MAX(PRICE),2) AS max_price 
FROM airbnb_data;

-- AVERAGE PRICE
SELECT ROUND(AVG(PRICE),2) AS avg_price
FROM airbnb_data;

-- MEDIAN PRICE
WITH CTE_1 AS(
SELECT PRICE,
	   NTILE(2) OVER (ORDER BY PRICE) AS price_group
FROM airbnb_data
)
SELECT ROUND(AVG(PRICE), 2) AS median
FROM CTE_1
WHERE price_group = 1 OR price_group = 2;

-- 8 How many outliers are there in the price field?
WITH cte1 AS (
SELECT PRICE,
           NTILE(4) OVER (ORDER BY PRICE) AS quartile
FROM airbnb_data
),
cte2 AS (
SELECT 
        MAX(CASE WHEN quartile = 1 THEN PRICE END) AS Q1,
        MAX(CASE WHEN quartile = 3 THEN PRICE END) AS Q3
FROM cte1
),
cte3 AS (
SELECT 
        Q1,
        Q3,
        (Q3 - Q1) AS IQR,
        Q1 - 1.5 * (Q3 - Q1) AS lower_bound,
        Q3 + 1.5 * (Q3 - Q1) AS upper_bound
FROM cte2
)
SELECT 
    COUNT(*) AS outliers
FROM airbnb_data, cte3
WHERE PRICE < lower_bound OR PRICE > upper_bound;


-- 9. What are the characteristics of the outliers in terms of room type, number of bookings, and price?
WITH cte1 AS (
SELECT PRICE,
           NTILE(4) OVER (ORDER BY PRICE) AS quartile,
           ROOM_TYPE
FROM airbnb_data
),
cte2 AS (
SELECT 
        MAX(CASE WHEN quartile = 1 THEN PRICE END) AS Q1,
        MAX(CASE WHEN quartile = 3 THEN PRICE END) AS Q3
FROM cte1
),
cte3 AS (
SELECT 
        Q1,
        Q3,
        (Q3 - Q1) AS IQR,
        Q1 - 1.5 * (Q3 - Q1) AS lower_bound,
        Q3 + 1.5 * (Q3 - Q1) AS upper_bound
FROM cte2
),
outliers AS (
SELECT 
        ROOM_TYPE,
        PRICE
FROM airbnb_data, cte3
WHERE PRICE < lower_bound OR PRICE > upper_bound
)
SELECT 
   ROOM_TYPE AS "Room_Type",
    COUNT(*) AS "No_Of_Booking", 
    ROUND(MIN(PRICE), 1) AS "minimun_outlier_price",
    ROUND(MAX(PRICE), 1) AS "maximum_outlier_price",
    ROUND(AVG(PRICE), 1) AS "average_outlier_price"
FROM outliers
GROUP BY ROOM_TYPE;


-- 10. How does the average price differ between the main dataset and the dataset with outliers removed?
CREATE OR REPLACE VIEW CLEANED_AIRBNB_DATA AS
(
    WITH PRICE_QUARTILES AS (
        SELECT 
            PRICE,
            NTILE(4) OVER (ORDER BY PRICE) AS quartile
        FROM AIRBNB_DATA
    ),
    FIVE_NUMBER_SUMMARY AS (
        SELECT
            MAX(CASE WHEN quartile = 1 THEN PRICE END) AS Q1,
            MAX(CASE WHEN quartile = 2 THEN PRICE END) AS MEDIAN,
            MAX(CASE WHEN quartile = 3 THEN PRICE END) AS Q3
        FROM PRICE_QUARTILES
    ),
    HINGES AS (
        SELECT 
            Q1, 
            Q3,
            (Q3 - Q1) AS IQR,
            (Q1 - 1.5 * (Q3 - Q1)) AS LOWER_HINGE,
            (Q3 + 1.5 * (Q3 - Q1)) AS UPPER_HINGE
        FROM FIVE_NUMBER_SUMMARY
    )
    -- Select rows where prices are within the bounds to form the cleaned dataset
    SELECT 
        *
    FROM AIRBNB_DATA
    WHERE PRICE >= (SELECT LOWER_HINGE FROM HINGES) 
      AND PRICE <= (SELECT UPPER_HINGE FROM HINGES)
);

SELECT 
    'Original Data' AS DATASET,
    ROUND(AVG(PRICE), 2) AS AVG_PRICE
FROM AIRBNB_DATA
UNION ALL
SELECT 
    'Cleaned Data' AS DATASET,
    ROUND(AVG(PRICE), 2) AS AVG_PRICE
FROM CLEANED_AIRBNB_DATA;


-- 11.  What is the average price for each room type?
SELECT ROOM_TYPE, ROUND(AVG(price), 1) AS average_price
FROM airbnb_data
GROUP BY ROOM_TYPE
ORDER BY 2 DESC;


-- 12. How do weekend and weekday bookings compare in terms of average price and number of bookings?
SELECT 
    DAY AS Day_Type,                           
    ROUND(AVG(PRICE), 0) AS Avg_Price,       
    COUNT(ROOM_TYPE) AS Num_Of_Booking
FROM cleaned_airbnb_data                                    
GROUP BY DAY;


-- 13. What is the average distance from metro and city center for each city?
SELECT 
    CITY,
    ROUND(AVG(METRO_DISTANCE_KM), 2) AS AVG_METRO_DISTANCE_KM,
    ROUND(AVG(CITY_CENTER_KM), 2) AS AVG_CITY_CENTER_KM
FROM airbnb_data
GROUP BY CITY;


-- 14. How many bookings are there for each room type on weekdays vs weekends? 
SELECT 
    CASE 
        WHEN DAY IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 'Weekday'
        ELSE 'Weekend'
    END AS DAY_TYPE,
    ROOM_TYPE,
    COUNT(*) AS NUMBER_OF_BOOKINGS
FROM AIRBNB_DATA
GROUP BY DAY_TYPE, ROOM_TYPE
ORDER BY DAY_TYPE, ROOM_TYPE;


-- 15. What is the booking revenue for each room type on weekdays vs weekends?
SELECT 
    CASE 
        WHEN DAY IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday') THEN 'Weekday'
        ELSE 'Weekend'
    END AS DAY_TYPE,
    ROOM_TYPE,
    ROUND(SUM(PRICE), 2) AS TOTAL_REVENUE
FROM AIRBNB_DATA
GROUP BY DAY_TYPE, ROOM_TYPE
ORDER BY DAY_TYPE, ROOM_TYPE;


-- 16. What is the overall average, minimum, and maximum guest satisfaction score?
SELECT 
    ROUND(AVG(GUEST_SATISFACTION), 2) AS AVG_GUEST_SATISFACTION,
    MIN(GUEST_SATISFACTION) AS MIN_GUEST_SATISFACTION,
    MAX(GUEST_SATISFACTION) AS MAX_GUEST_SATISFACTION
FROM airbnb_data;


-- 17. How does guest satisfaction score vary by city?
SELECT 
    CITY,
    ROUND(AVG(GUEST_SATISFACTION), 2) AS AVG_GUEST_SATISFACTION,
    MIN(GUEST_SATISFACTION) AS MIN_GUEST_SATISFACTION,
    MAX(GUEST_SATISFACTION) AS MAX_GUEST_SATISFACTION
FROM AIRBNB_DATA
GROUP BY CITY
ORDER BY  AVG_GUEST_SATISFACTION DESC;

-- 18 What is the average booking value across all cleaned data?
SELECT 
    ROUND(AVG(PRICE), 2) AS AVG_BOOKING_VALUE
FROM CLEANED_AIRBNB_DATA;


-- 19. What is the average cleanliness score across all cleaned data?
SELECT 
    ROUND(AVG(CLEANLINESS_RATING), 2) AS AVG_CLEANLINESS_SCORE
FROM CLEANED_AIRBNB_DATA;


-- 20  How do cities rank in terms of total revenue?
WITH CTE1 AS (
SELECT 
        CITY,
        SUM(PRICE) AS TOTAL_REVENUE
FROM AIRBNB_DATA
GROUP BY CITY
)
SELECT 
    CITY,
    TOTAL_REVENUE,
    ROW_NUMBER() OVER (ORDER BY TOTAL_REVENUE DESC) AS REVENUE_RANK
FROM CTE1
ORDER BY REVENUE_RANK;