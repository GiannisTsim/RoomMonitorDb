USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS SensorSwitch_Add_tr;
GO

CREATE PROCEDURE SensorSwitch_Add_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @ApplicationSwitch NVARCHAR(100)
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO MonitorSensor
    (HotelChain, CountryCode, Town, Suburb, MACAddress, [Application], SensorType)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @ApplicationSwitch, 'Switch');

INSERT INTO SensorSwitch
    (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationSwitch)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @ApplicationSwitch);

COMMIT
GO