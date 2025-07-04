DROP TABLE IF EXISTS Properties;
DROP TABLE IF EXISTS Amenities;
DROP TABLE IF EXISTS PropertyAmenities;
DROP TABLE IF EXISTS Images;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS LikesDislikes;
DROP TABLE IF EXISTS PropertySaved;



CREATE TABLE IF NOT EXISTS Properties (
    ID INTEGER PRIMARY KEY,
    Name TEXT,
    Address TEXT,
    City TEXT,
    PostalCode TEXT,
    Description TEXT,
    PricePerCalenderMonth REAL,
    AvailabilityStatus BOOLEAN,
    Furnished BOOLEAN,
    Floor INTEGER,
    Bedrooms INTEGER,
    Bathrooms INTEGER,
    SizeSqm INTEGER,
    Latitude REAL,
    Longitude REAL
);



CREATE TABLE IF NOT EXISTS Amenities (
    ID INTEGER PRIMARY KEY ,
    Name VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS PropertyAmenities (
    PropertyID INT,
    AmenityID INT,
    PRIMARY KEY (PropertyID, AmenityID),
    FOREIGN KEY (PropertyID) REFERENCES Properties(ID),
    FOREIGN KEY (AmenityID) REFERENCES Amenities(ID)
);


CREATE TABLE IF NOT EXISTS Images (
    ID INTEGER PRIMARY KEY,
    PropertyID INTEGER,
    ImageURL TEXT,
    FOREIGN KEY (PropertyID) REFERENCES Properties(ID)
);

CREATE TABLE IF NOT EXISTS Users (
    ID INTEGER PRIMARY KEY,
    FirstName TEXT,
    LastName TEXT,
    City TEXT,
    Country TEXT,
    ProfileImage TEXT,
    Email TEXT UNIQUE,
    Password TEXT
);


CREATE TABLE IF NOT EXISTS LikesDislikes (
    ID INTEGER PRIMARY KEY,
    PropertyID INTEGER,
    UserID INTEGER,
    IsLike BOOLEAN,
    FOREIGN KEY (PropertyID) REFERENCES Properties(ID),
    FOREIGN KEY (UserID) REFERENCES Users(ID)
);

CREATE TABLE IF NOT EXISTS PropertySaved (
    ID INTEGER PRIMARY KEY,
    PropertyID INTEGER,
    UserID INTEGER,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PropertyID) REFERENCES Properties(ID),
    FOREIGN KEY (UserID) REFERENCES Users(ID)
);


-- Insert into Properties table
INSERT INTO Properties (Name, Address, City, PostalCode, Description, PricePerCalenderMonth, AvailabilityStatus, Furnished, Floor, Bedrooms, Bathrooms, SizeSqm, Latitude, Longitude)
VALUES ('Luxury Villa', '123 Elm Street', 'Springfield', '12345', 'A beautiful villa with modern amenities.', 5000.0, 1, 1, 2, 3, 2, 250, 34.052235, -118.243683);

INSERT INTO Properties (Name, Address, City, PostalCode, Description, PricePerCalenderMonth, AvailabilityStatus, Furnished, Floor, Bedrooms, Bathrooms, SizeSqm, Latitude, Longitude)
VALUES ('Cozy Cottage', '456 Maple Ave', 'Shelbyville', '67890', 'A charming cottage in a quiet neighborhood.', 2500.0, 1, 0, 1, 2, 1, 120, 40.712776, -74.005974);


-- Insert into Amenities table
INSERT INTO Amenities (Name)
VALUES ('Swimming Pool'),
       ('Gym'),
       ('Jacuzzi'),
       ('Parking'),
       ('Garden');


-- Insert into PropertyAmenities table
INSERT INTO PropertyAmenities (PropertyID, AmenityID)
VALUES (1, 1),  -- Property 1 has Swimming Pool
       (1, 2),  -- Property 1 has Gym
       (1, 3),  -- Property 1 has Jacuzzi
       (2, 4),  -- Property 2 has Parking
       (2, 5);  -- Property 2 has Garden


-- Insert into Images table
INSERT INTO Images (PropertyID, ImageURL)
VALUES (1, 'http://example.com/image1.jpg'),
       (1, 'http://example.com/image2.jpg'),
       (2, 'http://example.com/image3.jpg');


-- Insert into Users table
INSERT INTO Users (FirstName, LastName, City, Country, ProfileImage, Email, Password)
VALUES ('John', 'Doe', 'Springfield', 'USA', 'http://example.com/profile1.jpg', 'john.doe@example.com', 'password123'),
       ('Jane', 'Smith', 'Shelbyville', 'USA', 'http://example.com/profile2.jpg', 'jane.smith@example.com', 'securepassword');


-- Insert into LikesDislikes table
INSERT INTO LikesDislikes (PropertyID, UserID, IsLike)
VALUES (1, 1, 1),  -- User 1 likes Property 1
       (1, 2, 0),  -- User 2 dislikes Property 1
       (2, 1, 1);  -- User 1 likes Property 2


-- Insert into PropertySaved table
INSERT INTO PropertySaved (PropertyID, UserID)
VALUES (1, 1),  -- User 1 saved Property 1
       (2, 2);  -- User 2 saved Property 2


