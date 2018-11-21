use VideoRental

-- modify the type of a column;

GO
CREATE PROC downVersion1
    AS
    ALTER TABLE Identities ALTER COLUMN cnp VARCHAR(40)
GO

CREATE PROC upVersion0
    AS
    ALTER TABLE Identities ALTER COLUMN cnp VARCHAR(15);
GO

--add/remove column

CREATE PROC downVersion2
    AS
    ALTER TABLE Videos ADD newColumn VARCHAR(50)
GO

CREATE PROC upVersion1
    AS
    ALTER TABLE Videos DROP COLUMN newColumn
GO

--add/remove default constraint

CREATE PROC downVersion3
    AS
    ALTER TABLE Videos ADD CONSTRAINT name_constraint  DEFAULT 'NoName' FOR name
GO

CREATE PROC upVersion2
    AS
    ALTER TABLE Videos DROP CONSTRAINT name_constraint
GO

-- remove/add a candidate key

CREATE PROC downVersion4
    AS
    --REMOVE EXISTING PK + UNIQUE

    ALTER TABLE Rentals DROP CONSTRAINT RentalPK
GO

CREATE PROC upVersion3
    AS
    ALTER TABLE Rentals ADD CONSTRAINT RentalPK PRIMARY KEY  (videoID, costumerID, employeeID)
GO

--remove/add a primary key;
DROP PROC downVersion5

CREATE PROC downVersion5
    AS
    --REMOVE FIRST THE FK IN RENTALS, THAN THE PK
    ALTER TABLE Rentals DROP CONSTRAINT RentalsCostumersFK
    ALTER TABLE Costumers DROP CONSTRAINT CostumersPK
GO

CREATE PROC upVersion4
    AS
    --ADD BACK THE PK IN Costumers
    --THAN ADD BACK THE FK IN RENTALS
    ALTER TABLE Costumers ADD CONSTRAINT CostumersPK PRIMARY KEY (costumerID)
    ALTER TABLE Rentals ADD CONSTRAINT RentalsCostumersFK FOREIGN KEY (costumerID) REFERENCES Costumers(costumerID)
GO

-- remove/add a foreign key;
DROP PROC downVersion6
DROP PROC upVersion5

CREATE PROC downVersion6
    AS
    --REMOVE FK IDENTITY FROM COSTUMERS
    ALTER TABLE Costumers DROP CONSTRAINT CostumersIdentityFK
GO

CREATE PROC upVersion5
    AS
    --ADD FK IDENTITY BACK
    ALTER TABLE Costumers ADD CONSTRAINT CostumersIdentityFK FOREIGN KEY (identityID) REFERENCES Identities(identityID)
GO

--create / remove a table
CREATE PROC downVersion7
    AS
    CREATE TABLE NewTable (
        newColumn1 VARCHAR(10),
        newColumn2 TINYINT,
        newColumn3 INT
    );
GO

CREATE PROC upVersion6
    AS
    DROP TABLE NewTable
GO


CREATE TABLE Version ( version INT );
delete FROM Version
INSERT INTO Version values(0);

GO


drop procedure setVersion
  go
CREATE PROCEDURE setVersion @versionTo INT
  AS
  IF @versionTo < 0 OR @versionTo > 8
      PRINT 'Versions are between 0 and 7'
  ELSE
    BEGIN
      DECLARE @currentVersion INT
      DECLARE @procedureName VARCHAR(15)
      SET @currentVersion=(SELECT version from Version)
      WHILE @currentVersion < @versionTo
      BEGIN
        SET @currentVersion = @currentVersion + 1
        SET @procedureName = 'downVersion' + convert(VARCHAR(15), @currentVersion)
        PRINT @procedureName
        EXECUTE @procedureName
      END
      WHILE @currentVersion > @versionTo
      BEGIN
        SET @currentVersion = @currentVersion - 1
        SET @procedureName = 'upVersion' + convert(VARCHAR(15), @currentVersion)
        PRINT @procedureName
        EXECUTE @procedureName
      END
    END
  UPDATE Version SET version = @versionTo
GO


EXEC downVersion1
EXEC upVersion0
EXEC downVersion2
EXEC upVersion1
EXEC downVersion3
EXEC upVersion2
EXEC downVersion4
EXEC upVersion3
EXEC downVersion5
EXEC upVersion4
EXEC downVersion6
EXEC upVersion5
EXEC downVersion7
EXEC upVersion6

EXEC setVersion 0