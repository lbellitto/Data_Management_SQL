-- Question 1 
-- 1 
/*
Find all the tracks that have a length of 1,000,000 milliseconds or less.
Return only the TrackId column.
*/

select TrackId
    from tracks 
    where milliseconds <= 1000000; 

-- 2 
/*
 Find all the invoices from the billing country USA, and Canada and sort in descending order by invoice ID.
Return two attributes - invoiceID and Total.
*/

select InvoiceId, Total 
    from Invoices 
    where BillingCountry = 'USA' or BillingCountry = 'Canada'
    order by InvoiceId desc; 

-- 3 
/*
Find the albums with 25 or more tracks.
Return albumId and count of tracks for each albumId.
*/

select AlbumId, count(TrackId)
    from tracks
    group by AlbumId 
    having count(TrackId) >= 25; 

-- 4 
/*
Write a query that returns a table consisting of the billing countries and the number of invoices for each country sorted by the country name.
Your output should include BillingCountry attribute and a count column for the number of invoices.
*/

select BillingCountry, count(InvoiceId)
    from Invoices 
    group by BillingCountry 
    order by BillingCountry asc; -- optional 

-- 5 
/*
Write a query that returns a table consisting of the customers and the total amount of money spent by each customer.
Output customerID attribute and total money spent.
*/ 

select c.CustomerId, sum (i.Total) 
    from customers c, invoices i 
    where c.CustomerId = i.CustomerId 
    group by c.CustomerId; 

-- 6 
-- Write a query that returns the customerId for customers that are Blues listeners. The answer should not contain duplicates.

select distinct i.customerId 
    from invoices i, tracks t, genres g, invoice_items it 
    where it.invoiceId = i.invoiceId 
    and it.trackId = t.trackId 
    and t.genreId = g.genreId 
    and g.name = 'Blues'; 

-- 7 
-- Write a query that returns the artist name and total number of Blues tracks by the Blues bands.

select ar.name, count (t.trackId) 
    from albums al, tracks t, genres g, artists ar 
    where al.albumId = t.albumId 
    and al.artistId = ar.artistId 
    and t.genreId = g.genreId 
    and g.name = 'Blues' 
    group by ar.Name; 

--- Question 2 
-- 1 
-- Create tables 

create table CARRIERS (cid varchar(7) primary key,
    name varchar(83)); 

create table MONTHS (mid int primary key, month varchar(9)); 

create table WEEKDAYS (did int primary key, day_of_week varchar(9)); 

CREATE TABLE FLIGHTS (
    fid INT PRIMARY KEY,
    month_id INT,               -- 1–12
    day_of_month INT,           -- 1–31
    day_of_week_id INT,         -- 1–7, 1 = Monday, 2 = Tuesday, etc
    carrier_id VARCHAR(7),
    flight_num INT,
    origin_city VARCHAR(34),
    origin_state VARCHAR(47),
    dest_city VARCHAR(34),
    dest_state VARCHAR(46),
    departure_delay INT,        -- in mins
    taxi_out INT,               -- in mins
    arrival_delay INT,          -- in mins
    canceled INT,               -- 1 means canceled
    actual_time INT,            -- in mins
    distance INT,               -- in miles
    capacity INT,
    price INT,                  -- in $
    FOREIGN KEY (carrier_id) REFERENCES carriers(cid),
    FOREIGN KEY (month_id) REFERENCES months(mid),
    FOREIGN KEY (day_of_week_id) REFERENCES weekdays(did));

-- Specify mode 

pragma foreig = ON 
.mode csv 

-- Import data 

.import "C:/Users/lbellitto/Desktop/DSC100/carriers.csv" carriers 
.import "C:/Users/lbellitto/Desktop/DSC100/months.csv" months 
.import "C:/Users/lbellitto/Desktop/DSC100/weekdays.csv" weekdays 
.import "C:/Users/lbellitto/Desktop/DSC100/flights-small.csv/flights-small.csv" flights 

-- Writing sql queries without using subqueries 
-- 1 
/* 
Compute the total departure delay of each airline across all flights. 
Name the output columns name and delay, in that order.
*/

select c.name as name, sum(f.departure_delay) as delay
    from flights f, carriers c
    where f.carrier_id = c.cid 
    group by c.name; 

-- the output consists of 22 rows 

-- 2
/* Find the total capacity of all direct flights between San Diego and San Francisco on July 1st (i.e., SD to SF or SF to SD).
Name the output column totalcapacity.
*/

select sum(f.capacity) as totalcapacity
    from flights f, months m
    where f.month_id = m.mid
    and ((origin_city = 'San Diego CA' and dest_city = 'San Francisco CA')
    or (origin_city = 'San Francisco CA' and dest_city = 'San Diego CA')) 
    and f.day_of_month = 1 
    and m.month = 'July'; 

-- Number of rows 1 

-- 3 
/* Write a query that returns the name and the percentage of canceled flights out of San Diego for all the airlines that cancelled more than 1% of their flights out of San Diego. Order the results by the percentage of canceled flights in ascending order.
Name the output columns name and percent, in that order.
*/ 
select c.name as name, sum(f.canceled) * 100.0 / count(f.canceled) as percent 
    from flights f, carriers c 
    where f.carrier_id = c.cid AND origin_city = 'San Diego CA' 
    group by c.name 
    having percent > 1 
    order by percent asc; 

-- Number of rows 5 

-- 4 
/* Find the names of all airlines that ever flew more than 5000 flights in one month from california Return the names of the airlines and the number of flights. 
Do not return any duplicates Name the output columns name and flightcount. 
*/ 
select distinct c.name as name, count(f.fid) - sum(f.canceled) as flightcount 
    from flights as f, carriers as c, months as m
    where f.carrier_id = c.cid AND f.month_id = m.mid AND f.origin_state = 'California'
    group by c.name, m.month
    having flightcount > 5000; 

-- Number of rows 6 

select distinct c.name as name, count(f.fid) - sum(f.canceled) as flightcount 
    from flights as f, carriers as c 
    where f.carrier_id = c.cid AND f.origin_state = 'California'
    group by c.name, f.month_id
    having flightcount > 5000; 

-- Number of rows 6 