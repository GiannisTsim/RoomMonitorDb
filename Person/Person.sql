USE RoomMonitor
GO

DROP TABLE IF EXISTS HotelUser;
DROP TABLE IF EXISTS SystemAdmin;
DROP TABLE IF EXISTS Person;
DROP TABLE IF EXISTS PersonType;

CREATE TABLE PersonType
(
    PersonTypeCode NVARCHAR(10) NOT NULL,
    -- ----------------------------------
    PersonType     NVARCHAR(50) NOT NULL,
    -- ----------------------------------
    CONSTRAINT UC_PersonTypeCode 
        PRIMARY KEY CLUSTERED (PersonTypeCode),
    CONSTRAINT U__PersonTypeName 
        UNIQUE (PersonType),
    CONSTRAINT PersonType_Name_ck 
        CHECK(PersonType <> N''),
    CONSTRAINT PersonType_PersonTypeCode_ck 
        CHECK(PersonTypeCode IN (N'SysAdmin', N'HotelAdmin', N'HotelEmp'))
);
GO
INSERT INTO PersonType
VALUES
    (N'SysAdmin', N'System Administrator'),
    (N'HotelAdmin', N'Hotel Administrator'),
    (N'HotelEmp', N'Hotel Employee')
GO



CREATE TABLE Person
(
    PersonId        INT           IDENTITY NOT NULL,
    -- ------------------------------------
    Email           NVARCHAR(100) NOT NULL,
    NormalizedEmail NVARCHAR(100) NOT NULL,
    PasswordHash    NVARCHAR(100),
    SecurityStamp   NVARCHAR(100) NOT NULL,
    PersonTypeCode  NVARCHAR(10)  NOT NULL,
    -- ------------------------------------
    CONSTRAINT UC_PersonId 
        PRIMARY KEY CLUSTERED (PersonId),
    CONSTRAINT PersonType_classifies_Person_fk 
        FOREIGN KEY (PersonTypeCode) 
        REFERENCES PersonType (PersonTypeCode)
);
GO

CREATE TABLE SystemAdmin
(
    SystemAdminId INT NOT NULL,
    -- ------------------------
    CONSTRAINT UC_SystemAdminId 
        PRIMARY KEY CLUSTERED (SystemAdminId),
    CONSTRAINT Person_is_SystemAdmin_fk 
        FOREIGN KEY (SystemAdminId) 
        REFERENCES Person (PersonId)
);
GO

CREATE TABLE HotelUser
(
    HotelUserId INT           NOT NULL,
    -- --------------------------------
    HotelChain  NVARCHAR(100) NOT NULL,
    CountryCode NVARCHAR(2)   NOT NULL,
    Town        NVARCHAR(100) NOT NULL,
    Suburb      NVARCHAR(100) NOT NULL,
    -- --------------------------------
    CONSTRAINT UC_HotelUserId 
        PRIMARY KEY CLUSTERED (HotelUserId),
    CONSTRAINT Person_is_HotelUser_fk 
        FOREIGN KEY (HotelUserId) 
        REFERENCES Person (PersonId),
    CONSTRAINT Hotel_employees_HotelUser_fk 
        FOREIGN KEY (HotelChain, CountryCode, Town, Suburb) 
        REFERENCES Hotel (HotelChain, CountryCode, Town, Suburb)
);
GO
