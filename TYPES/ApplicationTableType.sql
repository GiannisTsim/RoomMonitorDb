USE RoomMonitor
GO

DROP TYPE IF EXISTS ApplicationTableType;
GO

CREATE TYPE ApplicationTableType 
    AS TABLE (
    [Application] NVARCHAR(100)
    );
GO