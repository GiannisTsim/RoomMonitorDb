USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS MonitorUnassigned_Add_tr;
GO

CREATE PROCEDURE MonitorUnassigned_Add_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @ConfigurationType NVARCHAR(100),
    @Manufacturer NVARCHAR(100),
    @Model NVARCHAR(100),
    @SWVersion NVARCHAR(100),
    @SWUpdateDtm DATETIME,
    @RegistrationInfo NVARCHAR(256)
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO Monitor
    (HotelChain, CountryCode, Town, Suburb, MACAddress, MonitorType, ConfigurationType, Manufacturer, Model, SWVersion, SWUpdateDtm, RegistrationDtm, RegistrationInfo)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, 'Unassigned', @ConfigurationType, @Manufacturer, @Model, @SWVersion, @SWUpdateDtm, CURRENT_TIMESTAMP, @RegistrationInfo);

INSERT INTO MonitorUnassigned
    (HotelChain, CountryCode, Town, Suburb, MACAddress)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @MACAddress);

COMMIT
GO