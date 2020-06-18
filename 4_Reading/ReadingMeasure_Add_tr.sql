USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS ReadingMeasure_Add_tr;
GO

CREATE PROCEDURE ReadingMeasure_Add_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @RoomType NVARCHAR(100),
    @Room NVARCHAR(100),
    @Monitor NVARCHAR(100),
    @ApplicationMeasure NVARCHAR(100),
    @ReadingDtm DATETIME,
    @Value DECIMAL(6,3)
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO Reading
    (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm, SensorType, MACAddress)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @RoomType, @Room, @Monitor, @ApplicationMeasure, @ReadingDtm, 'Measure', @MACAddress)

INSERT INTO ReadingMeasure
    (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, ApplicationMeasure, ReadingDtm, [Value])
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @RoomType, @Room, @Monitor, @ApplicationMeasure, @ReadingDtm, @Value)

COMMIT
GO

