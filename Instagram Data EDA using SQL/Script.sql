CREATE DATABASE Instagram;

USE Instagram;

CREATE TABLE instagram_data (
    Post_ID VARCHAR(255),
    Account_ID VARCHAR(255),
    Account_username VARCHAR(255),
    Account_name VARCHAR(255),
    Description TEXT,
    Duration_secs INT,
    Publish_time DATETIME,
    Permalink VARCHAR(255),
    Post_type VARCHAR(255),
    Data_comment VARCHAR(255),
    Date VARCHAR(50),
    Impressions INT,
    Reach INT,
    Likes INT,
    Shares INT,
    Follows INT,
    Comments INT,
    Saves INT,
    Plays INT
);

LOAD DATA INFILE '"G:\Projects\02-SQL-Data-Analysis-Project\Instagram_Data EDA using SQL\Instagram_Data.csv"'
INTO TABLE instagram_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Post_ID, Account_ID, Account_username, Account_name, Description, Duration_secs, Publish_time, 
Permalink, Post_type, Data_comment, Date, Impressions, Reach, Likes, Shares, Follows, Comments, Saves, Plays);


-- 1.What does the dataset look like, and what columns are available?
SELECT * 
FROM instagram_data 
LIMIT 5;

-- 2.How many posts are there, and what are the average impressions, maximum likes, and minimum likes?
SELECT COUNT(*) AS Total_Post,
       AVG(Impressions) AS Avg_Impression,
       MAX(Likes) AS Max_Likes,
       MIN(Likes) AS Min_Likes
FROM instagram_data;


-- 3.Which columns have missing values, and how many rows are affected?
SELECT COUNT(*) AS Total_Rows,
	   SUM(CASE WHEN Plays IS NULL THEN 1 ELSE 0 END) AS Missing_Plays,
	   SUM(CASE WHEN Data_comment IS NULL THEN 1 ELSE 0 END) AS Missing_Data_Comment
FROM instagram_data;

-- 4.What is the frequency distribution of post types, and which performs best in terms of engagement?
SELECT 
    Post_type, 
    COUNT(*) AS Frequency
FROM instagram_data
GROUP BY Post_type;

-- 5.What is the ratio of likes and saves to impressions for each post?
SELECT 
    Post_ID,
    Likes / NULLIF(Impressions, 0) AS Likes_Per_Impression,
    Saves / NULLIF(Impressions, 0) AS Saves_Per_Impression
FROM instagram_data
LIMIT 5;

-- 6. How do total impressions and likes vary by date, and which days perform best?
SELECT 
    DATE(Publish_time) AS Date,
    SUM(Impressions) AS Total_Impressions,
    SUM(Likes) AS Total_Likes
FROM instagram_data
GROUP BY DATE(Publish_time)
ORDER BY Date ASC;

-- 7.Are there any posts with impressions significantly higher or lower than the average?
SELECT * 
FROM instagram_data
WHERE Impressions > (
    SELECT AVG(Impressions) + 2 * STDDEV(Impressions) FROM instagram_data
) 
OR Impressions < (
    SELECT AVG(Impressions) - 2 * STDDEV(Impressions) FROM instagram_data
);
