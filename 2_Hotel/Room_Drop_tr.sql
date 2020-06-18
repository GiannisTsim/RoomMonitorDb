USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS Room_Drop_tr;
GO

CREATE PROCEDURE Room_Drop_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @RoomType NVARCHAR(100),
    @Room NVARCHAR(100)
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

DELETE FROM RoomTag
    WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND RoomType = @RoomType
    AND Room = @Room;


DELETE FROM Room 
WHERE HotelChain=@HotelChain
    AND CountryCode=@CountryCode
    AND Town=@Town
    AND Suburb=@Suburb
    AND RoomType = @RoomType
    AND Room = @Room;

COMMIT
GO