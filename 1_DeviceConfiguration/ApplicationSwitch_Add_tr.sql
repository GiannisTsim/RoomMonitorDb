USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS ApplicationSwitch_Add_tr;
GO

CREATE PROCEDURE ApplicationSwitch_Add_tr
    @ApplicationSwitch NVARCHAR(100),
    @Name NVARCHAR(100),
    @Description NVARCHAR(256),
    @Value_0 NVARCHAR(100),
    @Value_1 NVARCHAR(100)
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO [Application]
    ([Application], [Name], [Description], SensorType)
VALUES
    (@ApplicationSwitch, @Name, @Description, 'Switch');

INSERT INTO ApplicationSwitch
    (ApplicationSwitch, Value_0, Value_1)
VALUES
    (@ApplicationSwitch, @Value_0, @Value_1);

COMMIT
GO