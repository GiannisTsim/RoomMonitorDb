USE RoomMonitor
GO

-- SELECT * FROM SensorMeasure WHERE MACAddress = @MACAddress;

DECLARE @HotelChain NVARCHAR(100) = 'TestHotel1',
        @CountryCode VARCHAR(2) = 'GR',
        @Town NVARCHAR(100) = 'Athens',
        @Suburb NVARCHAR(100) = 'Aigaleo',
        @RoomType1 NVARCHAR(100) = 'Dinning Room',
        @Room1 NVARCHAR(100) = 'room1',
        @MACAddress11 VARCHAR(17) = '00:00:00:00:00:00',
        @Monitor11 NVARCHAR(100) = 'm1',
        @RoomType2 NVARCHAR(100) = 'Double Guest Room',
        @Room2 NVARCHAR(100) = 'room2',
        @MACAddress21 VARCHAR(17) = '01:02:03:04:05:06',
        @Monitor21 NVARCHAR(100) = 'g1',
        @MACAddress22 VARCHAR(17) = 'xx:xx:xx:xx:xx:xx',
        @Monitor22 NVARCHAR(100) = 'test',
        @ApplicationMeasure NVARCHAR(100),
        @ReadingDtm DATETIME,
        @Value DECIMAL(6,3);


SET @ReadingDtm = CURRENT_TIMESTAMP;

EXEC ReadingMeasure_Add_tr @MACAddress11, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType1, @Room1, @Monitor11, 'Temperature', @ReadingDtm, 25;
EXEC ReadingMeasure_Add_tr @MACAddress21, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor21, 'Temperature', @ReadingDtm, 13;
EXEC ReadingMeasure_Add_tr @MACAddress22, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor22, 'Temperature', @ReadingDtm, 32;

EXEC ReadingMeasure_Add_tr @MACAddress11, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType1, @Room1, @Monitor11, 'Acidity', @ReadingDtm, 6;
EXEC ReadingMeasure_Add_tr @MACAddress22, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor22, 'Acidity', @ReadingDtm, 4;

EXEC ReadingMeasure_Add_tr @MACAddress21, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor21, 'Luminosity', @ReadingDtm, 50;

WAITFOR DELAY '00:00:02';
SET @ReadingDtm = CURRENT_TIMESTAMP;

EXEC ReadingMeasure_Add_tr @MACAddress11, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType1, @Room1, @Monitor11, 'Temperature', @ReadingDtm, 27;
EXEC ReadingMeasure_Add_tr @MACAddress21, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor21, 'Temperature', @ReadingDtm, 11;
EXEC ReadingMeasure_Add_tr @MACAddress22, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor22, 'Temperature', @ReadingDtm, 38;

EXEC ReadingMeasure_Add_tr @MACAddress11, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType1, @Room1, @Monitor11, 'Acidity', @ReadingDtm, 5;
EXEC ReadingMeasure_Add_tr @MACAddress22, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor22, 'Acidity', @ReadingDtm, 5;

EXEC ReadingMeasure_Add_tr @MACAddress21, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor21, 'Luminosity', @ReadingDtm, 55;


WAITFOR DELAY '00:00:02';
SET @ReadingDtm = CURRENT_TIMESTAMP;

EXEC ReadingMeasure_Add_tr @MACAddress11, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType1, @Room1, @Monitor11, 'Temperature', @ReadingDtm, 28;
EXEC ReadingMeasure_Add_tr @MACAddress21, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor21, 'Temperature', @ReadingDtm, 17;
EXEC ReadingMeasure_Add_tr @MACAddress22, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor22, 'Temperature', @ReadingDtm, 33;

EXEC ReadingMeasure_Add_tr @MACAddress11, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType1, @Room1, @Monitor11, 'Acidity', @ReadingDtm, 6;
EXEC ReadingMeasure_Add_tr @MACAddress22, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor22, 'Acidity', @ReadingDtm, 4;

EXEC ReadingMeasure_Add_tr @MACAddress21, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor21, 'Luminosity', @ReadingDtm, 48;


WAITFOR DELAY '00:00:02';
SET @ReadingDtm = CURRENT_TIMESTAMP;

EXEC ReadingMeasure_Add_tr @MACAddress11, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType1, @Room1, @Monitor11, 'Temperature', @ReadingDtm, 30;
EXEC ReadingMeasure_Add_tr @MACAddress21, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor21, 'Temperature', @ReadingDtm, 19;
EXEC ReadingMeasure_Add_tr @MACAddress22, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor22, 'Temperature', @ReadingDtm, 39;

EXEC ReadingMeasure_Add_tr @MACAddress11, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType1, @Room1, @Monitor11, 'Acidity', @ReadingDtm, 7;
EXEC ReadingMeasure_Add_tr @MACAddress22, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor22, 'Acidity', @ReadingDtm, 7;

EXEC ReadingMeasure_Add_tr @MACAddress21, @HotelChain, @CountryCode, @Town, @Suburb, @RoomType2, @Room2, @Monitor21, 'Luminosity', @ReadingDtm, 40;


SELECT
    *
FROM
    Reading;
SELECT
    *
FROM
    ReadingMeasure;

SELECT
    *
FROM
    Monitor;
SELECT
    *
FROM
    MonitorRoom;

SELECT
    *
FROM
    SensorMeasure;
DELETE FROM ReadingMeasure;
DELETE FROM Reading;

SELECT
    DISTINCT
    HotelChain,
    CountryCode,
    Town,
    Suburb,
    RoomType,
    Room,
    Monitor
FROM
    Reading