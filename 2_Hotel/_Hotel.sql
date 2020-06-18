USE RoomMonitor
GO

DROP TABLE IF EXISTS MonitorRoom;
DROP TABLE IF EXISTS MonitorUnassigned;
DROP TABLE IF EXISTS Monitor;
DROP TABLE IF EXISTS DeviceType;
DROP TABLE IF EXISTS [Configuration];

DROP TABLE IF EXISTS HotelUser;
DROP TABLE IF EXISTS SystemAdmin;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS PersonType;

DROP TABLE IF EXISTS RoomTag;
DROP TABLE IF EXISTS HotelTag;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS HotelNetwork;
DROP TABLE IF EXISTS Hotel;
DROP TABLE IF EXISTS HotelChain;
DROP TABLE IF EXISTS RoomType;


CREATE TABLE RoomType
(
    RoomType      NVARCHAR(100) NOT NULL,
    -- ----------------------------------
    [Description] NVARCHAR(256) NOT NULL DEFAULT N'',
    -- ----------------------------------
    CONSTRAINT UC_RoomType 
        PRIMARY KEY CLUSTERED (RoomType),
    CONSTRAINT RoomType_ck 
        CHECK(RoomType <> N'')
);
GO
INSERT INTO RoomType
    (RoomType)
VALUES
    (N'Reception'),
    (N'Dinning Room'),
    (N'Pool'),
    (N'Kitchen'),
    (N'Toilet'),
    (N'Single Guest Room'),
    (N'Double Guest Room'),
    (N'Triple Guest Room'),
    (N'Suite')
GO

CREATE TABLE HotelChain
(
    HotelChain NVARCHAR(100) NOT NULL,
    -- -------------------------------
    FullName   NVARCHAR(100) NOT NULL,
    -- -------------------------------
    CONSTRAINT UC_HotelChain 
        PRIMARY KEY CLUSTERED (HotelChain),
    CONSTRAINT U__FullName 
        UNIQUE (FullName),
    CONSTRAINT HotelChain_HotelChain_ck 
        CHECK(HotelChain <> N''),
    CONSTRAINT HotelChain_FullName_ck 
        CHECK(FullName <> N'')
);
GO

CREATE TABLE Hotel
(
    HotelChain  NVARCHAR(100) NOT NULL,
    CountryCode NVARCHAR(2)   NOT NULL,
    Town        NVARCHAR(100) NOT NULL,
    Suburb      NVARCHAR(100) NOT NULL,
    -- --------------------------------
    NumStar     INT           NOT NULL,
    -- --------------------------------
    CONSTRAINT UC_Hotel_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb),
    CONSTRAINT HotelChain_Franchises_Hotel_fk 
        FOREIGN KEY (HotelChain) 
        REFERENCES HotelChain (HotelChain),
    CONSTRAINT Hotel_CountryCode_ck 
        CHECK(CountryCode <> N''),
    CONSTRAINT Hotel_Town_ck 
        CHECK(Town <> N''),
    CONSTRAINT Hotel_Suburb_ck
        CHECK(Suburb <> N''),
    CONSTRAINT Hotel_NumStar_ck 
        CHECK(NumStar >= 0 AND NumStar <= 5)
);
GO

CREATE TABLE HotelNetwork
(
    HotelChain       NVARCHAR(100) NOT NULL,
    CountryCode      NVARCHAR(2)   NOT NULL,
    Town             NVARCHAR(100) NOT NULL,
    Suburb           NVARCHAR(100) NOT NULL,
    -- -------------------------------------
    MACAddress_Host  VARCHAR(17)   NOT NULL,
    RegistrationDtm  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    RegistrationInfo NVARCHAR(256) NOT NULL DEFAULT '',
    -- -------------------------------------
    CONSTRAINT UC_HotelNetwork_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb),
    CONSTRAINT U__MACAddress_Host 
        UNIQUE (MACAddress_Host),
    CONSTRAINT Hotel_IsServeBy_HotelNetwork_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb)
        REFERENCES Hotel (HotelChain, CountryCode, Town, Suburb),
    -- CONSTRAINT HotelNetwork_LANAddress_ck 
    --     CHECK ( 
    --     LANAddress LIKE     '%_.%_.%_' -- 2 periods and no empty octets 
    --     AND LANAddress NOT LIKE '%.%.%.%' -- not 3 periods or more 
    --     AND LANAddress NOT LIKE '%[^0-9.]%' -- no characters other than digits and periods 
    --     AND LANAddress NOT LIKE '%[0-9][0-9][0-9][0-9]%' -- not more than 3 digits per octet 
    --     AND LANAddress NOT LIKE '%[3-9][0-9][0-9]%' -- NOT 300 - 999 
    --     AND LANAddress NOT LIKE '%2[6-9][0-9]%' -- NOT 260 - 299 
    --     AND LANAddress NOT LIKE '%25[6-9]%'  -- NOT 256 - 259 
    --     )
);
GO


CREATE TABLE Room
(
    HotelChain  NVARCHAR(100) NOT NULL,
    CountryCode NVARCHAR(2)   NOT NULL,
    Town        NVARCHAR(100) NOT NULL,
    Suburb      NVARCHAR(100) NOT NULL,
    RoomType    NVARCHAR(100) NOT NULL,
    Room        NVARCHAR(100) NOT NULL,
    -- --------------------------------
    CONSTRAINT UC_Room_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, RoomType, Room),
    CONSTRAINT Hotel_Offers_Room_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb) 
        REFERENCES Hotel(HotelChain, CountryCode, Town, Suburb),
    CONSTRAINT RoomType_Describes_Room_fk 
        FOREIGN KEY (RoomType) 
        REFERENCES RoomType(RoomType),
    CONSTRAINT Room_Room_ck 
        CHECK(Room <> N'')
);
GO


CREATE TABLE HotelTag
(
    HotelChain    NVARCHAR(100) NOT NULL,
    CountryCode   NVARCHAR(2)   NOT NULL,
    Town          NVARCHAR(100) NOT NULL,
    Suburb        NVARCHAR(100) NOT NULL,
    Tag           NVARCHAR(100) NOT NULL,
    -- ----------------------------------
    [Description] NVARCHAR(256) NOT NULL DEFAULT N'',
    -- ----------------------------------
    CONSTRAINT UC_HotelTag_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, Tag),
    CONSTRAINT Hotel_Declares_HotelTag_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb)
        REFERENCES Hotel (HotelChain, CountryCode, Town, Suburb)
);
GO

CREATE TABLE RoomTag
(
    HotelChain  NVARCHAR(100) NOT NULL,
    CountryCode NVARCHAR(2)   NOT NULL,
    Town        NVARCHAR(100) NOT NULL,
    Suburb      NVARCHAR(100) NOT NULL,
    RoomType    NVARCHAR(100) NOT NULL,
    Room        NVARCHAR(100) NOT NULL,
    Tag         NVARCHAR(100) NOT NULL,
    -- --------------------------------
    CONSTRAINT UC_RoomTag_PK 
        PRIMARY KEY CLUSTERED (HotelChain, CountryCode, Town, Suburb, RoomType, Room, Tag),
    CONSTRAINT Room_IsNotedAs_HotelTag_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, RoomType, Room) 
        REFERENCES Room (HotelChain, CountryCode, Town, Suburb, RoomType, Room),
    CONSTRAINT HotelTag_Annotates_Room_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb, Tag) 
        REFERENCES HotelTag (HotelChain, CountryCode, Town, Suburb, Tag)
);
GO