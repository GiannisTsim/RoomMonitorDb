USE RoomMonitor
GO

ALTER TABLE ApplicationMeasure
    DROP CONSTRAINT IF EXISTS ApplicationMeasure_IsExclusive_ck
ALTER TABLE ApplicationSwitch
    DROP CONSTRAINT IF EXISTS  ApplicationSwitch_IsExclusive_ck
DROP FUNCTION IF EXISTS Application_IsSubtype_fn
GO

CREATE FUNCTION Application_IsSubtype_fn (
    @Application NVARCHAR(100),  -- Subtype/Parent PK
    @SensorType NVARCHAR(100)     -- Subtype Discriminator
    )
RETURNS BIT
AS
BEGIN
    RETURN (
        SELECT
        COALESCE( (
        SELECT 1                 -- Exists=1; Not Exists=Null
            FROM  [Application]
            WHERE [Application] = @Application
            AND SensorType = @SensorType
            )
        , 0 )                    -- Substitute 0 for Null
    )
END
GO


ALTER TABLE ApplicationMeasure
    ADD CONSTRAINT ApplicationMeasure_IsExclusive_ck
        CHECK ( dbo.Application_IsSubtype_fn (ApplicationMeasure, 'Measure') = 1 )

ALTER TABLE ApplicationSwitch
    ADD CONSTRAINT ApplicationSwitch_IsExclusive_ck
        CHECK ( dbo.Application_IsSubtype_fn (ApplicationSwitch, 'Switch') = 1 )
GO