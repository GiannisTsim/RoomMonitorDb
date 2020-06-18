USE RoomMonitor
GO

DROP TABLE IF EXISTS MonitorUnassignedAlertAck;
DROP TABLE IF EXISTS MonitorUnassignedAlert;
DROP TABLE IF EXISTS MonitorUnassigned;

DROP TABLE IF EXISTS SensorErrorAck;
DROP TABLE IF EXISTS SensorError;

DROP TABLE IF EXISTS SensorMeasureLimit;
DROP TABLE IF EXISTS SensorMeasureLimitType;
DROP TABLE IF EXISTS SensorMeasure;
DROP TABLE IF EXISTS SensorSwitch;
DROP TABLE IF EXISTS MonitorSensor;
DROP TABLE IF EXISTS MonitorRoom;

DROP TABLE IF EXISTS MonitorLog;
DROP TABLE IF EXISTS Monitor;
DROP TABLE IF EXISTS MonitorType;


CREATE TABLE MonitorType
(
    MonitorType NVARCHAR(100) NOT NULL,
    -- --------------------------------
    CONSTRAINT UC_MonitorType 
        PRIMARY KEY CLUSTERED (MonitorType),
    CONSTRAINT MonitorType_IsValid_ck 
        CHECK (MonitorType IN ('Room', 'Unassigned'))
)
GO
INSERT INTO MonitorType
VALUES
    ('Room'),
    ('Unassigned');
GO


CREATE TABLE Monitor
(
    HotelChain        NVARCHAR(100) NOT NULL,
    CountryCode       NVARCHAR(2)   NOT NULL,
    Town              NVARCHAR(100) NOT NULL,
    Suburb            NVARCHAR(100) NOT NULL,
    MACAddress        VARCHAR(17)   NOT NULL,
    -- -------------------------------------
    MonitorType       NVARCHAR(100) NOT NULL,
    ConfigurationType NVARCHAR(100) NOT NULL,
    Manufacturer      NVARCHAR(100) NOT NULL,
    Model             NVARCHAR(100) NOT NULL,
    SWVersion         NVARCHAR(100) NOT NULL,
    SWUpdateDtm       DATETIME      NOT NULL,
    RegistrationDtm   DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    RegistrationInfo  NVARCHAR(256) NOT NULL DEFAULT N'',
    -- -------------------------------------
    CONSTRAINT UC_Monitor_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, MACAddress),
    CONSTRAINT U__MACAddress 
        UNIQUE (MACAddress),
    CONSTRAINT Hotel_Registers_Monitor_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb) 
        REFERENCES Hotel(HotelChain, CountryCode, Town, Suburb),
    CONSTRAINT MonitorType_Discriminates_Monitor_fk 
        FOREIGN KEY (MonitorType) 
        REFERENCES MonitorType (MonitorType),
    -- CONSTRAINT HotelNetwork_Hosts_Monitor_fk 
    --     FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, LANAddress)
    --     REFERENCES HotelNetwork (HotelChain, CountryCode, Town, Suburb, LANAddress),
    CONSTRAINT ConfigurationType_Defines_Monitor_fk 
        FOREIGN KEY (ConfigurationType) 
        REFERENCES ConfigurationType (ConfigurationType),
    -- CONSTRAINT Monitor_IPAddress_ck 
    --     CHECK ( 
    --     LANAddress LIKE     '%_.%_.%_.%_' -- 3 periods and no empty octets 
    --     AND LANAddress NOT LIKE '%.%.%.%.%' -- not 4 periods or more 
    --     AND LANAddress NOT LIKE '%[^0-9.]%' -- no characters other than digits and periods 
    --     AND LANAddress NOT LIKE '%[0-9][0-9][0-9][0-9]%' -- not more than 3 digits per octet 
    --     AND LANAddress NOT LIKE '%[3-9][0-9][0-9]%' -- NOT 300 - 999 
    --     AND LANAddress NOT LIKE '%2[6-9][0-9]%' -- NOT 260 - 299 
    --     AND LANAddress NOT LIKE '%25[6-9]%'  -- NOT 256 - 259 
    --     ),
    -- CONSTRAINT Monitor_IsLAN_ck 
    --     CHECK (
    --     PARSENAME(LANAddress, 1) = PARSENAME(IPAddress,2)
    --     AND PARSENAME(LANAddress, 2) = PARSENAME(IPAddress,3)
    --     AND PARSENAME(LANAddress, 3) = PARSENAME(IPAddress,4)
    --     ),
    CONSTRAINT Monitor_Manufacturer_ck 
        CHECK (Manufacturer <> N''),
    CONSTRAINT Monitor_Model_ck 
        CHECK (Model <> N'')
);
GO


