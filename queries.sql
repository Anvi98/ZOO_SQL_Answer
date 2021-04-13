/*SELECT from WORLD Tutorial*/


-- The example uses a WHERE clause to show the population of 'France'. Note that strings (pieces of text that are data) should be in 'single quotes';
-- Modify it to show the population of Germany
SELECT population FROM world
  WHERE name = 'Germany'

-- Checking a list The word IN allows us to check if an item is in a list. The example shows the name and population for the countries 'Brazil', 'Russia', 'India' and 'China'.
-- Show the name and the population for 'Sweden', 'Norway' and 'Denmark'.
SELECT name, population FROM world
  WHERE name IN ('Sweden','Norway','Denmark');

--Which countries are not too small and not too big? BETWEEN allows range checking (range specified is inclusive of boundary values). The example below shows countries with an area of 250,000-300,000 sq. km. Modify it to show the country and the area for countries with an area between 200,000 and 250,000.
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000
--Observe the result of running this SQL command to show the name, continent and population of all countries.
SELECT name, continent, population FROM world


--Show the name for the countries that have a population of at least 200 million. 200 million is 200000000, there are eight zeros.
SELECT name
  FROM world
 WHERE population > 200000000

--Give the name and the per capita GDP for those countries with a population of at least 200 million.
SELECT name, gdp/population FROM world WHERE population >= 200000000

--Show the name and population in millions for the countries of the continent 'South America'. Divide the population by 1000000 to get population in millions.
SELECT name, population/1000000 FROM world WHERE continent IN ('South America');``

--Show the name and population for France, Germany, Italy
SELECT name, population FROM world WHERE name IN ('France', 'Germany', 'Italy')

--Show the countries which have a name that includes the word 'United'
SELECT name FROM world WHERE name LIKE ('%United%')

-- Two ways to be big: A country is big if it has an area of more than 3 million sq km or it has a population of more than 250 million.
-- Show the countries that are big by area or big by population. Show name, population and area.
SELECT name, population, area FROM world WHERE area >= 3000000 OR population > 250000000;

-- Exclusive OR (XOR). Show the countries that are big by area (more than 3 million) or big by population (more than 250 million) but not both. Show name, population and area.
-- Australia has a big area but a small population, it should be included.
-- Indonesia has a big population but a small area, it should be included.
-- China has a big population and big area, it should be excluded.
-- United Kingdom has a small population and a small area, it should be excluded.
SELECT name, population, area FROM world WHERE (area > 3000000 AND population < 250000000) OR (area < 3000000 AND population > 250000000);

-- Show the name and population in millions and the GDP in billions for the countries of the continent 'South America'. Use the ROUND function to show the values to two decimal places.
-- For South America show population in millions and GDP in billions both to 2 decimal places.
SELECT name, ROUND(population/1000000, 2), ROUND(gdp/1000000000, 2) FROM world WHERE continent IN ('South America');

-- Show the name and per-capita GDP for those countries with a GDP of at least one trillion (1000000000000; that is 12 zeros). Round this value to the nearest 1000.
-- Show per-capita GDP for the trillion dollar countries to the nearest $1000.
SELECT name, ROUND((gdp/population)/1000, 0)*1000 FROM world WHERE gdp >1000000000000;


-- Greece has capital Athens.
-- Each of the strings 'Greece', and 'Athens' has 6 characters.
-- Show the name and capital where the name and the capital have the same number of characters.
SELECT name,capital FROM world WHERE LEN(name) = LEN(Capital)



-- The capital of Sweden is Stockholm. Both words start with the letter 'S'.
-- Show the name and the capital where the first letters of each match. Don't include countries where the name and the capital are the same word.
-- You can use the function LEFT to isolate the first character.
-- You can use <> as the NOT EQUALS operator.
SELECT name, capital
FROM world WHERE LEFT(name,1) = LEFT(capital, 1) AND capital != name


