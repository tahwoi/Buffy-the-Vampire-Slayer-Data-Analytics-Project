/*
Date Created: 10/03/2024
Created By: Tutuwa Ahwoi
Description: Exploratory Data Analysis of Episodes of Buffy the Vampire Slayer
*/


-- Combined Result Set of All 4 Tables
SELECT e.episodeid,
    e.no_overall,
    e.title,
    e.season,
    e.episode_number,
    e.air_date,
    e.director,
    wr.writer_name,
    r.viewers,
    r.imdb_rating,
    r.imdb_votes
   FROM sunnydale.episodes e
     JOIN sunnydale.writers_episodes w ON w.episodeid = e.episodeid
     JOIN sunnydale.writers wr ON wr.writerid = w.writerid
     JOIN sunnydale.ratings r ON r.episodeid = e.episodeid;


--Part I: Episode Analysis
-- 1.1: Find the average rating of all episodes
SELECT
	ROUND(AVG(imdb_rating),2) as avg_rating
FROM sunnydale.ratings


-- 1.2: Find the top 10 highest-rated episodes
SELECT 
    e.episodeid, e.season, e.title, r.imdb_rating
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
ORDER BY r.imdb_rating DESC
LIMIT 10;

-- 1.3: Find the top 10 lowest-rated episodes
SELECT 
    e.episodeid, e.season, e.title, r.imdb_rating
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
ORDER BY r.imdb_rating ASC
LIMIT 10;


--1.4: Analyze the distribution of ratings
SELECT 
	FLOOR(r.imdb_rating) as rating_bracket, 
	COUNT(*) as episode_count
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
GROUP BY FLOOR(r.imdb_rating)
ORDER BY rating_bracket;

-- 1.5: Find the Highest and Lowest Rated Episodes per Season
WITH ranked_episodes AS (
    SELECT
        e.season,
		e.title,
        e.episodeid,
        r.imdb_rating,
        RANK() OVER (PARTITION BY e.season ORDER BY r.imdb_rating DESC) AS highest_rank,
        RANK() OVER (PARTITION BY e.season ORDER BY r.imdb_rating ASC) AS lowest_rank
    FROM sunnydale.episodes e
    INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
)
SELECT
    season,
    episodeid,
	title,
    imdb_rating,
    CASE WHEN highest_rank = 1 THEN 'Highest Rated'
         WHEN lowest_rank = 1 THEN 'Lowest Rated'
         ELSE 'Other' END AS episode_type
FROM ranked_episodes
WHERE highest_rank = 1 OR lowest_rank = 1;


-- 1.6: Find the top 10 most watched episodes 
SELECT 
  e.no_overall as episode_number, 
	e.season, 
	e.title, 
	r.viewers as us_viewers_millions
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
ORDER BY r.viewers DESC
LIMIT 10;


-- 1.7: Find the top 10 least  watched episodes 
SELECT 
  e.no_overall as episode_number, 
	e.season, 
	e.title, 
	r.viewers as us_viewers_millions
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
ORDER BY r.viewers ASC
LIMIT 10;


-- 1.8: Identify episodes with the most IMDB votes
SELECT
    e.episodeid,
    e.title,
    r.imdb_votes AS total_votes
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
ORDER BY total_votes DESC
LIMIT 10;

--Part II: Season Analysis
-- 2.1: Calculate the average rating for each season
SELECT 
    e.season, 
    ROUND(AVG(r.imdb_rating),2) as avg_rating
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
GROUP BY e.season
ORDER BY avg_rating DESC;


-- 2.2: Calculate the average rating for each season
SELECT
  e.season,
	ROUND(AVG(r.viewers),2) AS avg_viewership_us_millions
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
GROUP BY e.season
ORDER BY avg_viewership_us_millions DESC;


