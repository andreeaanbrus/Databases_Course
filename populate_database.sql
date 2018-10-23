use VideoRental

--Actors

INSERT INTO Actors
VALUES (1, 'lirstNameActor1', 'lastNameActor2', 'details1')

INSERT INTO Actors
VALUES (2, 'lirstNameActor2', 'lastNameActor2', 'details2')

UPDATE Actors
SET lastname = 'lastNameActor1'
WHERE actorID = 1

--Identities

INSERT INTO Identities
VALUES (1, 'Andreea', 'Anbrus', '0745252895', 'address1', '1234567890123')

INSERT INTO Identities
VALUES (2, 'firstName2', 'lastName2', '0743252895', 'address2', '132456789123')

INSERT INTO Identities
VALUES (3, 'firstName3', 'lastName3', '0743252894', 'address3', '132456789124')

INSERT INTO Identities
VALUES (4, 'firstName4', 'lastName4', '0743252896', 'address4', '132456780123')

--Costumers

INSERT INTO Costumers
VALUES (1, 1)

INSERT INTO Costumers
VALUES(2,2)

--Employees

INSERT INTO Employees
VALUES (1, 3)

INSERT INTO Employees
VALUES (2, 4)

--Locations

INSERT INTO Locations
VALUES (1, 'location1')

INSERT INTO Locations
VALUES (2, 'location2')

--Genres

INSERT INTO Genres
VALUES (1, 'genre1')

INSERT INTO Genres
VALUES (2, 'genre2')

--Directors

INSERT INTO Directors
VALUES (1, 'firstName1', 'lastName1', 'details1')

INSERT INTO Directors
VALUES (2, 'firstName2', 'lastName2', 'details2')

--Videos

INSERT INTO Videos
VALUES (1, 'videoName1', 10, 2010, 1, 1, 1)

INSERT INTO Videos
VALUES (2, 'videoName1', 10, 2010, 2, 1, 1)

INSERT INTO Videos
VALUES (3, 'videoName2', 12, 2011, 1, 1, 2)

INSERT INTO Videos
VALUES (4, 'videoName4', 15.4, 2018, 1, 2, 2)

--Videos_Actors

INSERT INTO Videos_Actors
VALUES (1, 1)

INSERT INTO Videos_Actors
VALUES (2, 1)

INSERT INTO Videos_Actors
VALUES (3, 1)

INSERT INTO Videos_Actors
VALUES (3, 2)

--Rentals
INSERT INTO Rentals
VALUES (1, 1, 1, '2018-10-10', '2018-10-20')

INSERT INTO Rentals
VALUES (2, 1, 1, '2018-10-10', '2018-10-20')

INSERT INTO Rentals
VALUES (3, 2, 1, '2018-10-10', '2018-10-20')

