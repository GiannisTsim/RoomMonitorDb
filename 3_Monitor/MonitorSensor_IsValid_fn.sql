USE RoomMonitor
GO

ALTER TABLE Reading
    DROP CONSTRAINT IF EXISTS Reading_MonitorSensorIsValid_ck
ALTER TABLE SensorError
    DROP CONSTRAINT IF EXISTS SensorError_MonitorSensorIsValid_ck
DROP FUNCTION IF EXISTS MonitorSensor_IsValid_fn
GO

CREATE FUNCTION MonitorSensor_IsValid_fn (
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @Application NVARCHAR(100)
    )
RETURNS BIT
AS
BEGIN
    DECLARE @IsValid BIT = 0;

    IF (EXISTS (SELECT
            1
        FROM
            MonitorSensor
        WHERE HotelChain = @HotelChain
            AND CountryCode = @CountryCode
            AND Town = @Town
            AND Suburb = @Suburb
            AND MACAddress = @MACAddress
            AND [Application] = @Application)
        )
        AND (EXISTS (SELECT
            1
        FROM
            MonitorRoom
        WHERE HotelChain = @HotelChain
            AND CountryCode = @CountryCode
            AND Town = @Town
            AND Suburb = @Suburb
            AND MACAddress = @MACAddress
           )
        )
    BEGIN
        SET @IsValid = 1;
    END

    RETURN @IsValid;
END
GO


ALTER TABLE Reading
    ADD CONSTRAINT Reading_MonitorSensorIsValid_ck
        CHECK ( dbo.MonitorSensor_IsValid_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, [Application]) = 1)
GO

ALTER TABLE SensorError
    ADD CONSTRAINT SensorError_MonitorSensorIsValid_ck
        CHECK ( dbo.MonitorSensor_IsValid_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, [Application]) = 1)
GO