--2.3: Identify episodes with ratings significantly above or below the season average:
WITH season_avgs AS (
    SELECT e.season, ROUND(AVG(r.imdb_rating),2) as season_avg
    FROM sunnydale.episodes e
	INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
    GROUP BY season
	ORDER BY season
)
SELECT 
	e.title, 
	e.season, 
	e.episode_number, 
	r.imdb_rating, 
	sa.season_avg,
	ROUND((r.imdb_rating - sa.season_avg),2) AS rating_difference
FROM sunnydale.episodes e
INNER JOIN season_avgs sa ON e.season = sa.season
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
WHERE ABS(r.imdb_rating - sa.season_avg) > 1
ORDER BY ABS(r.imdb_rating - sa.season_avg) DESC;


--2.4: Calculate the moving average of ratings over a 5-episode window:
SELECT 
	e.season, 
	e.episode_number, 
	e.title, 
	r.imdb_rating,
	ROUND(AVG(imdb_rating) OVER (PARTITION BY e.season ORDER BY e.season, e.episode_number ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING),2) as moving_avg
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
ORDER BY e.season, e.episode_number;


--2.5: Calculate the moving average of U.S. viewership over a 5-episode window:
SELECT 
	e.season, 
	e.episode_number, 
	e.title, 
	r.viewers AS us_viewers_in_millions,
	ROUND(AVG(r.viewers) OVER (PARTITION BY e.season ORDER BY e.season, e.episode_number ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING),2) as moving_avg
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
ORDER BY e.season, e.episode_number;


-- 2.6: Correlation between viewership and IMDB ratings for each season
SELECT DISTINCT
    e.season,
    ROUND(AVG(r.imdb_rating) OVER (PARTITION BY e.season), 2) as avg_rating,
    ROUND(AVG(r.viewers) OVER (PARTITION BY e.season), 2) AS avg_viewership_us_millions,
    ROUND(CORR(r.imdb_rating, r.viewers) OVER (PARTITION BY e.season)::numeric, 2) AS episode_rating_correlation
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
ORDER BY e.season;

--2.7: Compare ratings of season premieres and finales
WITH last_episodes AS (
    SELECT
        season,
        MAX(episode_number) AS last_episode
    FROM sunnydale.episodes
    GROUP BY season
)
SELECT
    e.season,
    MAX(CASE WHEN e.episode_number = 1 THEN r.imdb_rating END) AS premiere_rating,
    MAX(CASE WHEN e.episode_number = le.last_episode THEN r.imdb_rating END) AS finale_rating
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
INNER JOIN last_episodes le ON e.season = le.season
GROUP BY e.season
ORDER BY e.season;


-- 2.8: Identify the highest rated episodes within each season
WITH highest_rated_episodes AS (
    SELECT
        e.season,
        e.episodeid,
				e.title,
        r.imdb_rating
    FROM sunnydale.episodes e
    INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
    ORDER BY e.season, r.imdb_rating DESC
)
SELECT
    hre.season,
    hre.episodeid,
		hre.title,
    hre.imdb_rating
FROM highest_rated_episodes hre
INNER JOIN (
    SELECT season, MAX(imdb_rating) AS max_rating
    FROM highest_rated_episodes
    GROUP BY season
) hre2 ON hre.season = hre2.season AND hre.imdb_rating = hre2.max_rating;

--PART III: Production Analysis

--3.1: Compare the average ratings of episodes written by Joss Whedon vs. other writers:
SELECT
    CASE 
		WHEN w.writer_name = 'Joss Whedon' THEN 'Joss Whedon' 
		ELSE 'Other Writers' 
	END as writer_group,
	ROUND(AVG(r.imdb_rating),2) as avg_rating
FROM sunnydale.episodes e
INNER JOIN sunnydale.writers_episodes we ON e.episodeid = we.episodeid
INNER JOIN sunnydale.writers w ON w.writerid = we.writerid
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
GROUP BY writer_group;


--3.2: Identify the most common episode directors and their average episode ratings:
SELECT 
	director, 
	COUNT(*) as episode_count, 
	ROUND(AVG(r.imdb_rating),2) as avg_rating
