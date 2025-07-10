-- Question 1
/* 
For each origin city, find the destination city (or cities) with the longest direct flight. 
By direct flight, we mean a flight with no intermediate stops. 
Judge the longest flight in time, not distance
Name the output columns origin_city, dest_city, and time, representing the flight time between them. 
Do not include duplicates of the same origin/destination city pair. Order the result by origin_city and then dest_city (ascending, i.e. alphabetically).
*/

SELECT DISTINCT f.origin_city, f.dest_city, f.actual_time AS time
FROM flights f
WHERE (f.origin_city, f.actual_time) IN (
    SELECT origin_city, MAX(actual_time)
    FROM flights
    GROUP BY origin_city
)
ORDER BY f.origin_city, f.dest_city;

-- Question 2 
/*
Find all origin cities that only serve flights shorter than 3 hours. 
You can assume that flights with NULL actual_time are not 3 hours or more. 
Name the output column city and sort them. List each city only once in the result.
*/

-- With subquery 
SELECT DISTINCT origin_city AS city
FROM flights
WHERE origin_city NOT IN (
    SELECT origin_city
    FROM flights
    WHERE actual_time >= 180
)
ORDER BY origin_city;

-- Without subquery 
SELECT origin_city AS city
FROM flights
GROUP BY origin_city
HAVING MAX(actual_time) < 180 OR MAX(actual_time) IS NULL
ORDER BY origin_city;

-- Question 3 
/*
For each origin city, find the percentage of departing flights shorter than 3 hours. 
For this question, treat flights with NULL actual_time values as longer than 3 hours. 
 Name the output columns origin_city and percentage. Order by percentage value, ascending. 
 Be careful to handle cities without any flights shorter than 3 hours. We will accept either 0 or NULL as the result for those cities. 
 Report percentages as percentages not decimals (e.g., report 75.25 rather than 0.7525).
*/

-- With subquery
SELECT origin_city,
       (SELECT COUNT(*) 
        FROM flights f2 
        WHERE f2.origin_city = f1.origin_city AND f2.actual_time < 180) 
       * 100.0 / COUNT(*) AS percentage
FROM flights f1
GROUP BY origin_city
ORDER BY percentage ASC;

-- Without subquery 
SELECT origin_city,
       COUNT(*) FILTER (WHERE actual_time < 180) * 100.0 / COUNT(*) AS percentage
FROM flights
WHERE actual_time IS NOT NULL
GROUP BY origin_city
ORDER BY percentage ASC;

-- Question 4 
/*
List all cities that cannot be reached from San Diego through a direct flight but can be reached with one stop (i.e., with any two flights that go through an intermediate city). 
Do not include San Diego as one of these destinations (even though you could get back with two flights). 
Name the output column city. Order the output ascending by city.
*/

SELECT DISTINCT b.dest_city as city 
FROM flights a, flights b
WHERE a.origin_city = 'San Diego CA' 
  AND a.dest_city = b.origin_city
  AND a.dest_city != 'San Diego CA' 
  AND b.dest_city NOT IN (
    SELECT dest_city FROM flights WHERE origin_city = 'San Diego CA' 
  )
  AND b.dest_city != 'San Diego CA' 
ORDER BY b.dest_city; 

-- Question 5 
/*
List the names of carriers that operate flights from San Diego to San Francisco, CA. 
Return each carrier's name only once. Use a nested query to answer this question.
Name the output column carrier. Order the output ascending by carrier.
*/

SELECT DISTINCT c.name AS carrier
FROM carriers c
WHERE EXISTS (
    SELECT 1
    FROM flights f
    WHERE f.carrier_id = c.cid
      AND f.origin_city = 'San Diego CA'
      AND f.dest_city = 'San Francisco CA'
)
ORDER BY carrier ASC; 

-- Question 6 
/*
Express the same query as above, but do so without using a nested query. 
Again, name the output column carrier and order it in ascending order.
*/

SELECT DISTINCT c.name AS carrier
FROM flights f, carriers c
WHERE c.cid = f.carrier_id
  AND origin_city = 'San Diego CA'
  AND dest_city = 'San Francisco CA'
ORDER BY carrier ASC;

-- Question 7 
/* 
List all tracks that were never purchased by any customers. 
Return distinct track names. We only need the name attribute. 
*/

SELECT DISTINCT t.name
FROM track t
WHERE t.track_id NOT IN (
    SELECT i.track_id
    FROM invoice_line i, track t
    WHERE i.track_id = t.track_id)
order by t.name asc; 

-- Question 8 
/*
 List the names of all songs that do not belong to the 90’s Music playlist. 
 Return distinct track names (only the name attribute) 
*/

SELECT DISTINCT t.name
FROM playlist_track pt, track t
WHERE pt.track_id = t.track_id
  AND pt.track_id NOT IN (
    SELECT p.playlist_id
    FROM playlist p, playlist_track pt
    WHERE p.playlist_id = pt.playlist_id
      AND p.name = '90Æs Music'
)
order by t.name asc;

-- Question 9 
/*
List the artists who did not record any tracks of the Blues genre. 
Return distinct artist names (only the name attribute). 
*/

SELECT DISTINCT ar.name
FROM artist ar
WHERE ar.artist_id NOT IN (
    SELECT ar.artist_id
    FROM track t, artist ar, album al, genre g
    WHERE ar.artist_id = al.artist_id
      AND t.album_id = al.album_id
      AND g.genre_id = t.genre_id
      AND g.name = 'Blues'
)
order by ar.name asc; 

-- Question 10
/*
List all the playlists that do not have any track in the Rock or Blues genres. 
Return distinct playlist name (only the name attribute). 
*/

SELECT DISTINCT p.name
FROM playlist p
WHERE p.playlist_id NOT IN (
  SELECT p.playlist_id
  FROM playlist p, track t, genre g, playlist_track pt
  WHERE p.playlist_id = pt.playlist_id
    AND t.track_id = pt.track_id
    AND t.genre_id = g.genre_id
    AND (g.name = 'Rock' OR g.name = 'Blues')
)
order by p.name asc; 

-- Question 11 
/*
Find the list of artists that record at least in 3 different genres. 
Again, return only the artist name.
*/

SELECT ar.name
FROM genre g, artist ar, track t, album al
WHERE g.genre_id = t.genre_id
  AND t.album_id = al.album_id
  AND al.artist_id = ar.artist_id
GROUP BY ar.name
HAVING COUNT(DISTINCT g.genre_id) >= 3
ORDER BY ar.name ASC; 