-- Equatorial Guinea and Dominican Republic have all of the vowels (a e i o u) in the name. They don't count because they have more than one word in the name.
-- Find the country that has all the vowels and no spaces in its name.
-- You can use the phrase name NOT LIKE '%a%' to exclude characters from your results.
-- The query shown misses countries like Bahamas and Belarus because they contain at least one 'a'
SELECT name
   FROM world
WHERE name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%' AND name LIKE '%o%' AND name LIKE'%u%' AND name NOT LIKE '% %'

-- List each country name where the population is larger than that of 'Russia'.
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

--Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name FROM world WHERE gdp/population > (SELECT gdp/population FROM world WHERE name='United Kingdom') AND continent = 'Europe';

--List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
SELECT name, continent FROM world WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina','Australia')) ORDER by name;

--  Which country has a population that is more than Canada but less than Poland?
SELECT name, population FROM world WHERE population > (SELECT population FROM world WHERE name = 'Canada') AND population < (SELECT population FROM world WHERE name = 'Poland');

--Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.
--Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT name, CONCAT(ROUND(population/(SELECT population FROM World WHERE name = 'Germany')*100, 0), '%') AS percentage FROM world WHERE continent = 'Europe';

--Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
SELECT name FROM world WHERE gdp > ALL(SELECT gdp 
                                         FROM world
                                       WHERE continent ='Europe' AND  gdp >0 );

--Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)

--List each continent and the name of the country that comes first alphabetically.
SELECT continent, name
FROM world x
WHERE name <= ALL(SELECT name FROM world y
             WHERE x.continent = y.continent)

-- Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
SELECT name, continent, population FROM world WHERE continent IN (SELECT continent FROM world  x WHERE 25000000 >= (SELECT MAX(population) FROM world y WHERE x.continent = y.continent));
or
SELECT y.name, y.continent, y.population
FROM world AS y
JOIN
(SELECT continent,max(population)
FROM world
GROUP BY continent
HAVING max(population) <= 25000000) AS x
ON y.continent = x.continent

-- Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT name, continent FROM world x
  WHERE population > ALL(SELECT 3*population FROM world y WHERE x.continent = y.continent AND x.name <> y.name)

--Show the total population of the world.
SELECT SUM(population)
FROM world

-- List all the continents - just once each.
SELECT DISTINCT continent FROM world;

-- Give the total GDP of Africa
SELECT SUM(gdp) FROM world WHERE continent = 'Africa'

--How many countries have an area of at least 1000000
SELECT COUNT(name) FROM world WHERE area >= 1000000;

-- What is the total population of ('Estonia', 'Latvia', 'Lithuania')
SELECT SUM(population) FROM world WHERE name IN ('Estonia', 'Latvia', 'Lithuania');

-- For each continent show the continent and number of countries.
SELECT continent, COUNT(name) FROM world GROUP BY continent;

-- For each continent show the continent and number of countries with populations of at least 10 million.
SELECT continent, COUNT(name) from world WHERE population >= 10000000 GROUP BY continent;

-- List the continents that have a total population of at least 100 million.
SELECT continent FROM world GROUP BY continent HAVING  SUM(population)> 100000000;

--Modify it to show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
SELECT matchid, player FROM goal 
  WHERE teamid = 'GER'

-- From the previous query you can see that Lars Bender's scored a goal in game 1012. Now we want to know what teams were playing in that match.
-- Notice in the that the column matchid in the goal table corresponds to the id column in the game table. We can look up information about game 1012 by finding that row in the game table.
-- Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
  FROM game WHERE id ='1012'

-- Modify it to show the player, teamid, stadium and mdate for every German goal.
  SELECT player,teamid, stadium, mdate
  FROM game JOIN goal ON (id=matchid)
  WHERE teamid = 'GER'


-- Use the same JOIN as in the previous question.
Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, player
FROM game JOIN goal ON (id=matchid)
WHERE player LIKE 'Mario%'

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
  FROM goal JOIN eteam ON (teamid=id)
 WHERE gtime<=10

-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
 SELECT mdate, teamname
FROM game JOIN eteam ON (team1=eteam.id)
WHERE coach ='Fernando Santos'


-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
FROM goal JOIN game ON (matchid=id)
WHERE stadium = 'National Stadium, Warsaw';

