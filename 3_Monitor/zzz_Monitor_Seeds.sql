USE RoomMonitor
GO



DECLARE @HotelChain NVARCHAR(100) = 'TestHotel1',
        @CountryCode VARCHAR(2) = 'GR',
        @Town NVARCHAR(100) = 'Athens',
        @Suburb NVARCHAR(100) = 'Aigaleo',
        @MACAddress VARCHAR(17) = '01:02:03:04:05:06',
        @ConfigurationType NVARCHAR(100) = 'GH_COMMON',
        @Manufacturer NVARCHAR(100) = 'Espressif',
        @Model NVARCHAR(100) = 'ESP32',
        @SWVersion NVARCHAR(100) = '0.0.1',
        @SWUpdateDtm DATETIME = CURRENT_TIMESTAMP

-- EXEC Monitor_Drop_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress
EXEC Monitor_Register_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @ConfigurationType, @Manufacturer, @Model, @SWVersion, @SWUpdateDtm;
GO

DECLARE @HotelChain NVARCHAR(100) = 'TestHotel1',
        @CountryCode VARCHAR(2) = 'GR',
        @Town NVARCHAR(100) = 'Athens',
        @Suburb NVARCHAR(100) = 'Aigaleo',
        @MACAddress VARCHAR(17) = 'FF:FF:FF:FF:FF:FF',
        @ConfigurationType NVARCHAR(100) = 'GH_GUEST',
        @Manufacturer NVARCHAR(100) = 'Espressif',
        @Model NVARCHAR(100) = 'ESP32',
        @SWVersion NVARCHAR(100) = '0.0.1',
        @SWUpdateDtm DATETIME = CURRENT_TIMESTAMP

-- EXEC Monitor_Drop_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress
EXEC Monitor_Register_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @ConfigurationType, @Manufacturer, @Model, @SWVersion, @SWUpdateDtm;
GO

DECLARE @HotelChain NVARCHAR(100) = 'TestHotel1',
        @CountryCode VARCHAR(2) = 'GR',
        @Town NVARCHAR(100) = 'Athens',
        @Suburb NVARCHAR(100) = 'Aigaleo',
        @MACAddress VARCHAR(17) = '00:00:00:00:00:00',
        @ConfigurationType NVARCHAR(100) = 'GH_POOL',
        @Manufacturer NVARCHAR(100) = 'Espressif',
        @Model NVARCHAR(100) = 'ESP32',
        @SWVersion NVARCHAR(100) = '0.0.1',
        @SWUpdateDtm DATETIME = CURRENT_TIMESTAMP

-- EXEC Monitor_Drop_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress
EXEC Monitor_Register_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @ConfigurationType, @Manufacturer, @Model, @SWVersion, @SWUpdateDtm;
GO


DECLARE @HotelChain NVARCHAR(100) = 'TestHotel1',
        @CountryCode VARCHAR(2) = 'GR',
        @Town NVARCHAR(100) = 'Athens',
        @Suburb NVARCHAR(100) = 'Aigaleo',
        @MACAddress VARCHAR(17) = '01:02:03:04:05:06',
        @RoomType NVARCHAR(100) = 'Dinning Room',
        @Room NVARCHAR(100) = 'room1',
        @Monitor NVARCHAR(100) = 'East Wall'

EXEC Monitor_Assign_tr @HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @RoomType, @Room, @Monitor;
GO


-- SELECT * FROM Room WHERE HotelChain = 'TestHotel1'
-- SELECT * FROM Monitor;

-- SELECT * FROM MonitorUnassigned_V;

-- SELECT * FROM MonitorRoom_V;

-- SELECT * FROM MonitorSensor;


 