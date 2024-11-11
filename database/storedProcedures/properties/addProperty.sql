CREATE OR ALTER PROCEDURE addProperty(
    @id IVARCHAr(255),
    @ownerId VARCHAR(255),
    @name VARCHAR(100),
    @propertyType VARCHAR(100),
    @details NVARCHAR(MAX),
    @location NVARCHAR(MAX),
    @status VARCHAR(100)
)
AS
BEGIN
INSERT INTO properties(id,ownerId,name,propertyType,details,location,status)
VALUES (@id,@ownerId,@name,@propertyType,@details,@location,@status)
END;
GO