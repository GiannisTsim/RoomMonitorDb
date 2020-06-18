USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS Hotel_Drop_tr;
GO

CREATE PROCEDURE Hotel_Drop_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100)
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

DELETE FROM Room 
WHERE HotelChain=@HotelChain
    AND CountryCode=@CountryCode
    AND Town=@Town
    AND Suburb=@Suburb

DELETE FROM Person 
WHERE PersonId IN (
SELECT
    HotelUserId AS PersonId
FROM
    HotelUser
WHERE HotelChain=@HotelChain
    AND CountryCode=@CountryCode
    AND Town=@Town
    AND Suburb=@Suburb
);

DELETE FROM Hotel 
WHERE HotelChain=@HotelChain
    AND CountryCode=@CountryCode
    AND Town=@Town
    AND Suburb=@Suburb

COMMIT
GO