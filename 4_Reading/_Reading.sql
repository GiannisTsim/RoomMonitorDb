USE RoomMonitor
GO

DROP TABLE IF EXISTS ReadingAlertAck;
DROP TABLE IF EXISTS ReadingAlert;

DROP TABLE IF EXISTS ReadingMeasure;
DROP TABLE IF EXISTS ReadingSwitch;
DROP TABLE IF EXISTS Reading;


CREATE TABLE Reading
(
    HotelChain    NVARCHAR(100) NOT NULL,
    CountryCode   NVARCHAR(2)   NOT NULL,
    Town          NVARCHAR(100) NOT NULL,
    Suburb        NVARCHAR(100) NOT NULL,
    RoomType      NVARCHAR(100) NOT NULL,
    Room          NVARCHAR(100) NOT NULL,
    Monitor       NVARCHAR(100) NOT NULL,
    [Application] NVARCHAR(100) NOT NULL,
    ReadingDtm    DATETIME      NOT NULL,
    -- ------------------------------------
    SensorType    NVARCHAR(100) NOT NULL,
    MACAddress    VARCHAR(17)   NOT NULL,
    CreatedAtDtm  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- ------------------------------------
    CONSTRAINT UC_Reading_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm),
    CONSTRAINT Room_Accumulates_Reading_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, RoomType, Room)
        REFERENCES Room (HotelChain, CountryCode, Town, Suburb, RoomType, Room),
    CONSTRAINT SensorType_Discriminates_Reading_fk
        FOREIGN KEY (SensorType)
        REFERENCES SensorType (SensorType)
    -- CONSTRAINT Reading_MonitorSensorIsValid_ck
    --     CHECK ( dbo.MonitorSensor_IsValid_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, [Application]) = 1)
)
GO


CREATE TABLE ReadingSwitch
(
    HotelChain        NVARCHAR(100) NOT NULL,
    CountryCode       NVARCHAR(2)   NOT NULL,
    Town              NVARCHAR(100) NOT NULL,
    Suburb            NVARCHAR(100) NOT NULL,
    RoomType          NVARCHAR(100) NOT NULL,
    Room              NVARCHAR(100) NOT NULL,
    Monitor           NVARCHAR(100) NOT NULL,
    ApplicationSwitch NVARCHAR(100) NOT NULL,
    ReadingDtm        DATETIME      NOT NULL,
    -- --------------------------------------
    [Value]           BIT           NOT NULL,
    -- --------------------------------------
    CONSTRAINT UC_ReadingSwitch_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, ApplicationSwitch, ReadingDtm),
    CONSTRAINT Reading_Is_ReadingSwitch_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, ApplicationSwitch, ReadingDtm)
        REFERENCES Reading (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm)
    -- CONSTRAINT ReadingSwitch_IsExclusive_ck
    --     CHECK ( dbo.Reading_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, ApplicationSwitch, ReadingDtm, 'Switch') = 1 )
)
GO


CREATE TABLE ReadingMeasure
(
    HotelChain         NVARCHAR(100) NOT NULL,
    CountryCode        NVARCHAR(2)   NOT NULL,
    Town               NVARCHAR(100) NOT NULL,
    Suburb             NVARCHAR(100) NOT NULL,
    RoomType           NVARCHAR(100) NOT NULL,
    Room               NVARCHAR(100) NOT NULL,
    Monitor            NVARCHAR(100) NOT NULL,
    ApplicationMeasure NVARCHAR(100) NOT NULL,
    ReadingDtm         DATETIME      NOT NULL,
    -- ---------------------------------------
    [Value]            DECIMAL(6,3)  NOT NULL,
    -- ---------------------------------------
    CONSTRAINT UC_ReadingMeasure_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, ApplicationMeasure, ReadingDtm),
    CONSTRAINT Reading_Is_ReadingMeasure_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, ApplicationMeasure, ReadingDtm)
        REFERENCES Reading (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm)
    -- CONSTRAINT ReadingMeasure_IsExclusive_ck
    --     CHECK ( dbo.Reading_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, ApplicationMeasure, ReadingDtm, 'Measure') = 1 )
)
GO


CREATE TABLE ReadingAlert
(
    HotelChain    NVARCHAR(100) NOT NULL,
    CountryCode   NVARCHAR(2)   NOT NULL,
    Town          NVARCHAR(100) NOT NULL,
    Suburb        NVARCHAR(100) NOT NULL,
    RoomType      NVARCHAR(100) NOT NULL,
    Room          NVARCHAR(100) NOT NULL,
    Monitor       NVARCHAR(100) NOT NULL,
    [Application] NVARCHAR(100) NOT NULL,
    ReadingDtm    DATETIME      NOT NULL,
    -- ------------------------------------
    AlertType     NVARCHAR(100) NOT NULL,
    AlertText     NVARCHAR(256) NOT NULL,
    -- ------------------------------------
    CONSTRAINT UC_ReadingAlert_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm),
    CONSTRAINT Reading_RegistersAs_ReadingAlert_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm)
        REFERENCES Reading (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm)
)
GO

CREATE TABLE ReadingAlertAck
(
    HotelChain    NVARCHAR(100) NOT NULL,
    CountryCode   NVARCHAR(2)   NOT NULL,
    Town          NVARCHAR(100) NOT NULL,
    Suburb        NVARCHAR(100) NOT NULL,
    RoomType      NVARCHAR(100) NOT NULL,
    Room          NVARCHAR(100) NOT NULL,
    Monitor       NVARCHAR(100) NOT NULL,
    [Application] NVARCHAR(100) NOT NULL,
    ReadingDtm    DATETIME      NOT NULL,
    -- ------------------------------------
    -- UserId      NVARCHAR(100) NOT NULL,
    AckDtm        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- ------------------------------------
    CONSTRAINT UC_ReadingAlertAck_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm),
    CONSTRAINT ReadingAlert_Is_ReadingAlertAck_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm)
        REFERENCES ReadingAlert (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ReadingDtm)
)