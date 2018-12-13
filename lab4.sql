use VideoRentalSimplified

CREATE VIEW VHomeAloneMovies
AS
  SELECT *
  FROM Videos v
  WHERE v.name LIKE 'Home Alone%'

CREATE VIEW VRentedMoviesNames
AS
  SELECT DISTINCT V.name, r.costumerId, r.date
  FROM Rentals r INNER JOIN Videos V on r.videoId = V.videoId

CREATE VIEW VRentedMoviesNamesSorted
AS
  SELECT DISTINCT V.name
  FROM Rentals r INNER JOIN Videos V on r.videoId = V.videoId
  GROUP BY v.name

INSERT INTO Views (Name) VALUES ('VHomeAloneMovies')
INSERT INTO Views (Name) VALUES ('VRentedMoviesNames')
INSERT INTO Views (Name) VALUES ('VRentedMoviesNamesSorted')

INSERT INTO Tables (Name) VALUES ('Locations')
INSERT INTO Tables (Name) VALUES ('Videos')


INSERT INTO Tests VALUES ('select_view')
INSERT INTO Tests VALUES ('delete_locations')
INSERT INTO Tests VALUES ('insert_locations')
INSERT INTO Tests VALUES ('delete_videos')
INSERT INTO Tests VALUES ('insert_videos')


INSERT INTO TestViews VALUES (1, 1)
INSERT INTO TestViews VALUES (1, 2)
INSERT INTO TestViews VALUES (1, 3)

INSERT INTO TestTables (TestId, TableID, NoOfRows, Position) VALUES (2, 1, 100, 1)
INSERT INTO TestTables (TestId, TableID, NoOfRows, Position) VALUES (4, 2, 100, 2)



--before test delete prev tests
delete from TestRunViews
delete from TestRuns
delete from TestRunTables

GO
CREATE PROC deleteLocations
AS
  DELETE FROM Locations
  where locationId > 3

GO
CREATE PROC insertLocations
  as
  DECLARE @locationId INT = 4
  DECLARE @NoOfRows int
  SELECT @NoOfRows = NoOfRows FROM TestTables WHERE TestId = 2
  WHILE @locationId < @NoOfRows
    BEGIN
      DECLARE @address VARCHAR(15) = 'address' + convert(varchar(5), @locationId)
      INSERT INTO Locations VALUES (@locationId, @address)
      SET @locationId = @locationId + 1
    END
GO

CREATE PROC deleteVideos
  AS
  DELETE FROM Videos
  WHERE videoId > 5
GO
DROP PROC insertVideos
CREATE PROC insertVideos
  AS
  DECLARE @videoId INT = 6
  DECLARE @NoOfRows INT
  SELECT @NoOfRows = NoOfRows FROM TestTables WHERE TestID = 4
  WHILE @videoId < @NoOfRows
  begin
    DECLARE @name VARCHAR(20) =  'video_name' + convert(varchar(5), @videoId)
    DECLARE @locationId int  = 1
    INSERT INTO Videos VALUES (@videoId, @name, @locationId)
    SET @videoId = @videoId + 1
  end
GO

drop proc TestRunView
create PROC TestRunView
as
  begin
    DECLARE @startTime1 DATETIME;
    DECLARE @endTime1 DATETIME;
    DECLARE @startTime2 DATETIME;
    DECLARE @endTime2 DATETIME;
    DECLARE @startTime3 DATETIME;
    DECLARE @endTime3 DATETIME;

    SET @startTime1 = GETDATE();
    EXEC ('select * from VHomeAloneMovies');
    PRINT 'select * from VHomeAloneMovies';
    SET @endTime1 = GETDATE();

    INSERT INTO TestRuns VALUES ('test_view', @startTime1, @endTime1)
    INSERT INTO VideoRentalSimplified.dbo.TestRunViews(TestRunID, ViewID, StartAt, EndAt) values (@@IDENTITY, 1, @startTime1, @endTime1);

    SET @startTime2 = GETDATE();
    EXEC ('select * from VRentedMoviesNames');
    PRINT 'select * from VHomeAloneMoviesNames';
    SET @endTime2 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_view2', @startTime2, @endTime2)
    INSERT INTO VideoRentalSimplified.dbo.TestRunViews(TestRunID, ViewID, StartAt, EndAt) values (@@identity, 2, @startTime2, @endTime2);

    SET @startTime3 = GETDATE();
    EXEC ('select * from VRentedMoviesNamesSorted');
    PRINT 'select * from VHomeAloneMoviesNamesSorted';
    SET @endTime3 = GETDATE();
    INSERT INTO TestRuns VALUES ('test_view3', @startTime3, @endTime3)
    INSERT INTO VideoRentalSimplified.dbo.TestRunViews(TestRunID, ViewID, StartAt, EndAt) values (@@identity, 3, @startTime3, @endTime3);
  end
GO
exec TestRunView

drop proc TestRunInsertRemove
CREATE PROC TestRunInsertRemove
  AS
    begin
      DECLARE @startTime1 DATETIME;
      DECLARE @endTime1 DATETIME;

      DECLARE @startTime2 DATETIME;
      DECLARE @endTime2 DATETIME;

      DECLARE @startTime3 DATETIME;
      DECLARE @endTime3 DATETIME;

      DECLARE @startTime4 DATETIME;
      DECLARE @endTime4 DATETIME;

      SET @startTime1 = GETDATE()
      EXEC insertLocations
      PRINT ('exec insertLocations')
      SET @endTime1 = GETDATE()
      INSERT INTO TestRuns VALUES ('test_insert_locations', @startTime1, @endTime1)
      INSERT INTO TestRunTables VALUES (@@IDENTITY, 1, @startTime1, @endTime1)

      SET @startTime2 = GETDATE()
      EXEC deleteLocations
      PRINT ('exec deleteLocations')
      SET @endTime2 = GETDATE()
      INSERT INTO TestRuns VALUES ('test_delete_locations', @startTime2, @endTime2)
      INSERT INTO TestRunTables VALUES (@@IDENTITY, 1, @startTime1, @endTime1)

      SET @startTime3 = GETDATE()
      exec insertVideos
      print ('exec insertVideos')
      SET @endTime3 = GETDATE()
      INSERT INTO TestRuns values ('test_insert_videos', @startTime3, @endTime3)
      INSERT INTO TestRunTables VALUES (@@IDENTITY, 2, @startTime3, @endTime3)

      SET @startTime4 = GETDATE()
      exec deleteVideos
      print ('exec deleteVideos')
      SET @endTime4 = GETDATE()
      INSERT INTO TestRuns values ('test_delete_videos', @startTime4, @endTime4)
      INSERT INTO TestRunTables VALUES (@@IDENTITY, 2, @startTime4, @endTime4)

    end
  GO
exec TestRunView
exec TestRunInsertRemove
