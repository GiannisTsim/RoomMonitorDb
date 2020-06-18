USE RoomMonitor
GO

DROP VIEW IF EXISTS MonitorRoom_V;
GO

CREATE VIEW MonitorRoom_V
AS
    SELECT
        m.*,
        mr.RoomType,
        mr.Room,
        mr.Monitor,
        mr.PlacementDtm
    FROM
        Monitor AS m
        INNER JOIN MonitorRoom AS mr
        ON m.HotelChain = mr.HotelChain
            AND m.CountryCode = mr.CountryCode
            AND m.Town = mr.Town
            AND m.Suburb = mr.Suburb
            AND m.MACAddress = mr.MACAddress;
GO