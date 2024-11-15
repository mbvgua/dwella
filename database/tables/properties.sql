CREATE DATABASE dwella;
GO

USE dwella;
GO

CREATE TABLE properties(
    id VARCHAR(255) PRIMARY KEY,
    ownerId VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    propertyType VARCHAR(100) NOT NULL CHECK(propertyType IN ('apartment','commercial','hostel')),
    detailsJson NVARCHAR(MAX) NOT NULL,
    locationJson NVARCHAR(MAX) NOT NULL,
    status VARCHAR(100) CHECK (status IN ('available', 'not available')),
    createdAt DATETIME DEFAULT GETDATE(),
    isDeleted INT DEFAULT 0,
    FOREIGN KEY (ownerId) REFERENCES users(id)
);
GO

CREATE UNIQUE INDEX index_properties_name ON properties(name);
CREATE INDEX index_properties_status ON properties(status);
GO
