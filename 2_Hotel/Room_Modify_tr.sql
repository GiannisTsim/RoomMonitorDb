USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS Room_Modify_tr;
GO

CREATE PROCEDURE Room_Modify_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @RoomType NVARCHAR(100),
    @Room NVARCHAR(100),
    @NewRoomType NVARCHAR(100),
    @NewRoom NVARCHAR(100),
    @NewRoomTagTVP TAGTABLETYPE READONLY
AS
SET NOCOUNT ON;
BEGIN TRANSACTION


IF (@RoomType = @NewRoomType AND @Room = @NewRoom)
BEGIN

    DELETE FROM RoomTag
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND RoomType = @RoomType
        AND Room = @Room;

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
        @NewRoomTagTVP;

END
ELSE
BEGIN

    INSERT INTO Room
        (HotelChain, CountryCode, Town, Suburb, RoomType, Room)
    VALUES
        (@HotelChain, @CountryCode, @Town, @Suburb, @NewRoomType, @NewRoom);

    INSERT INTO RoomTag
        (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Tag)
    SELECT
        @HotelChain,
        @CountryCode,
        @Town,
        @Suburb,
        @NewRoomType,
        @NewRoom,
        Tag
    FROM
        @NewRoomTagTVP;


    DELETE FROM RoomTag
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND RoomType = @RoomType
        AND Room = @Room;

    DELETE FROM Room 
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND RoomType = @RoomType
        AND Room = @Room;

END

COMMIT
GO