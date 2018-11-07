use VideoRental

--a) select the names of the videos rented by the costumer 1 or the costumer 3 -> UNION
SELECT v.name
FROM Videos v, Rentals r
WHERE v.videoId = r.videoID
AND r.costumerID = 1
UNION
SELECT v.name
FROM Videos v, Rentals r
WHERE v.videoId = r.videoID
AND r.costumerID = 3

--a) same select as above, but using OR (duplicates appear) -> OR

SELECT v.name
FROM Videos v, Rentals r
WHERE v.videoId = r.videoID
AND r.costumerID = 1 OR r.costumerID = 3

--b) -> select the names of the videos  rented by the employee with id = 1 and employee with id = 3 -> INTERSECT

SELECT v.name
FROM Videos v, Rentals r
WHERE v.videoId = r.videoID AND r.employeeID = 1
INTERSECT
SELECT v.name
FROM Videos v, Rentals r
WHERE v.videoId = r.videoID AND r.employeeID = 2


--b) select the rental returndates from the videos rented which have videoName = 'videoName1', 'videName4' -> IN

SELECT r.returnDate
FROM Rentals r, Videos c
WHERE r.costumerID = c.videoID
AND c.name IN ('videoName1', 'videoName2')

--c) select the actors names  who play in movie 1 but not in movie 4 -> EXCEPT

SELECT a.firstName, a.lastname
FROM Actors a, Videos_Actors va
WHERE a.actorID = va.actorID AND va.videoID = 1
EXCEPT
SELECT a.firstName, a.lastname
FROM Actors a, Videos_Actors va
WHERE a.actorID = va.actorID AND va.videoID = 4

--c) select the actos names which do not play in any movie -> NOT IN + parentheses in where
SELECT a.firstName, a.lastname
FROM Actors a
WHERE a.actorID NOT IN
(SELECT va.actorID
  FROM Videos_Actors va)

--d) select the names of the rented movies -> INNER JOIN + DISTINCT

SELECT distinct v.name
FROM Videos v INNER JOIN Rentals r ON v.videoId = r.videoID

--d) select the names of the costumers who rented -> RIGHT JOIN + DISTINCT + 3 TABLES
SELECT DISTINCT i.firstName
FROM Identities i RIGHT JOIN Costumers c on i.identityID = c.identityID
RIGHT JOIN Rentals r on c.costumerID = r.costumerID

--d) select the names of the actors who play in the rented movies LEFT JOIN + DISTINCT + 2 MANY TO MANY
SELECT DISTINCT a.actorID, a.firstName, a.lastname
FROM Rentals r LEFT JOIN Videos_Actors va on r.videoID = va.videoID
LEFT JOIN Actors a on va.actorID = a.actorID

--d) select the vide name and its corespondig genre -> FULL JOIN
SELECT V.name, G.name
FROM Videos V FULL JOIN Genres G on V.genreID = G.genreID

--e) select the price in euros from the rented videos -> IN + Arithmetic expression
SELECT V.name ,V.price / 4.6 as 'PRICE IN EUROS'
from Videos V
WHERE V.videoId IN (
    SELECT R.videoID
    FROM Rentals R
    WHERE R.videoID = v.videoId
    )

--e) select the first 3 prices from the rented videos which have the actor 1 in them -> IN  + 2 WHERE + TOP
SELECT TOP 3 V.name ,V.price
from Videos V
WHERE V.videoId IN (
    SELECT R.videoID
    FROM Rentals R
    WHERE r.videoID IN (
          SELECT DISTINCT r.videoID
          FROM Rentals r INNER JOIN Videos_Actors va on r.videoID = va.videoID
          INNER JOIN Actors a on va.actorID = a.actorID AND a.actorID = 1
        )
    )

--f) EXISTS select the names of the videos rented by employee 1 -> EXISTS + ARITHMETIC EXPR
SELECT v.name, v.price/4.6 as 'Price in euros'
FROM Videos v
WHERE EXISTS(
    SELECT *
    FROM Rentals r
    where v.videoId = r.videoID AND r.employeeID=1
          )

