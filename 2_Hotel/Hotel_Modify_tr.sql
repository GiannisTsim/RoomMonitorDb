USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS Hotel_Modify_tr;
GO

CREATE PROCEDURE Hotel_Modify_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @NewHotelChain NVARCHAR(100),
    @NewCountryCode NVARCHAR(2),
    @NewTown NVARCHAR(100),
    @NewSuburb NVARCHAR(100),
    @NewNumStar INT
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

IF (@HotelChain = @NewHotelChain AND @CountryCode = @NewCountryCode AND @Town = @NewTown AND @Suburb = @NewSuburb)
    BEGIN
    UPDATE Hotel 
    SET NumStar = @NewNumStar 
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
END
ELSE
BEGIN
    DECLARE @HotelUserIds TABLE (
        HotelUserId INT NOT NULL
    );

    EXEC Hotel_Add_tr  @NewHotelChain, @NewCountryCode, @NewTown, @NewSuburb, @NewNumStar;

    INSERT INTO Room
        (HotelChain, CountryCode, Town, Suburb, RoomType, Room)
    SELECT
        @NewHotelChain,
        @NewCountryCode,
        @NewTown,
        @NewSuburb,
        RoomType,
        Room
    FROM
        Room
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb;

    INSERT INTO @HotelUserIds
        (HotelUserId)
    SELECT
        HotelUserId
    FROM
        HotelUser
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb;

    -- ......

    DELETE FROM HotelUser
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb;

    DELETE FROM Room
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb;

    DELETE FROM Hotel
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb;

    INSERT INTO HotelUser
        (HotelUserId, HotelChain, CountryCode, Town, Suburb)
    SELECT
        HotelUserId,
        @NewHotelChain,
        @NewCountryCode,
        @NewTown,
        @NewSuburb
    FROM
        @HotelUserIds;

END
COMMIT
GO