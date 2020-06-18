USE RoomMonitor
GO

ALTER TABLE MonitorRoom
    DROP CONSTRAINT IF EXISTS MonitorRoom_IsExclusive_ck
ALTER TABLE MonitorUnassigned
    DROP CONSTRAINT IF EXISTS  MonitorUnassigned_IsExclusive_ck
DROP FUNCTION IF EXISTS Monitor_IsSubtype_fn
GO

CREATE FUNCTION Monitor_IsSubtype_fn (
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @MonitorType NVARCHAR(100)
    )
RETURNS BIT
AS
BEGIN
    RETURN (
        SELECT
        COALESCE( (
        SELECT 1                 -- Exists=1; Not Exists=Null
            FROM  Monitor
            WHERE HotelChain = @HotelChain
            AND CountryCode = @CountryCode
            AND Town = @Town
            AND Suburb = @Suburb
            AND MACAddress = @MACAddress
            AND MonitorType = @MonitorType
           )
        , 0 )                    -- Substitute 0 for Null
    )
END
GO


ALTER TABLE MonitorRoom
    ADD CONSTRAINT MonitorRoom_IsExclusive_ck
        CHECK ( dbo.Monitor_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, 'Room') = 1 )

ALTER TABLE MonitorUnassigned
    ADD CONSTRAINT MonitorUnassigned_IsExclusive_ck
        CHECK ( dbo.Monitor_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, 'Unassigned') = 1 )
GO