--f) EXITSTS the name of the employees who rented videos with id=3 -> EXISTS + ORDER BY DESC
SELECT i.firstName, i.lastName
FROM  Identities i INNER JOIN Employees e on i.identityID = e.identityID
WHERE EXISTS(
    SELECT *
    FROM Rentals r
    WHERE r.videoID = 3 and e.employeeID = r.employeeID
          )
ORDER BY i.firstName DESC

--g) SELECT the employee first and last name, by employee id -> SUBQ IN FROM + ORDER BY
SELECT a.employeeID, a.lastName, a.firstName
FROM (
    SELECT i.firstName, i.lastName, e.employeeID, e.identityID
    FROM Identities i INNER JOIN Employees e on i.identityID = e.identityID
    ) a
ORDER BY a.employeeID

--g) SELECT the genres and the video name -> SUBQ IN FROM
SELECT G.name, X.name
FROM  Genres G INNER JOIN (
    SELECT *
    FROM Videos V
    ) X
          ON g.genreID = x.genreID



--h) SELECT the number of rented videos of a kind -> COUNT + GROUP BY
SELECT  count(R.videoID) as 'Number of rented times', X.name
    FROM Rentals R INNER JOIN (
SELECT *
    FROM Videos V
    ) X
    ON R.videoID = X.videoId
GROUP BY X.name

--h) SELECT THE MINIMUM PRICE OF THE VIDEOS GROUPED BY GENRE having the genre 1 or genre 2 -> GROUP BY + HAVING
SELECT MIN(V.price) as 'Minimum for genre', V.genreID
FROM Videos v
GROUP BY V.genreID
HAVING V.genreID = 1 or V.genreID = 2

--h) SELECT THE FIRST PRICE OF VIDEOS WHICH IS SMALLER THAN THE AVERAGE PRICE (in euros) -> GROUP BY + HANVING + SUBQ + AVG + TOP + ARITHMETIC
SELECT TOP 1 V.name, V.price/4.6  AS 'Price in euros'
FROM Videos V
GROUP BY V.price, V.name
HAVING V.price < (SELECT AVG(V1.price)
                  FROM Videos V1)

--h) SELECT the employee id who rented the video with id 4 -> GROUP BY + HAVING + SUBQ
SELECT R.employeeID, R.videoID
FROM Rentals R
GROUP BY R.employeeID, R.videoID
HAVING R.videoID IN ( SELECT R.videoID
                     FROM Rentals R
                    WHERE R.videoID = 4)

--i) SELECT the name of the video rented by the employee 1 -> ANY + IN + subq
SELECT V.name
FROM Videos V
WHERE videoId = ANY(SELECT R.videoID
                   FROM Rentals R, Videos V
                    WHERE R.videoID = V.videoId
                   AND R.employeeID = 1)

SELECT V.name
FROM Videos V
WHERE videoId IN (SELECT R.videoID
                   FROM Rentals R, Videos V
                    WHERE R.videoID = V.videoId
                   AND R.employeeID = 1)

select * from Videos

--i) select the year of release and the name of the movies whose year of release is DIFERENT than the movies with the id = 3 -> ALL + NOT IN

SELECT v1.yearofRelease, v1.name
FROM Videos v1
WHERE v1.yearofRelease <> ALL (
    SELECT v.yearofRelease
    FROM Videos v
    WHERE V.videoId = 3
    )

SELECT v1.yearofRelease, v1.name
FROM Videos v1
WHERE v1.yearofRelease NOT IN  (
    SELECT v.yearofRelease
    FROM Videos v
    WHERE V.videoId = 3
    )

--i) select the videos(name + price) whose price are greater than all the videos named "videoName2" -> ALL + NOT IN
SELECT V.name, V.price
FROM Videos V
WHERE price > ALL(SELECT price
                 FROM Videos V1
                 WHERE V1.name = 'videoName2')

--i) select the number of the videos whose price is greater than the videos named "videoName2" -> ALL + AGGREGATION
SELECT COUNT(*) AS 'The number of videos'
FROM Videos V
WHERE price > ALL(SELECT price
                 FROM Videos V1
                 WHERE V1.name = 'videoName2')




