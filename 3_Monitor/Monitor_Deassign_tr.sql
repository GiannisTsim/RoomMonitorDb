USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS Monitor_Deassign_tr;
GO

CREATE PROCEDURE Monitor_Deassign_tr
    @HotelChain NVARCHAR(100),
    @CountryCode NVARCHAR(2),
    @Town NVARCHAR(100),
    @Suburb NVARCHAR(100),
    @MACAddress VARCHAR(17)
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

DELETE FROM MonitorRoom
WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND MACAddress = @MACAddress;

UPDATE Monitor SET MonitorType = 'Unassigned'
WHERE HotelChain = @HotelChain
    AND CountryCode = @CountryCode
    AND Town = @Town
    AND Suburb = @Suburb
    AND MACAddress = @MACAddress;

INSERT INTO MonitorUnassigned
    (HotelChain, CountryCode, Town, Suburb, MACAddress)
VALUES
    (@HotelChain, @CountryCode, @Town, @Suburb, @MACAddress);

COMMIT
GO