FROM sunnydale.episodes e
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
GROUP BY director
HAVING COUNT(*) > 5
ORDER BY avg_rating DESC;


-- 3.3: Identify Top 10 most prolific writers
SELECT
    w.writer_name,
    COUNT(*) AS episode_count,
    ROUND(AVG(r.imdb_rating), 2) AS avg_rating
FROM sunnydale.episodes e
INNER JOIN sunnydale.writers_episodes we ON e.episodeid = we.episodeid
INNER JOIN sunnydale.writers w ON w.writerid = we.writerid
INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
GROUP BY w.writer_name
ORDER BY episode_count DESC, avg_rating DESC
LIMIT 10;


-- 3.4: Find Episodes Written by Drew Goddard
SELECT
    e.season,
    e.episode_number,
    e.title
FROM sunnydale.episodes e
INNER JOIN sunnydale.writers_episodes we ON e.episodeid = we.episodeid
INNER JOIN sunnydale.writers w ON w.writerid = we.writerid
WHERE w.writer_name = 'Drew Goddard';

--Part IV: Complex Queries

-- 4.1: Find the Impact of the Big Bads
WITH big_bads AS (
    SELECT 1 AS season_number, 'The Master' AS big_bad UNION ALL
    SELECT 2, 'Spike and Drusilla' UNION ALL
    SELECT 3, 'Mayor Richard Wilkins' UNION ALL
    SELECT 4, 'Adam' UNION ALL
    SELECT 5, 'Glory' UNION ALL
    SELECT 6, 'The Trio / Dark Willow' UNION ALL
    SELECT 7, 'The First Evil'
),
season_ratings AS (
    SELECT
        e.season,
        bb.big_bad,
        ROUND (AVG(r.imdb_rating),2) AS avg_rating,
        ROUND (MIN(r.imdb_rating),2) AS min_rating,
        ROUND (MAX(r.imdb_rating),2) AS max_rating,
        COUNT(*) AS episode_count
    FROM
        sunnydale.episodes e
    INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
    INNER JOIN big_bads bb ON e.season = bb.season_number
    GROUP BY
        e.season, bb.big_bad
),
overall_stats AS (
    SELECT
        ROUND(AVG(r.imdb_rating),2) AS overall_avg_rating,
        ROUND(STDDEV_SAMP(r.imdb_rating),2) AS rating_stddev
    FROM sunnydale.ratings r
)
SELECT
    sr.season,
    sr.big_bad,
	ROUND(os.overall_avg_rating,2) AS overall_avg_rating,
    ROUND(sr.avg_rating, 2) AS avg_rating,
    ROUND(sr.min_rating, 2) AS min_rating,
    ROUND(sr.max_rating, 2) AS max_rating,
    sr.episode_count,
	ROUND((sr.avg_rating - os.overall_avg_rating) / os.rating_stddev, 2) AS z_score
FROM
    season_ratings sr
CROSS JOIN
    overall_stats os
ORDER BY
    sr.avg_rating DESC;


-- 4.2: Identify "hidden gems" (episodes with high ratings but low viewership)
WITH episode_stats AS (
    SELECT
        e.episodeid,
        e.season,
        e.title,
        r.imdb_rating AS imdb_rating,
        r.viewers AS viewers,
        ROUND(AVG(r.imdb_rating) OVER (PARTITION BY e.season), 2) AS season_avg_rating
    FROM sunnydale.episodes e
    INNER JOIN sunnydale.ratings r ON e.episodeid = r.episodeid
)
SELECT
    es.episodeid,
    es.season,
    es.title,
    es.imdb_rating,
	es.season_avg_rating,
    es.viewers,
    CASE
        WHEN es.imdb_rating > es.season_avg_rating AND es.viewers < (SELECT AVG(viewers) FROM sunnydale.ratings) THEN 'Hidden Gem'
        ELSE 'Other'
    END AS episode_type
FROM episode_stats es
WHERE es.imdb_rating > es.season_avg_rating AND es.viewers < (SELECT AVG(viewers) FROM sunnydale.ratings);