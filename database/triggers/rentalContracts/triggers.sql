USE dwella;
GO

-- automatically update status of property when a new rental cotract is added
CREATE TRIGGER trigger_update_property_status
ON rentalContracts
AFTER INSERT
AS
BEGIN
    DECLARE @propertyId INT;

    SELECT @propertyId = propertyId FROM inserted;

    UPDATE properties
    SET status='unavailable'
    WHERE propertyId = @propertyId;
END;
GO

-- trigger to check email if exists
CREATE TRIGGER checkUniqueEmail
ON users
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @email VARCHAR(100);

    -- retrieve email from INSERT statement
    SELECT @email=email FROM inserted;

    -- check if email already exists
    IF EXISTS 
        (SELECT 1 FROM users WHERE email=@email)
    BEGIN RAISERROR
        ('Email must be unique',16,1);
    ROLLBACK TRANSACTION;
    RETURN;
    END
