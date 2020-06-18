USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS ConfigurationType_Add_tr;
GO

CREATE PROCEDURE ConfigurationType_Add_tr
    @ConfigurationType NVARCHAR(100),
    @Description NVARCHAR(256),
    @ApplicationSwitchTVP APPLICATIONTABLETYPE READONLY,
    @ApplicationMeasureTVP APPLICATIONTABLETYPE READONLY
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO ConfigurationType
    (ConfigurationType, [Description])
VALUES
    (@ConfigurationType, @Description);

INSERT INTO ConfigurationSwitch
    (ConfigurationType, ApplicationSwitch)
SELECT
    @ConfigurationType,
    [Application]
FROM
    @ApplicationSwitchTVP;

INSERT INTO ConfigurationMeasure
    (ConfigurationType, ApplicationMeasure)
SELECT
    @ConfigurationType,
    [Application]
FROM
    @ApplicationMeasureTVP;

COMMIT
GO

