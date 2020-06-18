USE RoomMonitor
GO

DELETE FROM ConfigurationSwitch;
DELETE FROM ApplicationSwitch;

DELETE FROM ApplicationLimit;
DELETE FROM ApplicationLimitType;
DELETE FROM ConfigurationMeasure;
DELETE FROM ApplicationMeasure;

DELETE FROM ConfigurationType;
DELETE FROM SensorType;
GO

-- ---------------------
-- Initialize references
-- ---------------------

INSERT INTO SensorType
    (SensorType, [Name], [Description])
VALUES
    ('Switch', 'Switch Sensor', 'Sensor monitoring state changes'),
    ('Measure', 'Measure Sensor', 'Sensor measuring a quantity')


INSERT INTO ApplicationLimitType
    (LimitType)
VALUES
    ('LimitMin'),
    ('LimitMax'),
    ('DefaultMin'),
    ('DefaultMax');
GO


-- ---------------------
-- Seed ApplicationTypes
-- ---------------------

EXEC ApplicationSwitch_Add_tr 'Door', 'Door Sensor', 'Monitoring open/close state of doors', 'Open', 'Closed';
EXEC ApplicationSwitch_Add_tr 'Window', 'Window Sensor', 'Monitoring open/close state of window', 'Open', 'Closed';

EXEC ApplicationMeasure_Add_tr 'Temperature', 'Temperature', 'Measuring temperature', 'Celsius', -20, 100, -10, 70;
EXEC ApplicationMeasure_Add_tr 'Humidity', 'Humidity', 'Measuring humidity', 'Percent', 0, 100;
EXEC ApplicationMeasure_Add_tr 'Luminosity', 'Luminosity', 'Measuring luminosity', 'Lumen';
EXEC ApplicationMeasure_Add_tr 'Acidity', 'Acidity', 'Measuring water acidity', 'PH', 0, 14;
EXEC ApplicationMeasure_Add_tr 'Sound', 'Sound', 'Measuring sound level', 'Decibel';
EXEC ApplicationMeasure_Add_tr 'Air Quality', 'Air Quality', 'Measuring air quality', '...';

-- ---------------------
-- Seed ConfigurationTypes
-- ---------------------

DECLARE @AppicationSwitchTVP APPLICATIONTABLETYPE;
DECLARE @AppicationMeasureTVP APPLICATIONTABLETYPE;

INSERT INTO @AppicationMeasureTVP
VALUES
    ('Temperature'),
    ('Acidity');
EXEC ConfigurationType_Add_tr 'GH_POOL', 'Device installed in pools', @AppicationSwitchTVP, @AppicationMeasureTVP;
DELETE FROM @AppicationSwitchTVP;
DELETE FROM @AppicationMeasureTVP;

INSERT INTO @AppicationSwitchTVP
VALUES
    ('Door');
INSERT INTO @AppicationMeasureTVP
VALUES
    ('Temperature'),
    ('Humidity'),
    ('Luminosity'),
    ('Sound');
EXEC ConfigurationType_Add_tr 'GH_COMMON', 'Device installed in common areas', @AppicationSwitchTVP, @AppicationMeasureTVP;
DELETE FROM @AppicationSwitchTVP;
DELETE FROM @AppicationMeasureTVP;

INSERT INTO @AppicationSwitchTVP
VALUES
    ('Window');
INSERT INTO @AppicationMeasureTVP
VALUES
    ('Temperature'),
    ('Humidity'),
    ('Luminosity');
EXEC ConfigurationType_Add_tr 'GH_GUEST', 'Device installed in guest rooms', @AppicationSwitchTVP, @AppicationMeasureTVP;
DELETE FROM @AppicationSwitchTVP;
DELETE FROM @AppicationMeasureTVP;

-- -----------
-- Check state
-- -----------

SELECT
    *
FROM
    SensorType;

SELECT
    *
FROM
    ApplicationSwitch;

SELECT
    ApplicationMeasure.*,
    ApplicationLimit.LimitType,
    ApplicationLimit.LimitValue
FROM
    ApplicationMeasure
    INNER JOIN ApplicationLimit
    ON ApplicationMeasure.ApplicationMeasure = ApplicationLimit.ApplicationMeasure;



    SELECT
        ConfigurationType.ConfigurationType,
        'Switch' AS SensorType,
        ApplicationSwitch AS ApplicationType
    FROM
        ConfigurationType
        INNER JOIN ConfigurationSwitch
        ON ConfigurationType.ConfigurationType = ConfigurationSwitch.ConfigurationType
UNION
    SELECT
        ConfigurationType.ConfigurationType,
        'Measure' AS SensorType,
        ApplicationMeasure AS ApplicationType
    FROM
        ConfigurationType
        INNER JOIN ConfigurationMeasure
        ON ConfigurationType.ConfigurationType = ConfigurationMeasure.ConfigurationType



SELECT
    *
FROM
    ConfigurationSwitch;

SELECT
    *
FROM
    ConfigurationMeasure;