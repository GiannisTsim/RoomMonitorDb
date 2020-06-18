USE RoomMonitor
GO



DROP PROCEDURE IF EXISTS SystemAdmin_Add_tr;
GO
CREATE PROCEDURE SystemAdmin_Add_tr
    (
    @PersonId INT OUTPUT,
    @Email NVARCHAR(100),
    @NormalizedEmail NVARCHAR(100),
    @PasswordHash NVARCHAR(100) = NULL,
    @SecurityStamp NVARCHAR(100)
)
AS
SET NOCOUNT ON;
DECLARE @PersonTypeCode NVARCHAR(10) = N'SysAdmin';

BEGIN TRANSACTION
-- Insert into Person and get new PersonId 
INSERT INTO Person
    (Email, NormalizedEmail, PasswordHash, SecurityStamp, PersonTypeCode)
VALUES
    (@Email, @NormalizedEmail, @PasswordHash, @SecurityStamp, @PersonTypeCode);
SELECT
    @PersonId = SCOPE_IDENTITY();

-- Insert into SystemAdmin with PersonId 
INSERT INTO SystemAdmin
VALUES
    (@PersonId);

COMMIT  

GO


DROP PROCEDURE IF EXISTS HotelEmployee_Add_tr;
GO
CREATE PROCEDURE HotelEmployee_Add_tr
    (
    @PersonId INT OUTPUT,
    @Email NVARCHAR(100),
    @NormalizedEmail NVARCHAR(100),
    @PasswordHash NVARCHAR(100) = NULL,
    @SecurityStamp NVARCHAR(100),
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100)
)
AS
SET NOCOUNT ON;
DECLARE @PersonTypeCode NVARCHAR(10) = N'HotelEmp';

BEGIN TRANSACTION
-- Insert into Person and get new PersonId  
INSERT INTO Person
    (Email, NormalizedEmail, PasswordHash, SecurityStamp, PersonTypeCode)
VALUES
    (@Email, @NormalizedEmail, @PasswordHash, @SecurityStamp, @PersonTypeCode);
SELECT
    @PersonId = SCOPE_IDENTITY();

INSERT INTO HotelUser
    (HotelUserId, HotelChain, CountryCode, Town, Suburb)
VALUES
    (@PersonId, @HotelChain, @CountryCode, @Town, @Suburb);

COMMIT  
GO


DROP PROCEDURE IF EXISTS HotelAdmin_Add_tr;
GO
CREATE PROCEDURE HotelAdmin_Add_tr
    (
    @PersonId INT OUTPUT,
    @Email NVARCHAR(100),
    @NormalizedEmail NVARCHAR(100),
    @PasswordHash NVARCHAR(100) = NULL,
    @SecurityStamp NVARCHAR(100),
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100)
)
AS
SET NOCOUNT ON;
DECLARE @PersonTypeCode NVARCHAR(10) = N'HotelAdmin';

BEGIN TRANSACTION
-- Insert into Person and get new PersonId  
INSERT INTO Person
    (Email, NormalizedEmail, PasswordHash, SecurityStamp, PersonTypeCode)
VALUES
    (@Email, @NormalizedEmail, @PasswordHash, @SecurityStamp, @PersonTypeCode);
SELECT
    @PersonId = SCOPE_IDENTITY();

INSERT INTO HotelUser
    (HotelUserId, HotelChain, CountryCode, Town, Suburb)
VALUES
    (@PersonId, @HotelChain, @CountryCode, @Town, @Suburb);

COMMIT  
    
GO


DROP PROCEDURE IF EXISTS Person_Modify_tr;
GO
CREATE PROCEDURE Person_Modify_tr
    (
    @PersonId INT,
    @Email NVARCHAR(100),
    @NormalizedEmail NVARCHAR(100),
    @PasswordHash NVARCHAR(100),
    @SecurityStamp NVARCHAR(100)
)
AS
SET NOCOUNT ON;

BEGIN TRANSACTION

