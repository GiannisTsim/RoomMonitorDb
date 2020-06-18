USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS Monitor_Register_tr;
GO

CREATE PROCEDURE Monitor_Register_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @ConfigurationType NVARCHAR(100),
    @Manufacturer NVARCHAR(100),
    @Model NVARCHAR(100),
    @SWVersion NVARCHAR(100),
    @SWUpdateDtm DATETIME
AS
SET NOCOUNT ON;
DECLARE @RegistrationInfo NVARCHAR(256),
        @RegistrationRequired BIT = 0
BEGIN TRANSACTION

IF NOT EXISTS (SELECT
    1
FROM
    Monitor
WHERE MACAddress = @MACAddress)
BEGIN
    SET @RegistrationInfo = 'Initial registration';
    SET @RegistrationRequired = 1;
END
ELSE IF EXISTS ( SELECT
    1
FROM
    Monitor
WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND MACAddress = @MACAddress
    AND ConfigurationType = @ConfigurationType
    AND SWVersion <> @SWVersion
)
BEGIN
    SET @RegistrationInfo = 'Software update registration';
    UPDATE Monitor 
    SET SWVersion = @SWVersion, SWUpdateDtm = @SWUpdateDtm 
    WHERE HotelChain = @HotelChain
        AND CountryCode = @CountryCode
        AND Town = @Town
        AND Suburb = @Suburb
        AND MACAddress = @MACAddress;

END
ELSE
DECLARE @CurrHotelChain NVARCHAR(100),
    @CurrCountryCode NVARCHAR(2),
    @CurrTown NVARCHAR(100),
    @CurrSuburb NVARCHAR(100),
    @CurrConfigurationType NVARCHAR(100),
    @CurrSWVersion NVARCHAR(100)

SELECT
    @CurrHotelChain = HotelChain,
    @CurrCountryCode = CountryCode,
    @CurrTown = Town,
    @CurrSuburb = Suburb,
    @CurrConfigurationType = ConfigurationType
FROM
    Monitor
WHERE MACAddress = @MACAddress

IF (@CurrHotelChain <> @HotelChain OR @CurrCountryCode <> @CountryCode OR @CurrTown <> @Town OR @CurrSuburb <> @Suburb) -- Relocation
BEGIN
    EXEC Monitor_Drop_tr @CurrHotelChain, @CurrCountryCode, @CurrTown, @CurrSuburb, @MACAddress;
    SET @RegistrationRequired = 1;
    IF (@CurrConfigurationType <> @ConfigurationType)
    BEGIN
        SET @RegistrationInfo = 'Relocation and Configuration update registration'
    END
    ELSE
    BEGIN
        SET @RegistrationInfo = 'Relocation registration'
    END
END
ELSE IF (@CurrConfigurationType <> @ConfigurationType)
BEGIN
    EXEC Monitor_Drop_tr @CurrHotelChain, @CurrCountryCode, @CurrTown, @CurrSuburb, @MACAddress;
    SET @RegistrationRequired = 1;
    SET @RegistrationInfo = 'Configuration update registration'
END

IF (@RegistrationRequired = 1)
BEGIN
    EXEC MonitorUnassigned_Add_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @ConfigurationType, @Manufacturer, @Model, @SWVersion, @SWUpdateDtm, @RegistrationInfo;

    -- Add SensorSwitch
    DECLARE @ApplicationSwitch NVARCHAR(100);

    DECLARE ConfigurationSwitches CURSOR
    FOR SELECT
        ApplicationSwitch
    FROM
        ConfigurationSwitch
    WHERE ConfigurationType = @ConfigurationType;

    OPEN ConfigurationSwitches;
    FETCH NEXT FROM ConfigurationSwitches INTO @ApplicationSwitch;

    WHILE @@FETCH_STATUS = 0  
    BEGIN
        EXEC SensorSwitch_Add_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @ApplicationSwitch;
        FETCH NEXT FROM ConfigurationSwitches INTO @ApplicationSwitch;
    END
    CLOSE ConfigurationSwitches;
    DEALLOCATE ConfigurationSwitches;

    -- Add SensorMeasure
    DECLARE @ApplicationMeasure NVARCHAR(100);

    DECLARE ConfigurationMeasures CURSOR
    FOR SELECT
        ApplicationMeasure
    FROM
        ConfigurationMeasure
    WHERE ConfigurationType = @ConfigurationType;

    OPEN ConfigurationMeasures;
    FETCH NEXT FROM ConfigurationMeasures INTO @ApplicationMeasure;

    WHILE @@FETCH_STATUS = 0  
    BEGIN
        EXEC SensorMeasure_Add_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @ApplicationMeasure;
        FETCH NEXT FROM ConfigurationMeasures INTO @ApplicationMeasure;
    END
    CLOSE ConfigurationMeasures;
    DEALLOCATE ConfigurationMeasures;
END

COMMIT
GO