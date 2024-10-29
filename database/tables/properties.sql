CREATE DATABASE dwella;
GO

USE dwella;
GO

CREATE TABLE properties(
    id INT IDENTITY(1,1) PRIMARY KEY,   --incremental numbered ids.
    name VARCHAR(100) NOT NULL,
    ownerId VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    propertyType VARCHAR(100) NOT NULL CHECK(propertyType IN ('apartment','commercial','student housing')),
    status VARCHAR(100) CHECK (status IN ('available', 'not available')),
    isDeleted INT DEFAULT 0,
    FOREIGN KEY (ownerId) REFERENCES users(id)
);
GO

CREATE INDEX index_properties_name ON properties(name);
CREATE INDEX index_properties_status ON properties(status);
GO