-- The example query shows all goals scored in the Germany-Greece quarterfinal.
-- Instead show the name of all players who scored a goal against Germany.
SELECT DISTINCT(player)
FROM game
  JOIN goal ON matchid = id
WHERE ((team1='GER' OR team2='GER') AND teamid != 'GER')

-- Show teamname and the total number of goals scored.
SELECT teamname, COUNT(player)
  FROM eteam JOIN goal ON id=teamid
 GROUP BY teamname

-- Show the stadium and the number of goals scored in each stadium.
 SELECT stadium, COUNT(player)
FROM game JOIN goal ON (id=matchid)
GROUP BY stadium

-- For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, mdate, COUNT(player)
  FROM game JOIN goal ON matchid = id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid, mdate

-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, COUNT(player)
FROM goal JOIN game ON (matchid=id)
WHERE (team1 = 'GER' or team2 ='GER') AND teamid ='GER'
GROUP BY matchid, mdate

-- List every match with the goals scored by each team as shown. This will use "CASE WHEN" which has not been explained in any previous exercises.
SELECT mdate,
       team1,
       SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
       team2,
       SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2 FROM
    game LEFT JOIN goal ON (id = matchid)
    GROUP BY mdate,team1,team2, matchid

-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962

-- Give year of 'Citizen Kane'.
 SELECT yr FROM movie
WHERE title = 'Citizen Kane'

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr FROM movie
WHERE title LIKE ('%Star Trek%')

-- What id number does the actor 'Glenn Close' have?
SELECT id FROM actor
WHERE name = 'Glenn Close' 

-- What is the id of the film 'Casablanca'
SELECT id from movie
WHERE title = 'Casablanca'

-- Obtain the cast list for 'Casablanca'.
SELECT name
FROM actor JOIN casting ON (id=actorid) JOIN movie ON (movieid=movie.id)
WHERE title ='Casablanca'

-- Obtain the cast list for the film 'Alien'
SELECT name 
FROM actor JOIN casting ON (id=actorid) JOIN movie ON (movieid=movie.id)
WHERE title = 'Alien'

-- List the films in which 'Harrison Ford' has appeared
SELECT title 
FROM movie JOIN casting ON (id=movieid) JOIN actor ON (actorid=actor.id)
WHERE name = 'Harrison Ford'

--List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT title 
FROM movie JOIN casting ON (id=movieid) JOIN actor ON (actorid=actor.id)
WHERE name = 'Harrison Ford' AND ord !=1


-- List the films together with the leading star for all 1962 films.
SELECT title, name
FROM movie JOIN casting ON (id=movieid) JOIN actor ON (actorid=actor.id)
WHERE yr= 1962 AND ord = 1

--Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr,COUNT(title) FROM
  movie JOIN casting ON movie.id=movieid
        JOIN actor   ON actorid=actor.id
WHERE name='Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

--List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name 
FROM movie JOIN casting x ON movie.id = movieid JOIN actor ON actor.id =actorid
WHERE ord=1 AND movieid IN
(SELECT movieid FROM casting y
JOIN actor ON actor.id=actorid
WHERE name='Julie Andrews')

--Obtain a list in alphabetical order of actors who've had at least 30 starring roles.
SELECT name
FROM actor
  JOIN casting ON (id = actorid AND (SELECT COUNT(ord) FROM casting WHERE actorid = actor.id AND ord=1)>=30)
GROUP BY name

--List the films released in the year 1978 ordered by the number of actors in the cast.
SELECT title, COUNT(actorid) as cast
FROM movie JOIN casting on id=movieid
WHERE yr = 1978
GROUP BY title
ORDER BY cast DESC

--List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT name
FROM actor JOIN casting ON id=actorid
WHERE movieid IN (SELECT movieid FROM casting JOIN actor ON (actorid=id AND name='Art Garfunkel')) AND name != 'Art Garfunkel'
GROUP BY name

-- Note the INNER JOIN misses the teacher with no department and the department with no teacher
SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id)

