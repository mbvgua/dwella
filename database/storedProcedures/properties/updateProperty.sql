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
UPDATE properties SET (name=@name, ownerId=@ownerId, address=@address, propertyType=@propertyType, status=@status)
WHERE id=@id
END;
GO