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