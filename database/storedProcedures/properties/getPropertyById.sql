CREATE OR ALTER PROCEDURE getPropertyById(
    @id INT
)
AS
BEGIN
SELECT * FROM properties
WHERE id=@id AND isDeleted=0
END;
GO