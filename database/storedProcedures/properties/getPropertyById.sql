CREATE OR ALTER PROCEDURE getPropertyById(
    @id VARCHAR(255)
)
AS
BEGIN
SELECT * FROM properties
WHERE id=@id AND isDeleted=0
END;
GO