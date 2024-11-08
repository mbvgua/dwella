CREATE DATABASE dwella;
GO

USE dwella;
GO

CREATE TABLE maintenanceRequests(
    id INT IDENTITY(1,1) PRIMARY KEY,
    propertyId INT NOT NULL,
    createdBy VARCHAR(255) NOT NULL,
    closedBy VARCHAR(255),
    requestDate DATE NOT NULL,
    issueDescription VARCHAR(MAX) NOT NULL,
    status VARCHAR(100) CHECK (status IN ('open','in progress','closed')),
    isDeleted INT DEFAULT 0,
    FOREIGN KEY(propertyId) REFERENCES properties(id),
    FOREIGN KEY(createdBy) REFERENCES users(id)
);
GO

CREATE INDEX index_maintenanceRequests_requestDate ON maintenanceRequests(requestDate);
CREATE INDEX index_maintenanceRequests_status ON maintenanceRequests(status);
GO