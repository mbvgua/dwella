CREATE DATABASE dwella;
GO

USE dwella;
GO

CREATE TABLE rentalContracts(
    id INT IDENTITY(1,1) PRIMARY KEY,
    propertyId INT NOT NULL,
    tenantId VARCHAR(255) NOT NULL,
    startDate DATE NOT NULL,
    endDate DATE NOT NULL,
    rentAmount DECIMAL(9,2) CHECK (rentAmount > 0),
    depositAmount DECIMAL(9,2) CHECK (depositAmount >= 0),
    isDeleted INT DEFAULT 0,
    FOREIGN KEY (propertyId) REFERENCES properties(id),
    FOREIGN KEY (tenantId) REFERENCES users(id)
);
GO

CREATE INDEX index_rentalContracts_startDate ON rentalContracts(startDate);
CREATE INDEX index_rentalContracts_rentAmount ON rentalContracts(rentAmount);
GO