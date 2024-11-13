CREATE OR ALTER PROCEDURE updateProperty(
    @id VARCHAR(255),
    @name VARCHAR(255),
    @propertyType VARCHAR(255),
    @description VARCHAR(255),
    @floors VARCHAR(255),
    @rooms VARCHAR(255),
    @wifi VARCHAR(255),
    @pool VARCHAR(255),
    @parking VARCHAR(255),
    @addressLine VARCHAR(255),
    @postalAddress VARCHAR(255),
    @cityOrTown VARCHAR(255),
    @country VARCHAR(255),
    @status VARCHAR(255)
)
AS
BEGIN
UPDATE properties 
SET 
    name=@name,
    propertyType=@propertyType,
    details=JSON_MODIFY(@details,'$.details',details),
    location=JSON_MODIFY(@location,'$.location',location),
    status=@status
WHERE id=@id
END;
GO