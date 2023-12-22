--Retrieve Top 10 for songs released in 2023.
SELECT top 10 track_name AS Track_Name, artist_s_name as Artists, streams As Streams
FROM song_data
WHERE released_year = 2023
ORDER BY streams DESC;
	
 

--Find the top 5 most recent songs based on their release dates
SELECT Top 5 track_name AS Track_Name, artist_s_name As Artists, streams As Streams,
     CONCAT(
        FORMAT(released_day, '00'), 
        '-', 
        FORMAT(released_month, '00'), 
        '-', 
        FORMAT(released_year, '0000')
    ) AS Released_Date
FROM song_data
ORDER BY released_year DESC, released_month DESC, released_day DESC, streams desc;

 
--Find the Song with the highest number of streams.
Select top 1 track_name AS Track_name, artist_s_name As Artists, streams, released_year from song_data order by streams desc;


 

--Find the artist with the least number of streams on their music.
SELECT TOP 3
    artist_s_name AS Artist,
    SUM(streams) AS TotalStreams
FROM
    Song_data
GROUP BY
    artist_s_name
ORDER BY
    TotalStreams asc;

 

--Find songs as per high danceability percentage.
SELECT top 5
    track_name AS Track_Name,
    artist_s_name AS Artist,
    streams,
    danceability AS Danceability
FROM
    song_data
ORDER BY
    danceability DESC;


 --Find the song popular in Shazam Chart
SELECT TOP 1
    track_name AS Popular_Deezer_Song,
    artist_s_name AS Artist,
    in_shazam_charts AS Shazam_Chart_Presence
FROM
    song_data
ORDER BY
   in_Shazam_charts DESC;

 

--Find Artists whose songs have both danceability and energy percentages greater than 90.
Select artist_s_name AS Artist, 
track_name as Track_name,
AVG(streams) AS Average_of_Streams,
danceability as Dancebility_percentage,
energy	as energy_percentage
from Song_data 
where danceability > 90 and energy > 90
group by artist_s_name,track_name,danceability,energy;
 



--Identify Songs with the Same Title but Different Artists.
SELECT DISTINCT
    LEAST(s1.artist_s_name, s2.artist_s_name) AS Artists_1,
    GREATEST(s1.artist_s_name, s2.artist_s_name) AS Artist_2,
    s1.track_name AS Track_name
FROM
    Song_data s1
JOIN
    Song_data s2 ON s1.track_name = s2.track_name
WHERE
    s1.artist_s_name <> s2.artist_s_name;

 

--Retrieve a list of songs and their recommended tracks for artists whose names end with the letter 's'.

WITH RankedSongs AS (
    SELECT
        artist_s_name,
        track_name,
        LEAD(track_name, 1) OVER (PARTITION BY artist_s_name ORDER BY track_name) AS Next_track_1,
        LEAD(track_name, 2) OVER (PARTITION BY artist_s_name ORDER BY track_name) AS Next_track_2
    FROM
        Song_data
)

SELECT DISTINCT
    rs.artist_s_name AS Artist,
    rs.track_name AS Popular_track,
    rs.Next_track_1 AS Recommend_track,
    rs.Next_track_2 AS Second_Recommended_track
FROM
    RankedSongs rs
WHERE
    rs.artist_s_name LIKE '%s'
    AND rs.Next_track_1 IS NOT NULL
    AND rs.Next_track_2 IS NOT NULL;

 

--Find artist having more than 10 unique songs in 2020 to 2023.
select  artist_s_name AS Artist,
Count(distinct track_name) As uniques_song_count
from song_data 
where released_year between 2020 and 2023
group by artist_s_name having count(distinct track_name) > 10
order by 2 desc;
 

--Find songs based on the average popularity across different charts
SELECT TOP 15
    track_name AS Track_Name,
    artist_s_name AS Artist,
    AVG(in_spotify_charts + in_apple_charts + in_deezer_charts + in_shazam_charts) AS Avg_Popularity
FROM
    song_data
GROUP BY
    track_name, artist_s_name
ORDER BY
    Avg_Popularity DESC;

 
--Find the top 20 artists with the highest total streams on their music.
SELECT TOP 20
    artist_s_name AS Artist,
    SUM(streams) AS TotalStreams
FROM
    Song_data
GROUP BY
    artist_s_name
ORDER BY
    TotalStreams Desc;
 
--How the monthly trend of streams for the chosen artist
         SELECT released_year,
           DATENAME(MONTH, DATEADD(MONTH, released_month, 0) - 1) as realeased_month,
    SUM(streams) AS MonthlyTotalStreams
    FROM
        song_data
     WHERE
        artist_s_name= 'Ed Sheeran' and released_year = 2023
     GROUP BY
        released_year,
      DATENAME(MONTH, DATEADD(MONTH, released_month, 0) - 1)
     ORDER BY
      released_year ASC,DATENAME(MONTH, DATEADD(MONTH, released_month, 0) - 1)ASC;


		 
--Top 5 Artists with the Most Songs in Spotify and apple Playlists:

with songCount  as(
select artist_s_name,
Sum(Case when in_spotify_playlists > 0 then 1 else 0 end) as Spotify_playlist_count,
Sum( Case when in_apple_playlists > 0 then 1 else 0 end) Apple_playlist_count
from song_data
group by artist_s_name
)

select  top 5 sc.artist_s_name As Artists,
sum(spotify_playlist_count) As Total_Songs_in_Spotify_playlist,
sum(Apple_playlist_count) As Total_Songs_in_Apple_playlist
from songCount sc
group by artist_s_name , Spotify_playlist_count
order by (SUM(sc.Apple_playlist_count) + SUM(sc.Spotify_playlist_count)) DESC;



 
