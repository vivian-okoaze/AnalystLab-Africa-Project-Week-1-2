--Preview the Dataset
SELECT * FROM [Netflix_titles dataset]
SELECT  TOP 10 *
FROM [netflix_titles dataset]

--Row Count Query
SELECT COUNT (*) AS Total_Rows
FROM [netflix_titles dataset]

--Column Information
SELECT COLUMN_NAME,DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'netflix_titles dataset'

--Identification of Primary Key
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT show_id) AS unique_show_id
FROM [netflix_titles dataset]

-- Data Cleaning
--Check for Duplicates
SELECT title, type, COUNT(*) AS cnt
FROM [netflix_titles dataset]
GROUP BY title, type
HAVING COUNT(*) > 1
ORDER BY cnt DESC

--Check for Missing Values
SELECT
    COUNT(*) AS total_rows,
    SUM(CASE WHEN show_id IS NULL THEN 1 ELSE 0 END) AS null_show_id,
    SUM(CASE WHEN type IS NULL THEN 1 ELSE 0 END) AS null_type,
    SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS null_title,
    SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS null_director,
    SUM(CASE WHEN cast IS NULL THEN 1 ELSE 0 END) AS null_cast,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_country,
    SUM(CASE WHEN date_added   IS NULL THEN 1 ELSE 0 END) AS null_date_added,
    SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) AS null_release_year,
    SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) AS null_rating,
    SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS null_duration,
    SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) AS null_listed_in,
    SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) AS null_description
FROM [netflix_titles dataset]

--Investigation
-- Are most missing directors from TV Shows?
SELECT type,
    COUNT(*) AS total,
    SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) AS null_director,
    ROUND(100.0 * SUM(CASE WHEN director IS NULL THEN 1 ELSE 0 END) 
          / COUNT(*), 2) AS pct_null
FROM [netflix_titles dataset]
GROUP BY type

-- Check the 3 rows with missing duration
SELECT *
FROM [netflix_titles dataset]
WHERE duration IS NULL

-- Check distinct ratings
SELECT rating, COUNT(*) AS cnt
FROM [netflix_titles dataset]
GROUP BY rating
ORDER BY cnt DESC

-- Check duration format consistency
SELECT DISTINCT
    CASE 
        WHEN duration LIKE '%min%' THEN 'Minutes (Movie)'
        WHEN duration LIKE '%Season%' THEN 'Seasons (TV Show)'
        ELSE 'Unknown format'
    END AS duration_format,
    COUNT(*) AS cnt
FROM [netflix_titles dataset]
GROUP BY 
    CASE 
        WHEN duration LIKE '%min%' THEN 'Minutes (Movie)'
        WHEN duration LIKE '%Season%' THEN 'Seasons (TV Show)'
        ELSE 'Unknown format'
    END

--Build Clean View
CREATE VIEW vw_netflix_clean AS
SELECT
    show_id,
    LTRIM(RTRIM(type))                                        AS type,
    LTRIM(RTRIM(title))                                       AS title,
    ISNULL(NULLIF(LTRIM(RTRIM(director)),''), 'Not Listed')   AS director,
    ISNULL(NULLIF(LTRIM(RTRIM(cast)),''),     'Not Listed')   AS cast,
    ISNULL(NULLIF(LTRIM(RTRIM(country)),''),  'Unknown')      AS country,
    ISNULL(NULLIF(LTRIM(RTRIM(date_added)),''),'Unknown')     AS date_added,
    release_year,
    ISNULL(NULLIF(LTRIM(RTRIM(rating)),''),   'Not Rated')    AS rating,
    ISNULL(NULLIF(LTRIM(RTRIM(duration)),''), 'Not Available') AS duration,
    LTRIM(RTRIM(listed_in))                                   AS listed_in,
    LTRIM(RTRIM(description))                                 AS description
FROM [netflix_titles dataset]
WHERE show_id IS NOT NULL
  AND title   IS NOT NULL
  AND type    IS NOT NULL

-- Verify cleaned view
SELECT COUNT(*) AS clean_rows FROM vw_netflix_clean

-- Save as permanent table
SELECT * INTO netflix_clean 
FROM vw_netflix_clean

SELECT COUNT(*) AS saved_rows FROM netflix_clean
select * from vw_netflix_clean

--Exploratory Data Analysis

SELECT MAX(release_year) AS Highest_year
FROM vw_netflix_clean


SELECT MIN(release_year) AS Lowest_year
FROM vw_netflix_clean

SELECT COUNT(show_id) AS Total_Showid
FROM vw_netflix_clean

-- 1. Movies vs TV Shows distribution
SELECT type,
    COUNT(*)                                              AS total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2)    AS percentage
FROM netflix_clean
GROUP BY type

-- 2. Content Added by Year
SELECT
    YEAR(TRY_CAST(date_added AS DATE))                    AS year_added,
    COUNT(*)                                              AS titles_added,
    SUM(CASE WHEN type = 'Movie'   THEN 1 ELSE 0 END)    AS movies,
    SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END)    AS tv_shows
FROM netflix_clean
WHERE TRY_CAST(date_added AS DATE) IS NOT NULL
GROUP BY YEAR(TRY_CAST(date_added AS DATE))
ORDER BY year_added

-- 3. Top Content Producing Countries
SELECT country,
    COUNT(*) AS total_titles,
    SUM(CASE WHEN type = 'Movie'   THEN 1 ELSE 0 END)    AS movies,
    SUM(CASE WHEN type = 'TV Show' THEN 1 ELSE 0 END)    AS tv_shows
FROM netflix_clean
WHERE country != 'Unknown'
GROUP BY country
ORDER BY total_titles DESC

-- 4. Most Common Ratings
SELECT
    rating,
    COUNT(*)                                              AS total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2)    AS percentage
FROM netflix_clean
GROUP BY rating
ORDER BY total DESC

-- 5. Most Common Genres
SELECT TOP 10
    listed_in,
    COUNT(*) AS total,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2)    AS percentage
FROM netflix_clean
GROUP BY listed_in
ORDER BY total DESC




