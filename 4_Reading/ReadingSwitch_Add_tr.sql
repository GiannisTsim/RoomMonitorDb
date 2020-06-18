USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS ReadingSwitch_Add_tr;
GO

CREATE PROCEDURE ReadingSwitch_Add_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @RoomType NVARCHAR(100),
    @Room NVARCHAR(100),
    @Monitor NVARCHAR(100),
    @ApplicationSwitch NVARCHAR(100),
    @ReadingDtm DATETIME,
    @Value BIT
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO Reading
    (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm, SensorType, MACAddress)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @RoomType, @Room, @Monitor, @ApplicationSwitch, @ReadingDtm, 'Switch', @MACAddress)

INSERT INTO ReadingSwitch
    (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, ApplicationSwitch, ReadingDtm, [Value])
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @RoomType, @Room, @Monitor, @ApplicationSwitch, @ReadingDtm, @Value)

COMMIT
GO

