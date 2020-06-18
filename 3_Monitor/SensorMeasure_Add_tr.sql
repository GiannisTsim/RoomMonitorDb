USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS SensorMeasure_Add_tr;
GO

CREATE PROCEDURE SensorMeasure_Add_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @ApplicationMeasure NVARCHAR(100)
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO MonitorSensor
    (HotelChain, CountryCode, Town, Suburb, MACAddress, [Application], SensorType)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @ApplicationMeasure, 'Measure');

INSERT INTO SensorMeasure
    (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationMeasure)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @ApplicationMeasure);

COMMIT
GO