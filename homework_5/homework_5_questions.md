**Question 1**

Design an E/R diagram for geography that contains the following kinds of objects or entities together with the listed attributes.
Model the relationships between the objects with edges. Note that edges between entities can be labeled with constraints. Make sure to label only the/those primary key(s) that is/are mentioned below.

*Entities*
- countries (with attributes): name, area, population, gdp ("gross domestic product")
    a country's name uniquely identifies the country within all countries

- cities: name, population, longitude, latitude
    a city is uniquely identified by its (longitude, latitude) (not by name, ex:there are 41 different cities and towns named Springfield in the US!)

- rivers: name, length

- seas: name, max depth
    rivers and seas are uniquely identified within all water entities by their name (e.g., "Ganges" would be a unique water entity)


*Relationships:*
- each city belongs to exactly one country

- each river crosses at least one country

- each country can be crossed by zero or more rivers

- each river ends in either a river or a sea 

You can draw your diagrams on paper and scan them, take quality pictures of your drawn diagram, or use your favorite drawing tool such as Powerpoint, Keynote, or draw.io. (FYI: Google Slides lacks a few shapes that you might need such as rounded arrows... You can use a crescent and a line)

