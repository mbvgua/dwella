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