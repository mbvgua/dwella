CREATE DATABASE dwella;
GO

USE dwella;
GO

CREATE TABLE users(
    id VARCHAR(255) PRIMARY KEY,    --random ids.more secure
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    userName VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contactNumber VARCHAR(15) CHECK (contactNumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK(role IN ('maintenance','manager','tenant','owner','admin')),
    isDeleted INT DEFAULT 0,
    -- isEmailSent INT DEFAULT 0,
);
GO

-- nonclustered index on email, role, username
CREATE UNIQUE INDEX index_users_email ON users(email);
CREATE INDEX index_users_username ON users(userName);
CREATE INDEX index_users_role ON users(role);
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

CREATE TABLE payments(
    id INT IDENTITY(1,1) PRIMARY KEY,
    contractId INT NOT NULL,
    paymentDate DATE NOT NULL,
    amount DECIMAL(9,2) CHECK (amount > 0),
    FOREIGN KEY (contractId) REFERENCES rentalContracts(id)
);
GO

CREATE INDEX index_payments_paymentDate ON payments(paymentDate);
CREATE INDEX index_payments_contractId ON payments(contractId);
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

CREATE TABLE reviews(
    id INT IDENTITY(1,1) PRIMARY KEY,
    userId VARCHAR(255),
    propertyRef INT,
    userRef VARCHAR(255),
    reviewDescription VARCHAR(MAX),
    starRating INT CHECK(starRating <= 5),
    FOREIGN KEY (userId) REFERENCES users(id),
    FOREIGN KEY (propertyRef) REFERENCES properties(id),
    FOREIGN KEY (userRef) REFERENCES users(id)
)

CREATE INDEX index_reviews_starRating ON reviews(starRating)
CREATE INDEX index_reviews_createdBy ON reviews(createdBy)
GO
----------------------------------
---create the stored procedures---
----------------------------------

-- Users stored procdures
-- addUser
CREATE OR ALTER PROCEDURE addUser(
    -- parameters for stored procedure here
    @id VARCHAR(255),
    @firstName VARCHAR(100),
    @lastName VARCHAR(100),
    @userName VARCHAR(100),
    @email VARCHAR(100),
    @contactNumber VARCHAR(15),
    @password VARCHAR(100),
    @role VARCHAR(50)
)
AS
BEGIN
-- inser statement for procedure here
INSERT INTO users(id,firstName,lastName,userName,email,contactNumber,password,role)
VALUES (@id,@firstName,@lastName,@userName,ENCRYPTBYPASSPHRASE('theNorthRemembers',@email),@contactNumber,@password,@role)
END;
GO

-- deleteUser
CREATE OR ALTER PROCEDURE deleteUser(
    @id VARCHAR(255)
)
AS
BEGIN
-- soft delete. still remains in db even though deleted
UPDATE users SET isDeleted=1
WHERE id=@id
END;
GO

-- updateUser
CREATE OR ALTER PROCEDURE updateUser(
    @id VARCHAR(255),
    @firstName VARCHAR(100),
    @lastName VARCHAR(100),
    @userName VARCHAR(100),
    @email VARCHAR(100),
    @contactNumber VARCHAR(15),
    @password VARCHAR(100)
)
AS
BEGIN
UPDATE users SET firstName=@firstName,lastName=@lastName,userName=@userName,email=ENCRYPTBYPASSPHRASE('theNorthRemembers',@email),contactNumber=@contactNumber,password=@password
WHERE id=@id
END;
GO

-- getUserByEmail
CREATE OR ALTER PROCEDURE getUserByEmail(
    @email VARCHAR(255)
)
AS
BEGIN
SELECT * FROM users
WHERE email=DECRYPTBYPASSPHRASE('theNorthRemembers',@email) AND isDeleted=0
END;
GO

-- getUserById
CREATE OR ALTER PROCEDURE getUserById(
    @id VARCHAR(255)
)
AS
BEGIN
SELECT * FROM users
WHERE id=@id AND isDeleted=1
END;
GO

-- getUsers
CREATE OR ALTER PROCEDURE getUsers

AS
BEGIN
SELECT * FROM users
WHERE isDeleted=0
END;
GO


-- Properties stored procdures
-- addProperty
CREATE OR ALTER PROCEDURE addProperty(
    @id INT,
    @name VARCHAR(100),
    @ownerId VARCHAR(255),
    @address VARCHAR(255),
    @propertyType VARCHAR(100),
    @status VARCHAR(100)
)
AS
BEGIN
INSERT INTO properties(id,name,ownerId,address,propertyType,status)
VALUES (@id,@name,@ownerId,@address,@propertyType,@status)
END;
GO

-- deleteProperty
CREATE OR ALTER PROCEDURE deleteProperty(
    @id INT
)
AS
BEGIN
-- soft delete. will remain in db
UPDATE properties SET isDeleted=1
WHERE id=@id
END;
GO

-- updateProperty
CREATE OR ALTER PROCEDURE updateProperty(
    @id INT,
    @name VARCHAR(100),
    @ownerId VARCHAR(255),
    @address VARCHAR(255),
    @propertyType VARCHAR(100),
    @status VARCHAR(100)
)
AS
BEGIN
UPDATE properties SET name=@name, ownerId=@ownerId, address=@address, propertyType=@propertyType, status=@status
WHERE id=@id
END;
GO

-- getPropertyById
CREATE OR ALTER PROCEDURE getPropertyById(
    @id INT
)
AS
BEGIN
SELECT * FROM properties
WHERE id=@id AND isDeleted=0
END;
GO

-- getProperties
CREATE OR ALTER PROCEDURE getProperties

AS
BEGIN
SELECT * FROM properties
WHERE isDeleted=0
END;
GO


-- Rental Contracts stored procdures
-- addContract
CREATE OR ALTER PROCEDURE addContract(
    @id INT,
    @propertyId INT,
    @tenantId VARCHAR(255),
    @startDate DATE,
    @endDate DATE,
    @rentAmount DECIMAL,
    @depositAmount DECIMAL
)
AS
BEGIN
INSERT INTO rentalContracts (id, propertyId, tenantId, startDate, endDate, rentAmount, depositAmount)
VALUES (@id, @propertyId, @tenantId, @startDate, @endDate, @rentAmount, @depositAmount)
END;
GO

-- deleteContract
CREATE OR ALTER PROCEDURE deleteContract(
    @id INT
)
AS
BEGIN
UPDATE rentalContracts SET isDeleted=1
WHERE id=@id
END;
GO

-- getCurrentTenantContract
CREATE OR ALTER PROCEDURE getCurrentTenantContract (
    @id INT
)
AS
BEGIN
SELECT * FROM rentalContracts
WHERE id=@id AND isDeleted=0
END;
GO

-- getPreviousTenantContract
CREATE OR ALTER PROCEDURE getPreviousTenantContract (
    @id INT
)
AS
BEGIN
SELECT * FROM rentalContracts
WHERE id=@id AND isDeleted=1
END;
GO


-- Payments stored procdures
-- makePayment
CREATE OR ALTER PROCEDURE makePayment(
    @id INT,
    @contractId INT,
    @paymentDate DATE,
    @amount DECIMAL
)
AS
BEGIN
INSERT INTO payments (id, contractId, paymentDate, amount)
VALUES (@id, @contractId, @paymentDate, @amount)
END;
GO


-- Maintaenance requests stored procdures
-- makeRequest
CREATE OR ALTER PROCEDURE makeRequest(
    @id INT,
    @propepertyId INT,
    @createdBy INT,
    @requestDate DATE,
    @issueDescription VARCHAR(MAX),
    @status VARCHAR(255)     
)
AS
BEGIN
INSERT INTO maintenanceRequests (id, propertyId, createdBy, requestDate, issueDescription, status)
VALUES (@id, @propepertyId, @createdBy, @requestDate, @issueDescription, @status)
END;
GO

-- closeRequest
CREATE OR ALTER PROCEDURE closeRequest(
    @id INT,
    @userId VARCHAR(255)
)
AS
BEGIN
UPDATE maintenanceRequests SET status='closed', closedBy=@userId
WHERE id=@id
END;
GO

-- deleteRequest
CREATE OR ALTER PROCEDURE deleteRequest(
    @id INT,
    @userId VARCHAR(255)
)
AS
BEGIN
UPDATE maintenanceRequests
SET isDeleted=1, closedBy=@userId
WHERE id=@id
END;
GO

-- getUserRequets
CREATE OR ALTER PROCEDURE getUserRequests(
    @userId VARCHAR(255)
)
AS
BEGIN
SELECT * FROM maintenanceRequests 
WHERE createdBy=@userId AND isDeleted=0
END;
GO

-- getRequests
CREATE OR ALTER PROCEDURE getRequests

AS
BEGIN
SELECT * FROM maintenanceRequests 
WHERE isDeleted=0
END;
GO

-- Reviews stored procedures
--- addReview
CREATE OR ALTER PROCEDURE addReview(
    @id INT,
    @userId VARCHAR(255),
    @propertyRef INT,
    @userRef INT,
    @reviewDescription VARCHAR(MAX),
    @starRating INT
)
AS
BEGIN
INSERT INTO reviews(id,userId,propertyRef,userRef,reviewDescription,starRating)
VALUES (@id,@userId,@propertyRef,@userRef,@reviewDescription,@starRating)
END;
GO

-- getReviewsByUser
CREATE OR ALTER PROCEDURE getReviewsByUser(
    @userId VARCHAR(255)
)
AS
BEGIN
SELECT * FROM reviews
WHERE userId=@userId
END;
GO

-- getReviewsOfUser
CREATE OR ALTER PROCEDURE getReviewsOfUser(
    @userRef INT
)
AS
BEGIN
SELECT * FROM reviews
WHERE userRef=@userRef
END;
GO

-- getReviewsOfProperty
CREATE OR ALTER PROCEDURE getReviewsOfProperty(
    @propertyRef INT
)
AS
BEGIN
SELECT * FROM reviews
WHERE propertyRef=@propertyRef
END;
GO

-- updateReview 
CREATE OR ALTER PROCEDURE updateReview(
    @id INT,
    @propertyRef INT,
    @userRef INT,
    @reviewDescription VARCHAR(MAX),
    @starRating INT
)
AS
BEGIN
UPDATE reviews SET propertyRef=@propertyRef,userRef=@userRef,reviewDescription=@reviewDescription,starRating=@starRating
WHERE id=@id
END;
GO

-- deleteReview
CREATE OR ALTER PROCEDURE deleteReview(
    @id INT
)
AS
BEGIN
DELETE reviews
WHERE id=@id
END;
GO


---------------------------
-------- triggers ---------
---------------------------

-- automatically update status of property when a new rental cotract is added
-- CREATE TRIGGER trigger_update_property_status
-- ON rentalContracts
-- AFTER INSERT
-- AS
-- BEGIN
--     DECLARE @propertyId INT;

--     SELECT @propertyId = propertyId FROM inserted;

--     UPDATE properties
--     SET status='unavailable'
--     WHERE id = @propertyId;
-- END;
-- GO


---------------------------
-------- functions --------
---------------------------
-- get unique mainatenance request by users
-- SELECT id, status, COUNT(DISTINCT userId) AS distinct_maintenanceRequests
-- FROM maintenanceRequests
-- GROUP BY status
-- ORDER BY status;
-- GO

-- -- get atotal rent paid by user
-- SELECT userId, SUM(amount) as 'total rent paid'
-- FROM payments
-- GROUP BY userId;
-- GO

---------------------------
-------- views --------
---------------------------
-- view to provide info on all active rental contacts
-- CREATE VIEW activeRentalContracts
-- AS
-- SELECT 
--     p.address,
--     u.firstName + ' ' + u.lastName as tenantName,
--     rc.startDate,
--     rc.endDate,
--     rc.rentAmount
-- FROM rentalContracts AS rc
-- JOIN users AS u
--     ON rc.tenantId = u.id 
-- JOIN properties AS p
--     ON rc.propertId = p.id
-- WHERE rc.endDate > GETDATE();
-- GO