CREATE TABLE MonitorLog
(
    HotelChain   NVARCHAR(100) NOT NULL,
    CountryCode  NVARCHAR(2)   NOT NULL,
    Town         NVARCHAR(100) NOT NULL,
    Suburb       NVARCHAR(100) NOT NULL,
    MACAddress   VARCHAR(17)   NOT NULL,
    LogDtm       DATETIME      NOT NULL,
    -- ---------------------------------
    BatteryLevel DECIMAL       NOT NULL,
    ConnFail     INT           NOT NULL,
    PostFail     INT           NOT NULL,
    Rssi         INT           NOT NULL,
    CreatedAtDtm DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- ---------------------------------
    CONSTRAINT UC_MotitorLog_PK
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, MACAddress, LogDtm),
    CONSTRAINT Monitor_Records_MonitorLog_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, MACAddress)
        REFERENCES Monitor (HotelChain, CountryCode, Town, Suburb, MACAddress),
    CONSTRAINT MonitorLog_BatteryLevel_ck
        CHECK (BatteryLevel >= 0 AND BatteryLevel <= 100),
    CONSTRAINT MonitorLog_ConnFail_ck
        CHECK (ConnFail >= 0),
    CONSTRAINT MonitorLog_PostFail_ck
        CHECK (PostFail >= 0)
);
GO


CREATE TABLE MonitorRoom
(
    HotelChain   NVARCHAR(100) NOT NULL,
    CountryCode  NVARCHAR(2)   NOT NULL,
    Town         NVARCHAR(100) NOT NULL,
    Suburb       NVARCHAR(100) NOT NULL,
    MACAddress   VARCHAR(17)   NOT NULL,
    -- ---------------------------------
    RoomType     NVARCHAR(100) NOT NULL,
    Room         NVARCHAR(100) NOT NULL,
    Monitor      NVARCHAR(100) NOT NULL,
    PlacementDtm DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- ---------------------------------
    CONSTRAINT UC_MonitorRoom_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, MACAddress),
    CONSTRAINT U__MonitorRoom_AK 
        UNIQUE (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor),
    CONSTRAINT Monitor_Is_MonitorRoom_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, MACAddress) 
        REFERENCES Monitor(HotelChain, CountryCode, Town, Suburb, MACAddress),
    CONSTRAINT Room_IsAssigned_MonitorRoom_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, RoomType, Room) 
        REFERENCES Room (HotelChain, CountryCode, Town, Suburb, RoomType, Room),
    -- CONSTRAINT MonitorRoom_IsExclusive_ck
    --     CHECK ( dbo.Monitor_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, 'Room') = 1 ),
    CONSTRAINT MonitorRoom_Monitor_ck 
        CHECK (Monitor <> N'')
);
GO


CREATE TABLE MonitorSensor
(
    HotelChain    NVARCHAR(100) NOT NULL,
    CountryCode   NVARCHAR(2)   NOT NULL,
    Town          NVARCHAR(100) NOT NULL,
    Suburb        NVARCHAR(100) NOT NULL,
    MACAddress    VARCHAR(17)   NOT NULL,
    [Application] NVARCHAR(100) NOT NULL,
    -- ----------------------------------
    SensorType    NVARCHAR(100) NOT NULL,
    -- ----------------------------------
    CONSTRAINT UC_MonitorSensor_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, MACAddress, [Application]),
    CONSTRAINT Monitor_Houses_MonitorSensor_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, MACAddress)
        REFERENCES Monitor (HotelChain, CountryCode, Town, Suburb, MACAddress),
    CONSTRAINT SensorType_Discriminates_MonitorSensor_fk
        FOREIGN KEY (SensorType)
        REFERENCES SensorType (SensorType)
);
GO


