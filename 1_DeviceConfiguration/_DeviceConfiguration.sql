USE RoomMonitor
GO


DROP TABLE IF EXISTS ApplicationLimit;
DROP TABLE IF EXISTS ApplicationLimitType;
DROP TABLE IF EXISTS ConfigurationMeasure;
DROP TABLE IF EXISTS ApplicationMeasure;

DROP TABLE IF EXISTS ConfigurationSwitch;
DROP TABLE IF EXISTS ApplicationSwitch;

DROP TABLE IF EXISTS [Application];
DROP TABLE IF EXISTS ConfigurationType;
DROP TABLE IF EXISTS SensorType;



CREATE TABLE SensorType
(
    SensorType    NVARCHAR(100) NOT NULL,
    -- ----------------------------------
    [Name]        NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(256) NOT NULL DEFAULT N'',
    -- ----------------------------------
    CONSTRAINT UC_SensorType 
        PRIMARY KEY CLUSTERED (SensorType),
    CONSTRAINT U__SensorType_AK 
        UNIQUE ([Name]),
    CONSTRAINT SensorType_SensorType_ck 
        CHECK (SensorType <> N''),
    CONSTRAINT SensorType_Name_ck 
        CHECK ([Name] <> N'')
);
GO


CREATE TABLE ConfigurationType
(
    ConfigurationType NVARCHAR(100) NOT NULL,
    -- --------------------------------------
    [Description]     NVARCHAR(256) NOT NULL DEFAULT N'',
    -- --------------------------------------
    CONSTRAINT UC_ConfigurationType 
        PRIMARY KEY CLUSTERED (ConfigurationType),
    CONSTRAINT DeviceType_DeviceType_ck 
        CHECK (ConfigurationType <> N'')
);
GO


CREATE TABLE [Application]
(
    [Application] NVARCHAR(100) NOT NULL,
    -- ----------------------------------
    [Name]        NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(256) NOT NULL DEFAULT N'',
    SensorType    NVARCHAR(100) NOT NULL,
    -- ----------------------------------
    CONSTRAINT UC_Application 
        PRIMARY KEY CLUSTERED ([Application]),
    CONSTRAINT SensorType_Discriminates_Application_fk
        FOREIGN KEY (SensorType)
        REFERENCES SensorType (SensorType),
    CONSTRAINT U__Application_AK 
        UNIQUE ([Name]),
    CONSTRAINT Application_Application_ck 
        CHECK ([Application] <> N''),
    CONSTRAINT Application_Name_ck 
        CHECK ([Name] <> N'')
);
GO


CREATE TABLE ApplicationSwitch
(
    ApplicationSwitch NVARCHAR(100) NOT NULL,
    -- --------------------------------------
    Value_0           NVARCHAR(100) NOT NULL,
    Value_1           NVARCHAR(100) NOT NULL,
    -- --------------------------------------
    CONSTRAINT UC_ApplicationSwitch 
        PRIMARY KEY CLUSTERED (ApplicationSwitch),
    CONSTRAINT Applcation_Is_ApplicationSwitch_fk
        FOREIGN KEY (ApplicationSwitch)
        REFERENCES [Application] ([Application]),
    -- CONSTRAINT ApplicationSwitch_IsExclusive_ck
    --     CHECK ( dbo.Application_IsSubtype_fn (ApplicationSwitch, 'Switch') = 1 ),
    CONSTRAINT ApplicationSwitch_Value_0_ck 
        CHECK (Value_0 <> N''),
    CONSTRAINT ApplicationSwitch_Value_1_ck 
        CHECK (Value_1 <> N'')

);
GO


CREATE TABLE ConfigurationSwitch
(
    ConfigurationType NVARCHAR(100) NOT NULL,
    ApplicationSwitch NVARCHAR(100) NOT NULL,
    -- --------------------------------------
    CONSTRAINT UC_ConfigurationSwitch_PK 
        PRIMARY KEY CLUSTERED (ConfigurationType, ApplicationSwitch),
    CONSTRAINT ConfigurationType_Delineates_ApplicationSwitch_fk
        FOREIGN KEY (ConfigurationType)
        REFERENCES ConfigurationType (ConfigurationType),
    CONSTRAINT ApplicationSwitch_IsDeployedIn_ConfigurationType_fk
        FOREIGN KEY (ApplicationSwitch)
        REFERENCES ApplicationSwitch (ApplicationSwitch)
);
GO


CREATE TABLE ApplicationMeasure
(
    ApplicationMeasure NVARCHAR(100) NOT NULL,
    -- ---------------------------------------
    UnitMeasure        NVARCHAR(100) NOT NULL,
    -- ---------------------------------------
    CONSTRAINT UC_ApplicationMeasure 
        PRIMARY KEY CLUSTERED (ApplicationMeasure),
    CONSTRAINT Application_Is_ApplicationMeasure_fk 
        FOREIGN KEY (ApplicationMeasure)
        REFERENCES [Application] ([Application]),
    -- CONSTRAINT ApplicationMeasure_IsExclusive_ck
    --     CHECK ( dbo.Application_IsSubtype_fn (ApplicationMeasure, 'Measure') = 1 ),
    CONSTRAINT ApplicationMeasure_UnitMeasure_ck 
        CHECK (UnitMeasure <> N'')
);
GO


CREATE TABLE ConfigurationMeasure
(
    ConfigurationType  NVARCHAR(100) NOT NULL,
    ApplicationMeasure NVARCHAR(100) NOT NULL,
    -- ---------------------------------------
    CONSTRAINT UC_ConfigurationMeasure_PK 
        PRIMARY KEY CLUSTERED (ConfigurationType, ApplicationMeasure),
    CONSTRAINT ConfigurationType_Delineates_ApplicationMeasure_fk
        FOREIGN KEY (ConfigurationType)
        REFERENCES ConfigurationType (ConfigurationType),
    CONSTRAINT ApplicationMeasure_IsDeployedIn_ConfigurationType_fk
        FOREIGN KEY (ApplicationMeasure)
        REFERENCES ApplicationMeasure (ApplicationMeasure)
);
GO


CREATE TABLE ApplicationLimitType
(
    LimitType NVARCHAR(100) NOT NULL,
    -- ------------------------------
    CONSTRAINT UC_ApplicationLimitType_PK
        PRIMARY KEY CLUSTERED (LimitType)
);
GO


CREATE TABLE ApplicationLimit
(
    ApplicationMeasure NVARCHAR(100) NOT NULL,
    LimitType          NVARCHAR(100) NOT NULL,
    -- ---------------------------------------
    LimitValue         DECIMAL(6,3)  NOT NULL,
    -- ---------------------------------------
    CONSTRAINT UC_ApplicationLimit_PK
        PRIMARY KEY CLUSTERED (ApplicationMeasure, LimitType),
    CONSTRAINT ApplicationLimitType_Brackets_ApplicationLimit_fk
        FOREIGN KEY (LimitType)
        REFERENCES ApplicationLimitType (LimitType),
    CONSTRAINT ApplicationMeasure_IsBracketedBy_ApplicationLimit_fk
        FOREIGN KEY (ApplicationMeasure)
        REFERENCES ApplicationMeasure (ApplicationMeasure)
);
GO