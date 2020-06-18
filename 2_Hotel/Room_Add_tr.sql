USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS Room_Add_tr;
GO

CREATE PROCEDURE Room_Add_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @RoomType NVARCHAR(100),
    @Room NVARCHAR(100),
    @RoomTagTVP TAGTABLETYPE READONLY
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO Room
    (HotelChain, CountryCode, Town, Suburb, RoomType, Room)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @RoomType, @Room);

INSERT INTO RoomTag
    (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Tag)
SELECT
    @HotelChain,
    @CountryCode,
    @Town,
    @Suburb,
    @RoomType,
    @Room,
    Tag
FROM
    @RoomTagTVP;

COMMIT
GO