CREATE TABLE SensorSwitch
(
    HotelChain        NVARCHAR(100) NOT NULL,
    CountryCode       NVARCHAR(2)   NOT NULL,
    Town              NVARCHAR(100) NOT NULL,
    Suburb            NVARCHAR(100) NOT NULL,
    MACAddress        VARCHAR(17)   NOT NULL,
    ApplicationSwitch NVARCHAR(100) NOT NULL,
    -- --------------------------------------
    CONSTRAINT UC_SensorSwitch_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationSwitch),
    CONSTRAINT MonitorSensor_Is_SensorSwitch_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationSwitch)
        REFERENCES MonitorSensor (HotelChain, CountryCode, Town, Suburb, MACAddress, [Application]),
    CONSTRAINT ApplicationSwitch_Defines_SensorSwitch_fk
        FOREIGN KEY (ApplicationSwitch)
        REFERENCES ApplicationSwitch (ApplicationSwitch)
    -- CONSTRAINT SensorSwitch_IsExclusive_ck
    --     CHECK ( dbo.MonitorSensor_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationSwitch, 'Switch') = 1 )
);
GO


CREATE TABLE SensorMeasure
(
    HotelChain         NVARCHAR(100) NOT NULL,
    CountryCode        NVARCHAR(2)   NOT NULL,
    Town               NVARCHAR(100) NOT NULL,
    Suburb             NVARCHAR(100) NOT NULL,
    MACAddress         VARCHAR(17)   NOT NULL,
    ApplicationMeasure NVARCHAR(100) NOT NULL,
    -- --------------------------------------
    CONSTRAINT UC_SensorMeasure_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationMeasure),
    CONSTRAINT MonitorSensor_Is_SensorMeasure_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, MACAddress,  ApplicationMeasure)
        REFERENCES MonitorSensor (HotelChain, CountryCode, Town, Suburb, MACAddress, [Application]),
    CONSTRAINT ApplicationMeasure_Defines_SensorMeasure_fk
        FOREIGN KEY (ApplicationMeasure)
        REFERENCES ApplicationMeasure (ApplicationMeasure)
    -- CONSTRAINT SensorMeasure_IsExclusive_ck
    --     CHECK ( dbo.MonitorSensor_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationMeasure, 'Measure') = 1 )
);
GO


CREATE TABLE SensorMeasureLimitType
(
    LimitType VARCHAR(3) NOT NULL,
    -- -----------------------------
    CONSTRAINT UC_SensorMeasureLimitType_PK
        PRIMARY KEY CLUSTERED (LimitType)
);
GO

CREATE TABLE SensorMeasureLimit
(
    HotelChain         NVARCHAR(100) NOT NULL,
    CountryCode        NVARCHAR(2)   NOT NULL,
    Town               NVARCHAR(100) NOT NULL,
    Suburb             NVARCHAR(100) NOT NULL,
    MACAddress         VARCHAR(17)   NOT NULL,
    ApplicationMeasure NVARCHAR(100) NOT NULL,
    LimitType          VARCHAR(3)    NOT NULL,
    -- ---------------------------------------
    LimitValue         DECIMAL(6,3)  NOT NULL,
    -- ---------------------------------------
    CONSTRAINT UC_SensorMeasureLimit_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationMeasure, LimitType),
    CONSTRAINT SensorMeasure_IsConstrainedTo_SensorMeasureLimit_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationMeasure) 
        REFERENCES SensorMeasure(HotelChain, CountryCode, Town, Suburb, MACAddress, ApplicationMeasure),
    CONSTRAINT SensorMeasureLimitType_Brackets_SensorMeasureLimit_fk 
        FOREIGN KEY (LimitType) 
        REFERENCES SensorMeasureLimitType (LimitType)
);
GO


