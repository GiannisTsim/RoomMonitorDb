USE RoomMonitor
GO

ALTER TABLE SensorSwitch
    DROP CONSTRAINT IF EXISTS SensorSwitch_IsExclusive_ck
ALTER TABLE SensorMeasure
    DROP CONSTRAINT IF EXISTS  SensorMeasure_IsExclusive_ck
DROP FUNCTION IF EXISTS MonitorSensor_IsSubtype_fn
GO

CREATE FUNCTION MonitorSensor_IsSubtype_fn (
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @Application NVARCHAR(100),
    @SensorType NVARCHAR(100)
    )
RETURNS BIT
AS
BEGIN
    RETURN (
        SELECT
        COALESCE( (
        SELECT 1                 -- Exists=1; Not Exists=Null
            FROM  MonitorSensor
            WHERE HotelChain = @HotelChain
            AND CountryCode = @CountryCode
            AND Town = @Town
            AND Suburb = @Suburb
            AND MACAddress = @MACAddress
            AND [Application] = @Application
            AND SensorType = @SensorType
           )
        , 0 )                    -- Substitute 0 for Null
    )
END
GO


ALTER TABLE SensorSwitch
    ADD CONSTRAINT SensorSwitch_IsExclusive_ck
        CHECK ( dbo.MonitorSensor_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationSwitch, 'Switch') = 1 )

ALTER TABLE SensorMeasure
    ADD CONSTRAINT SensorMeasure_IsExclusive_ck
        CHECK ( dbo.MonitorSensor_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationMeasure, 'Measure') = 1 )
GO