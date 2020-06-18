USE RoomMonitor
GO

DROP PROCEDURE IF EXISTS HotelChain_Add_tr;
GO

CREATE PROCEDURE HotelChain_Add_tr
    @HotelChain NVARCHAR(100),
    @FullName NVARCHAR(100) = NULL
AS
SET NOCOUNT ON;
BEGIN TRANSACTION

INSERT INTO HotelChain
    (HotelChain, FullName)
VALUES
    (@HotelChain, COALESCE(@FullName, @HotelChain));

COMMIT
GO