CREATE OR ALTER PROCEDURE deleteProperty(
    @id INT
)
AS
BEGIN
-- soft delete. will remain in db
UPDATE properties SET isDeleted=1
WHERE id=@id
END;
GO