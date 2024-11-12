CREATE OR ALTER PROCEDURE updateProperty(
    @id VARCHAR(255),
    @name VARCHAR(100),
    @propertyType VARCHAR(100),
    @details NVARCHAR(MAX),
    @location NVARCHAR(MAX),
    @status VARCHAR(100)
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