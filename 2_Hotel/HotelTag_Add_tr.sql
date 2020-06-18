USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS HotelTag_Add_tr;
GO

CREATE PROCEDURE HotelTag_Add_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @Tag NVARCHAR(100),
    @Description NVARCHAR(256)
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

IF NOT EXISTS (SELECT
    1
FROM
    HotelTag
WHERE HotelChain=@HotelChain
    AND CountryCode=@CountryCode
    AND Town=@Town
    AND Suburb=@Suburb
    AND Tag = @Tag)
BEGIN
    INSERT INTO HotelTag
    VALUES
        (@HotelChain, @CountryCode, @Town, @Suburb, @Tag, @Description)
END

COMMIT
GO


