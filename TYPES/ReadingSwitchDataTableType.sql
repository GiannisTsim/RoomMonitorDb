USE RoomMonitor
GO

DROP TYPE IF EXISTS ReadingSwitchDataTableType;
GO

CREATE TYPE ReadingSwitchDataTableType
    AS TABLE (
    ReadingDtm DATETIME,
    [Value]    DECIMAL(6,3)
    );
GO