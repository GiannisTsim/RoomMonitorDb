USE RoomMonitor
GO

DROP TYPE IF EXISTS ReadingMeasureDataTableType;
GO

CREATE TYPE ReadingMeasureDataTableType
    AS TABLE (
    ReadingDtm DATETIME,
    [Value]    BIT
    );
GO