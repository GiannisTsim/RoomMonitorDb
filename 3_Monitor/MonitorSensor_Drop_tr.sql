USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS MonitorSensor_Drop_tr;
GO

CREATE PROCEDURE MonitorSensor_Drop_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @Application NVARCHAR(100)
AS
SET NOCOUNT ON;
DECLARE @SensorType NVARCHAR(100);
BEGIN TRANSACTION

SET @SensorType =
(SELECT
    SensorType
FROM
    MonitorSensor
WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND MACAddress = @MACAddress);

IF (@SensorType = 'Switch')
BEGIN
    DELETE FROM SensorSwitch
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND MACAddress = @MACAddress
        AND ApplicationSwitch = @Application;
END
ELSE IF (@SensorType = 'Measure')
BEGIN
    EXEC SensorMeasureLimit_Drop_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @Application;

    DELETE FROM SensorMeasure
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND MACAddress = @MACAddress
        AND ApplicationMeasure = @Application;
END


COMMIT
GO