USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS Hotel_Add_tr;
GO

CREATE PROCEDURE Hotel_Add_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @NumStar INT
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

-- TEMP
IF NOT EXISTS (SELECT
    1
FROM
    HotelChain
WHERE HotelChain = @HotelChain)
BEGIN
    EXEC HotelChain_Add_tr @HotelChain;
END
-- --------------

INSERT INTO Hotel
    (HotelChain, CountryCode, Town, Suburb, Numstar)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @NumStar);

COMMIT
GO