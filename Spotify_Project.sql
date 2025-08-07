--ADvance  Sql project spotify 
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
select * from spotify;

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
/*
--data analysis - 1st category 
1 Retrieve the names of all tracks that have more than 1 billion streams.
2 List all albums along with their respective artists.
3 Get the total number of comments for tracks where licensed = TRUE.
4 Find all tracks that belong to the album type single.
5 Count the total number of tracks by each artist. */

--1 Retrieve the names of all tracks that have more than 1 billion streams.

select * from spotify
where stream >1000000000

--2 List all albums along with their respective artists.
select distinct album,artist from spotify order by 1;

--3 Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comments from spotify 
where licensed= 'true';

--4 Find all tracks that belong to the album type single.
select track from spotify 
where album_type='single'

--5 Count the total number of tracks by each artist. */
select artist,---1
count(*) as total_tracks---2
from spotify
group by artist 
order by 2 asc


/*Medium Level
1 Calculate the average danceability of tracks in each album.
2 Find the top 5 tracks with the highest energy values.
3 List all tracks along with sum of their views and likes where official_video = TRUE.
4 For each album, calculate the total views of all associated tracks.
5 Retrieve the track names that have been streamed on Spotify more than YouTube*/


--1 Calculate the average danceability of tracks in each album.
select * from spotify

select album,avg(danceability) as average_dance 
from spotify  
group by album
order by 2 desc

--2 Find the top 5 tracks with the highest energy values.

select track,max(energy) from spotify
group by track
order by 2 desc
limit 5

--3 List all tracks along with sum of their views and likes where official_video = TRUE.
select track,
sum(views) as total_views,
sum(likes) as total_likes
from spotify
where official_video='true'
group by track
order by 2 desc

--4 For each album, calculate the total views of all associated tracks.
select * from spotify

select album, --1
track,--2
sum(views) as total_views --3
from spotify
group by 1,2
order by 3 desc

--5 Retrieve the track names that have been streamed on Spotify more than YouTube*/
 select * from (
 select track,
 coalesce (sum(case when most_played_on='Youtube' then stream end),0) as streamed_on_youtube,
 coalesce(sum(case when most_played_on='Spotify' then stream end),0)as streamed_on_spotify
 from spotify 
 group by 1 
 ) as t1
 where streamed_on_youtube < streamed_on_spotify
 and streamed_on_youtube <> 0


 /*1 Find the top 3 most-viewed tracks for each artist using window functions.
2 Write a query to find tracks where the liveness score is above the average.
3 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.*/


 --1 Find the top 3 most-viewed tracks for each artist using window functions.

select * from spotify
--
with ranking_artist
as(
select artist,--1
track,--2
sum(views) as total_view,--3
dense_rank() over(partition by artist order by sum(views)desc) as rank
from spotify
group by 1,2
order by 1,3 desc
)
select * from ranking_artist
where rank<=3

--2 Write a query to find tracks where the liveness score is above the average.

select track,artist,liveness from spotify
where liveness > (select avg(liveness) from spotify )

--3 Use a WITH clause to calculate the difference between
--the highest and lowest energy values for tracks in each album.*/
with q13
as (
select 
album,--1
max(energy) as highest_energy,--2
min(energy) as lowest_energy--3
from spotify
group by 1
)
select album,---1
highest_energy - lowest_energy as ENERGY_DIF---2
from q13
order by 2 desc


