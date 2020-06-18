USE RoomMonitor
GO

ALTER TABLE ReadingSwitch
    DROP CONSTRAINT IF EXISTS ReadingSwitch_IsExclusive_ck
ALTER TABLE ReadingMeasure
    DROP CONSTRAINT IF EXISTS  ReadingMeasure_IsExclusive_ck
DROP FUNCTION IF EXISTS Reading_IsSubtype_fn
GO

CREATE FUNCTION Reading_IsSubtype_fn (
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @RoomType NVARCHAR(100),
    @Room NVARCHAR(100),
    @Monitor NVARCHAR(100),
    @Application NVARCHAR(100),
    @ReadingDtm DATETIME,
    @SensorType NVARCHAR(100)
    )
RETURNS BIT
AS
BEGIN
    RETURN (
        SELECT
        COALESCE( (
        SELECT 1                 -- Exists=1; Not Exists=Null
            FROM  Reading
            WHERE HotelChain = @HotelChain
            AND CountryCode = @CountryCode
            AND Town = @Town
            AND Suburb = @Suburb
            AND RoomType = @RoomType
            AND Room = @Room
            AND Monitor = @Monitor
            AND [Application] = @Application
            AND ReadingDtm = @ReadingDtm
            AND SensorType = @SensorType
           )
        , 0 )                    -- Substitute 0 for Null
    )
END
GO


ALTER TABLE ReadingSwitch
    ADD CONSTRAINT ReadingSwitch_IsExclusive_ck
        CHECK ( dbo.Reading_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, ApplicationSwitch, ReadingDtm, 'Switch') = 1 )

ALTER TABLE ReadingMeasure
    ADD CONSTRAINT ReadingMeasure_IsExclusive_ck
        CHECK ( dbo.Reading_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, ApplicationMeasure, ReadingDtm, 'Measure') = 1 )
GO