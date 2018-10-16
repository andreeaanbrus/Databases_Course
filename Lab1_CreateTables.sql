create table Genres
(
  genreID int not null
    primary key,
  name    varchar(20)
)
go

create table Locations
(
  locationID int not null
    primary key,
  address    varchar(50)
)
go

create table Identities
(
  identityID  int not null
    primary key,
  firstName   varchar(15),
  lastName    varchar(15),
  phoneNumber varchar(11),
  address     varchar(50),
  cnp         varchar(14)
)
go

create table Actors
(
  actorID   int not null
    primary key,
  firstName varchar(15),
  lastname  varchar(15),
  details   varchar(50)
)
go

create table Directors
(
  directorID int not null
    primary key,
  firstName  varchar(15),
  lastName   varchar(15),
  details    varchar(50)
)
go

create table Costumers
(
  costumerID int not null
    primary key,
  identityID int
    references Identities
)
go

create table Employees
(
  employeeID int not null
    primary key,
  identityID int
    references Identities
)
go

create table Videos
(
  movieId       int not null
    primary key,
  name          varchar(50),
  price         decimal(5, 2),
  yearofRelease smallint
    check ([yearofRelease] > 1900 AND [yearofRelease] < 2020),
  locationID    int
    references Locations,
  genreID       int
    references Genres,
  directorID    int
    references Directors
)
go

create table Rentals
(
  videoID    int not null
    references Videos,
  costumerID int not null
    references Costumers,
  employeeID int not null
    references Employees,
  rentDate   datetime default getdate(),
  returnDate datetime,
  primary key (videoID, costumerID, employeeID)
)
go

create table Videos_Actors
(
  videoID int not null
    references Videos,
  actorID int not null
    references Actors,
  primary key (videoID, actorID)
)
go


