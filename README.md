# Spotify-Dataset-Exploration-Using-SQL
![spotify logo](https://github.com/user-attachments/assets/5b67c358-d796-4583-a36d-d181ddac6f83)


# Overview
This project focuses on exploring a raw Spotify dataset that includes detailed information about tracks, albums, and artists. The process begins by converting the unorganized data into a well-structured format through normalization. Various SQL queries are then applied, ranging from basic to complex, to uncover useful insights. The main objective is to strengthen SQL knowledge while analyzing real music data and improving query performance.

# Objective
To develop and apply advanced SQL skills by analyzing Spotify’s music dataset. The goal is to transform unstructured data into a usable format and generate practical insights through well-structured and performance-optimized SQL queries.

#  Dataset
The dataset includes various attributes such as track names, album details, artist names, stream counts, likes, comments, views, and musical features like energy, danceability, and liveness. It was initially unstructured and required normalization for accurate querying and analysis.
<a href=""> Dataset</a>

# Schema
```
create table spotify(
artist varchar(225),
track varchar(255),
album varchar(255),
album_type varchar(50),
danceability FLOAT,
energy FLOAT,
loudness FLOAT,
speechiness FLOAT,
acousticness FLOAT,
instrumentalness FLOAT,
liveness FLOAT,
valence FLOAT,
tempo FLOAT,
duration_min FLOAT,
title varchar(225),
channel varchar(225),
views FLOAT,
likes BIGINT,
comments BIGINT,
licensed BOOLEAN,
official_video BOOLEAN,
stream BIGINT,
energy_liveness FLOAT,
most_played_on varchar(50)
);
```
```
--EDA basic reviewing + filtering + clearing irregular data 
select count(*) from spotify;
select count(distinct artist) from spotify;
select distinct album_type from spotify;
select max(duration_min) from spotify;
select min(duration_min) from spotify;
select * from spotify 
where duration_min=0

delete from spotify
where duration_min=0;

select distinct channel from spotify;
select distinct most_played_on from spotify;
```

# Business Problems and Solutions

# Retrieve all tracks with over 1 billion streams
```
SELECT * 
FROM spotify 
WHERE stream > 1000000000;
```
# List all albums with their respective artists
```
SELECT DISTINCT album, artist 
FROM spotify 
ORDER BY album;
```
# Get the total number of comments where the track is licensed
```
SELECT SUM(comments) AS total_comments 
FROM spotify 
WHERE licensed = 'true';
```
# Find all tracks that are released as singles
```
SELECT track 
FROM spotify 
WHERE album_type = 'single';
```
# Count the total number of tracks for each artist
```
SELECT artist, COUNT(*) AS total_tracks 
FROM spotify 
GROUP BY artist 
ORDER BY total_tracks ASC;
```
# Calculate the average danceability of tracks in each album
```
SELECT album, AVG(danceability) AS average_dance 
FROM spotify  
GROUP BY album 
ORDER BY average_dance DESC;
```
# Get the top 5 tracks with the highest energy
```
SELECT track, MAX(energy) 
FROM spotify 
GROUP BY track 
ORDER BY MAX(energy) DESC 
LIMIT 5;
```
# Show total views and likes for tracks marked as official videos
```
SELECT track, 
       SUM(views) AS total_views, 
       SUM(likes) AS total_likes 
FROM spotify 
WHERE official_video = 'true' 
GROUP BY track 
ORDER BY total_views DESC;
```
# Calculate total views per album
```
SELECT album, track, SUM(views) AS total_views 
FROM spotify 
GROUP BY album, track 
ORDER BY total_views DESC;
```
# Retrieve track names with more streams on Spotify than YouTube
```
SELECT * 
FROM (
  SELECT track,
         COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube,
         COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify
  FROM spotify 
  GROUP BY track
) AS t1
WHERE streamed_on_spotify > streamed_on_youtube 
  AND streamed_on_youtube <> 0;
```
# Get top 3 most-viewed tracks for each artist
```
WITH ranking_artist AS (
  SELECT artist,
         track,
         SUM(views) AS total_view,
         DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
  FROM spotify 
  GROUP BY artist, track
)
SELECT * 
FROM ranking_artist 
WHERE rank <= 3;
```
# List tracks where liveness is above the average
```
SELECT track, artist, liveness 
FROM spotify 
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```
# Show difference between max and min energy for each album
```
WITH q13 AS (
  SELECT album, 
         MAX(energy) AS highest_energy, 
         MIN(energy) AS lowest_energy 
  FROM spotify 
  GROUP BY album
)
SELECT album, 
       highest_energy - lowest_energy AS energy_difference 
FROM q13 
ORDER BY energy_difference DESC;
```
# Outcome & Findings
The project helped identify key patterns such as the most streamed tracks, top-viewed artists, genre-based performance, and trends in engagement metrics. Complex queries involving ranking, aggregation, and condition-based filtering revealed deeper insights into listening behaviors across platforms like YouTube and Spotify.

# Conclusion
This project demonstrates how structured SQL logic can turn raw music data into valuable insights. It also reflects strong command over joins, subqueries, CTEs, and window functions while reinforcing real-world data handling skills.
