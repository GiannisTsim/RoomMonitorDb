USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS Monitor_Drop_tr;
GO

CREATE PROCEDURE Monitor_Drop_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress NVARCHAR(17)
AS
SET NOCOUNT ON;
DECLARE @MonitorType NVARCHAR(100)
BEGIN TRANSACTION

SET @MonitorType = ( SELECT
    MonitorType
FROM
    Monitor
WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND MACAddress = @MACAddress );

IF (@MonitorType = 'Unassigned' )  -- Drop MonitorUnassigned
BEGIN
    DELETE FROM MonitorUnassignedAlertAck 
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND MACAddress = @MACAddress;

    DELETE FROM MonitorUnassignedAlert
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND MACAddress = @MACAddress;

    DELETE FROM MonitorUnassigned 
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND MACAddress = @MACAddress;
END
ELSE IF (@MonitorType = 'Room') -- Drop MonitorRoom
BEGIN
    DELETE FROM MonitorRoom
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND MACAddress = @MACAddress;
END


-- Drop MonitorSensors
DECLARE @Application NVARCHAR(100);

DECLARE MonitorSensorApplications CURSOR
FOR SELECT
    [Application]
FROM
    MonitorSensor
WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND MACAddress = @MACAddress;

OPEN MonitorSensorApplications;
FETCH NEXT FROM MonitorSensorApplications INTO @Application;

WHILE @@FETCH_STATUS = 0  
BEGIN
    EXEC MonitorSensor_Drop_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @Application;
    FETCH NEXT FROM MonitorSensorApplications INTO @Application;
END
CLOSE MonitorSensorApplications;
DEALLOCATE MonitorSensorApplications;


-- Drop MonitorLogs
DELETE FROM MonitorLog 
    WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND MACAddress = @MACAddress;

-- Drop Monitor
DELETE FROM Monitor
    WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND MACAddress = @MACAddress;

COMMIT
GO