CREATE OR ALTER PROCEDURE getProperties

AS
BEGIN
SELECT * FROM properties
WHERE id=@id AND isDeleted=0
END;
GO