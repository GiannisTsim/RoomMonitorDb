USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS ApplicationMeasure_Add_tr;
GO

CREATE PROCEDURE ApplicationMeasure_Add_tr
    @ApplicationMeasure NVARCHAR(100),
    @Name NVARCHAR(100),
    @Description NVARCHAR(256),
    @UnitMeasure NVARCHAR(100),
    @LimitMin DECIMAL = NULL,
    @LimitMax DECIMAL = NULL,
    @DefaultMin DECIMAL = NULL,
    @DefaultMax DECIMAL = NULL
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO [Application]
    ([Application], [Name], [Description], SensorType)
VALUES
    (@ApplicationMeasure, @Name, @Description, 'Measure');

INSERT INTO ApplicationMeasure
    (ApplicationMeasure, UnitMeasure)
VALUES
    (@ApplicationMeasure, @UnitMeasure);

IF (@LimitMin IS NOT NULL)
BEGIN
    INSERT INTO ApplicationLimit
        (ApplicationMeasure, LimitType, LimitValue)
    VALUES
        (@ApplicationMeasure, 'LimitMin', @LimitMin);
END

IF (@LimitMax IS NOT NULL)
BEGIN
    INSERT INTO ApplicationLimit
        (ApplicationMeasure, LimitType, LimitValue)
    VALUES
        (@ApplicationMeasure, 'LimitMax', @LimitMax);
END

IF (@DefaultMin IS NOT NULL)
BEGIN
    INSERT INTO ApplicationLimit
        (ApplicationMeasure, LimitType, LimitValue)
    VALUES
        (@ApplicationMeasure, 'DefaultMin', @DefaultMin);
END

IF (@DefaultMax IS NOT NULL)
BEGIN
    INSERT INTO ApplicationLimit
        (ApplicationMeasure, LimitType, LimitValue)
    VALUES
        (@ApplicationMeasure, 'DefaultMax', @DefaultMax);
END

COMMIT
GO