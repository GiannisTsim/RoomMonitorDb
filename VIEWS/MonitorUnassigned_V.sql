USE RoomMonitor
GO

DROP VIEW IF EXISTS MonitorUnassigned_V;
GO

CREATE VIEW MonitorUnassigned_V
AS
    SELECT
        *
    FROM
        Monitor
    WHERE MonitorType = 'Unassigned';
GO