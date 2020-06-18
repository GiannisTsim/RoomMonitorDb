USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS SensorMeasureLimit_Drop_tr;
GO

CREATE PROCEDURE SensorMeasureLimit_Drop_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @ApplicationMeasure NVARCHAR(100),
    @LimitType VARCHAR(3) = NULL
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

IF (@LimitType IS NOT NULL)
BEGIN
    DELETE FROM SensorMeasureLimit
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND MACAddress = @MACAddress
        AND ApplicationMeasure = @ApplicationMeasure
        AND LimitType = @LimitType;
END
ELSE -- Delete all limits
BEGIN
    DELETE FROM SensorMeasureLimit
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND MACAddress = @MACAddress
        AND ApplicationMeasure = @ApplicationMeasure;
END


COMMIT
GO