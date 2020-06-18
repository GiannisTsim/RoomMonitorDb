USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS Monitor_Assign_tr;
GO

CREATE PROCEDURE Monitor_Assign_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2)  ,
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17),
    @RoomType NVARCHAR(100),
    @Room NVARCHAR(100),
    @Monitor NVARCHAR(100)
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

DELETE FROM MonitorUnassigned 
WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND MACAddress = @MACAddress;

UPDATE Monitor SET MonitorType = 'Room'
WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND MACAddress = @MACAddress;

INSERT INTO MonitorRoom
    (HotelChain, CountryCode, Town, Suburb, MACAddress, RoomType, Room, Monitor, PlacementDtm)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @MACAddress, @RoomType, @Room, @Monitor, CURRENT_TIMESTAMP);

COMMIT
GO