CREATE TABLE SensorError
(
    HotelChain    NVARCHAR(100) NOT NULL,
    CountryCode   NVARCHAR(2)   NOT NULL,
    Town          NVARCHAR(100) NOT NULL,
    Suburb        NVARCHAR(100) NOT NULL,
    RoomType      NVARCHAR(100) NOT NULL,
    Room          NVARCHAR(100) NOT NULL,
    Monitor       NVARCHAR(100) NOT NULL,
    [Application] NVARCHAR(100) NOT NULL,
    ErrorDtm      DATETIME      NOT NULL,
    -- ------------------------------------
    MACAddress    VARCHAR(17)   NOT NULL,
    ErrorType     NVARCHAR(100) NOT NULL,
    ErrorText     NVARCHAR(256) NOT NULL,
    -- ------------------------------------
    CONSTRAINT UC_SensorError_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ErrorDtm),
    CONSTRAINT Room_Registers_SensorError_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, RoomType, Room)
        REFERENCES Room (HotelChain, CountryCode, Town, Suburb, RoomType, Room)
    -- CONSTRAINT SensorError_MonitorSensorIsValid_ck
    --     CHECK ( dbo.MonitorSensor_IsValid_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, [Application]) = 1)
);
GO

CREATE TABLE SensorErrorAck
(
    HotelChain    NVARCHAR(100) NOT NULL,
    CountryCode   NVARCHAR(2)   NOT NULL,
    Town          NVARCHAR(100) NOT NULL,
    Suburb        NVARCHAR(100) NOT NULL,
    RoomType      NVARCHAR(100) NOT NULL,
    Room          NVARCHAR(100) NOT NULL,
    Monitor       NVARCHAR(100) NOT NULL,
    [Application] NVARCHAR(100) NOT NULL,
    ErrorDtm      DATETIME      NOT NULL,
    -- ------------------------------------
    -- UserId      NVARCHAR(100) NOT NULL,
    AckDtm        DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- ------------------------------------
    CONSTRAINT UC_SensorErrorAck_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ErrorDtm),
    CONSTRAINT SensorError_Is_SensorErrorAck_fk
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ErrorDtm)
        REFERENCES SensorError (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Monitor, [Application], ErrorDtm)
);
GO



CREATE TABLE MonitorUnassigned
(
    HotelChain  NVARCHAR(100) NOT NULL,
    CountryCode NVARCHAR(2)   NOT NULL,
    Town        NVARCHAR(100) NOT NULL,
    Suburb      NVARCHAR(100) NOT NULL,
    MACAddress  VARCHAR(17)   NOT NULL,
    -- --------------------------------
    CONSTRAINT UC_MonitorUnassigned_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, MACAddress),
    CONSTRAINT Monitor_Is_MonitorUnassigned_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, MACAddress) 
        REFERENCES Monitor(HotelChain, CountryCode, Town, Suburb, MACAddress)
    -- CONSTRAINT MonitorUnassigned_IsExclusive_ck
    --     CHECK ( dbo.Monitor_IsSubtype_fn (HotelChain, CountryCode, Town, Suburb, MACAddress, 'Unassigned') = 1 )
);
GO


CREATE TABLE MonitorUnassignedAlert
(
    HotelChain  NVARCHAR(100) NOT NULL,
    CountryCode NVARCHAR(2)   NOT NULL,
    Town        NVARCHAR(100) NOT NULL,
    Suburb      NVARCHAR(100) NOT NULL,
    MACAddress  VARCHAR(17)   NOT NULL,
    -- --------------------------------
    AlertDtm    DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- --------------------------------
    CONSTRAINT UC_MonitorUnassignedAlert_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, MACAddress),
    CONSTRAINT MonitorUnassigned_Is_MonitorUnassignedAlert_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, MACAddress) 
        REFERENCES MonitorUnassigned(HotelChain, CountryCode, Town, Suburb, MACAddress)
);
GO


CREATE TABLE MonitorUnassignedAlertAck
(
    HotelChain  NVARCHAR(100) NOT NULL,
    CountryCode NVARCHAR(2)   NOT NULL,
    Town        NVARCHAR(100) NOT NULL,
    Suburb      NVARCHAR(100) NOT NULL,
    MACAddress  VARCHAR(17)   NOT NULL,
    -- --------------------------------
    -- UserId      NVARCHAR(100) NOT NULL,
    AckDtm      DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    -- --------------------------------
    CONSTRAINT UC_MonitorUnassignedAlertAck_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, MACAddress),
    CONSTRAINT MonitorUnassignedAlert_Is_MonitorUnassignedAlertAck_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, MACAddress) 
        REFERENCES MonitorUnassigned(HotelChain, CountryCode, Town, Suburb, MACAddress)
);
GO