--Use a different JOIN so that all teachers are listed.
SELECT teacher.name, dept.name
FROM teacher LEFT JOIN dept
          ON (teacher.dept=dept.id)

--Use a different JOIN so that all departments are listed.
SELECT teacher.name, dept.name
FROM teacher RIGHT JOIN dept
          ON (teacher.dept=dept.id)

--Use COALESCE to print the mobile number. Use the number '07986 444 2266' there is no number given. Show teacher name and mobile number or '07986 444 2266'
SELECT name,
COALESCE(mobile, '07986 444 2266')
FROM teacher

--Use the COALESCE function and a LEFT JOIN to print the name and department name. Use the string 'None' where there is no department.
SELECT COALESCE(teacher.name, 'NONE'), COALESCE(dept.name, 'None')
FROM teacher LEFT JOIN dept ON (teacher.dept=dept.id)

--Use COUNT to show the number of teachers and the number of mobile phones.
SELECT COUNT(name), COUNT(mobile)
FROM teacher

--Use COUNT and GROUP BY dept.name to show each department and the number of staff. Use a RIGHT JOIN to ensure that the Engineering department is listed.
SELECT dept.name, COUNT(teacher.name)
FROM teacher RIGHT JOIN dept ON (teacher.dept=dept.id)
GROUP BY dept.name

--Use CASE to show the name of each teacher followed by 'Sci' if the the teacher is in dept 1 or 2 and 'Art' otherwise.

SELECT teacher.name,
CASE WHEN dept.id = 1 THEN 'Sci'
     WHEN dept.id = 2 THEN 'Sci'
     ELSE 'Art' END
FROM teacher LEFT JOIN dept ON (teacher.dept=dept.id)

--Use CASE to show the name of each teacher followed by 'Sci' if the the teacher is in dept 1 or 2 show 'Art' if the dept is 3 and 'None' otherwise.
SELECT teacher.name,
CASE
WHEN dept.id = 1 THEN 'Sci'
WHEN dept.id = 2 THEN 'Sci'
WHEN dept.id = 3 THEN 'Art'
ELSE 'None' END
FROM teacher LEFT JOIN dept ON (dept.id=teacher.dept)

--How many stops are in the database.
SELECT COUNT(*)
FROM stops

--Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name = 'Craiglockhart'

--Give the id and the name for the stops on the '4' 'LRT' service.
SELECT id, name
FROM stops
    JOIN route ON id=stop
WHERE company = 'LRT' AND num=4

--The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2.
-- Add a HAVING clause to restrict the output to these two routes
SELECT company, num, COUNT(*) AS visits
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING visits=2

--Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop=149

--The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
--If you are tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'AND stopb.name = 'London Road'

--Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON
  (a.company =b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Haymarket' AND stopb.name='Leith'

--Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT DISTINCT a.company, a.num
FROM route a
  JOIN route b ON (a.num=b.num AND a.company=b.company)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross'

--Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself. Include the company and bus no. of the relevant services.
SELECT stopa.name, a.company, a.num
FROM route a
  JOIN route b ON (a.num=b.num AND a.company=b.company)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopb.name = 'Craiglockhart'

--Find the routes involving two buses that can go from Craiglockhart to Sighthill.
-- Show the bus no. and company for the first bus, the name of the stop for the transfer,
-- and the bus no. and company for the second bus.
SELECT DISTINCT a.num, a.company, stopb.name ,  c.num,  c.company
FROM route a JOIN route b
ON (a.company = b.company AND a.num = b.num)
JOIN ( route c JOIN route d ON (c.company = d.company AND c.num= d.num))
JOIN stops stopa ON (a.stop = stopa.id)
JOIN stops stopb ON (b.stop = stopb.id)
JOIN stops stopc ON (c.stop = stopc.id)
JOIN stops stopd ON (d.stop = stopd.id)
WHERE  stopa.name = 'Craiglockhart' AND stopd.name = 'Sighthill'
            AND  stopb.name = stopc.name
ORDER BY LENGTH(a.num), b.num, stopb.id, LENGTH(c.num), d.num