-- Question 1.1 
-- Write a SQL statement to create a relation/table Artists(ArtistId: Integer,Name: String) where  ArtistId is the primary key.

create table Artists
    (ArtistId integer primary key,
    name varchar(50));

-- Question 1.2
/* 
Insert the following tuples in the database:
   	(1, 'John Lennon')
	(2, 'Roger Waters')
	(3, 'Bob Marley')
	(4, 'Eric Clapton' )
	(5, 'B.B. King' )
	(6, 'Buddy Guy')
	(7, 'Jimi Hendrix') 
    */ 

insert into Artists values (1, 'John Lennon');
insert into Artists values (2, 'Roger Waters');
insert into Artists values (3, 'Bob Marley');
insert into Artists values (4, 'Eric Clapton');
insert into Artists values (5, 'B.B. King');
insert into Artists values (6, 'Buddy Guy');
insert into Artists values (7, 'Jimi Hendrix'); 

-- Question 1.3
-- Write a SQL statement that returns all tuples.

.header on -- For a nicer formatting
.mode column -- For a nicer visualization 
select * from Artists;

-- Question 1.4
--  Write a SQL statement to find all artists whose name begins with the letter "B".

select * from Artists where name like 'B%';

-- Question 1.5
-- Write a SQL statement to return the name attribute of the tuple with ArtistId equal to 2.

select name from Artists where ArtistId = 2;

-- Question 1.6
/* 
Answer the following questions:
Insert the tuple ('-1','Michael Jackson'). What happens? Why? 
Insert the tuple (2, 'Roger Waters') again. What happens? Why?
Insert the tuple (NULL,'Roger Waters'). What happens? Why? 
*/
insert into Artists values ('-1,' 'Michael Jackson'); 

-- The query stores a new value in the table even if the ArtistId is a string. 
-- This is due to the fact that SQL converts the value inserted to the datatype specified in the creation of the table. 
-- For example, here the ArtistId is intended to be an integer while the last query is inserting a string. 
-- The database converts the string value to an integer to respect the appropriate datatype stated when the table was created, so to respect the affinity.  
-- After converting into an integer, since SQL accepts also negative values, the new value is stored in the table. 
-- In this case, it is stored at the beginning being the integer the smallest value. 

insert into Artists values (2, 'Roger Waters'); 

-- answer 
-- The database returns an error as it is not possible to run this query. 
-- It is not possible to store in the query because the value already exists, so it will break the UNIQUE constraint. 

insert into Artists values (Null, 'Roger Waters');

-- The query successfully stores another value. Even if the name is repeated, the ActorId, which is the primary key, is not, so SQL successfully stores the new value. 
-- The value is stored at the end, giving the ActorId = 8. Indeed, when a NULL class is stored, the value is considered less than any other value. 
-- For this reason, it is assigned the smallest value as ActorId. 

-- Question 2
-- Now,  create a second table Albums(AlbumId:Integer, Title: Varchar, Released: Date,  ArtistId: Integer) where AlbumId is the Primary Key and ArtistId is a Foreign Key to the Artists table. 

create table Albums
    (AlbumId integer primary key,
    Title varchar(50),
    Released date,
    artistId integer references Artists);

 PRAGMA foreign_keys = ON 

-- Question 3
-- Insert at least 10 tuples using the SQL INSERT statement.  You should insert at least one album for each artist.

insert into Albums values (1, 'Imagine', 1971-09-09, 1);
insert into Albums values (2, 'Rock N Roll', 1975-02-17, 1);
insert into Albums values (3, 'The Wall', 1979-11-30, 2);
insert into Albums values (4, 'Uprising', 1980-06-10, 3);
insert into Albums values (5, 'Catch a Fire', 1973-04-13, 3);
insert into Albums values (6, 'Unplugged', 1992-08-25, 4);
insert into Albums values (7, 'Deuces Wild', 1997-11-04, 5);
insert into Albums values (8, 'Sweet Tea', 2001-05-15, 6);
insert into Albums values (9, 'Woodstock', 1994-08-20, 7);
insert into Albums values (10, 'Slippin In', 1994-10-25, 6); 

-- Question 4
/* 
Write a SQL query that returns all albums in your table. Experiment with a few of SQLite's  output formats and show the command you use to format the output along with your query:
print the results in comma-separated form
print the results in list form, delimited by "|"
print the results in column form, and make each column have width 15
for each of the formats above, try printing/not printing the column headers with the results
*/ 
.header OFF -- Assuming we are starting with the header on 
.mode csv
select * from Albums;

.mode list
select * from Albums;

.mode column
.width 15 15 15 15
select * from Albums;

.header ON 
.mode csv
select * from Albums;

.mode list
select * from Albums;

.mode column
.width 15 15 15 15
select * from Albums;

-- Question 5
-- Write a SQL query that returns all artists names and the title of their albums. The query should list the artists in alphabetical order of names.
select Artists.name, Albums.Title
from Artists, Albums
where Artists.ArtistId = Albums.artistId
order by Artists.name; 

-- Question 6
--  Write a SQL query that returns all the artist names who released at least one album after 2000.
select distinct Artists.name
from Artists, Albums
where Albums.ArtistId = Artists.ArtistId 
and Albums.released > 2000;

-- Question 7
-- Write a SQL query that returns all the artists and the number of albums they released.

select count(Albums.title), Artists.name
from Albums, Artists
where Albums.ArtistId = Artists.ArtistId
group by artists.name; 