UPDATE Person 
    SET Email = @Email, 
        NormalizedEmail = @NormalizedEmail, 
        SecurityStamp = @SecurityStamp,
        PasswordHash = @PasswordHash
    WHERE PersonId = @PersonId;

COMMIT  
GO


DROP PROCEDURE IF EXISTS HotelUser_Drop_tr;
GO
CREATE PROCEDURE HotelUser_Drop_tr
    (
    @HotelUserId INT,
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100)
)
AS
SET NOCOUNT ON;

BEGIN TRANSACTION

-- TODO: Check users hotel
DELETE FROM Person WHERE PersonId = @HotelUserId AND (PersonTypeCode = 'HotelAdmin' OR PersonTypeCode = 'HotelEmp');

COMMIT  
GO


-- DROP PROCEDURE IF EXISTS Person_FindById_tr;
-- GO
-- CREATE PROCEDURE Person_FindById_tr (
--     @PersonId INT
-- )
-- AS  
--     SET NOCOUNT ON;  

--     SELECT PersonId, Email, NormalizedEmail, PasswordHash, SecurityStamp, PersonType AS [Role], HotelId
--     FROM Person 
--     INNER JOIN PersonType
--     ON Person.PersonTypeCode = PersonType.PersonTypeCode
--     LEFT JOIN HotelUser
--     ON PersonId = HotelUserId
--     INNER JOIN Hotel
--     ON HotelUser.HotelChain = Hotel.HotelChain AND
--         HotelUser.CountryCode = Hotel.CountryCode AND 
--         HotelUser.Town = Hotel.Town AND 
--         HotelUser.Suburb = Hotel.Suburb 
--     WHERE PersonId = @PersonId;
-- GO

-- DROP PROCEDURE IF EXISTS Person_FindByNormalizedEmail_tr;
-- GO
-- CREATE PROCEDURE Person_FindByNormalizedEmail_tr (
--     @NormalizedEmail NVARCHAR(100)
-- )
-- AS  
--     SET NOCOUNT ON;  

--     SELECT PersonId, Email, NormalizedEmail, PasswordHash, SecurityStamp, PersonType AS [Role], HotelId
--     FROM Person 
--     INNER JOIN PersonType
--     ON Person.PersonTypeCode = PersonType.PersonTypeCode
--     LEFT JOIN HotelUser
--     ON PersonId = HotelUserId
--     INNER JOIN Hotel
--     ON HotelUser.HotelChain = Hotel.HotelChain AND
--         HotelUser.CountryCode = Hotel.CountryCode AND 
--         HotelUser.Town = Hotel.Town AND 
--         HotelUser.Suburb = Hotel.Suburb 
--     WHERE NormalizedEmail = @NormalizedEmail;
-- GO



-- DROP PROCEDURE IF EXISTS HotelUser_FindByHotelId_tr;
-- GO
-- CREATE PROCEDURE HotelUser_FindByHotelId_tr (
--     @HotelId INT
-- )
-- AS  
--     SET NOCOUNT ON;  

--     SELECT PersonId, Email, [Name] AS [Role]
--     FROM Person 
--     INNER JOIN PersonType
--     ON Person.PersonTypeCode = PersonType.PersonTypeCode
--     INNER JOIN HotelUser
--     ON PersonId = HotelUserId
--     WHERE HotelId = @HotelId;
-- GO


-- DROP PROCEDURE IF EXISTS HotelUser_FindByHotelId_JSON_tr;
-- GO
-- CREATE PROCEDURE HotelUser_FindByHotelId_JSON_tr
--     @HotelId INT
-- AS
--     SET NOCOUNT ON;
--     DECLARE @T TABLE (PersonId INT, Email NVARCHAR(100), [Role] NVARCHAR(50));

--     INSERT @T EXEC HotelUser_FindByHotelId_tr @HotelId;

--     SELECT ISNULL( 
--         (SELECT * FROM @T FOR JSON AUTO),
--         '[]'
--     )
-- GO