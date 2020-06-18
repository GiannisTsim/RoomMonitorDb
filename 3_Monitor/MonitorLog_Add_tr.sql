USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS MonitorLog_Add_tr;
GO

CREATE PROCEDURE MonitorLog_Add_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @LogDtm DATETIME,
    @BatteryLevel DECIMAL,
    @ConnFail INT,
    @PostFail INT,
    @Rssi INT
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO MonitorLog
    (HotelChain, CountryCode, Town, Suburb, MACAddress, LogDtm, BatteryLevel, ConnFail, PostFail, Rssi)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @LogDtm, @BatteryLevel, @ConnFail, @PostFail, @Rssi)

COMMIT
GO

