USE RoomMonitor
GO

DROP TYPE IF EXISTS TagTableType;
GO

CREATE TYPE TagTableType 
    AS TABLE (
    Tag NVARCHAR(100)
    );
GO