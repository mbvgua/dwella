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
