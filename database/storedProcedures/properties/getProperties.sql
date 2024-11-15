CREATE OR ALTER PROCEDURE getProperties

AS
BEGIN
    SELECT * FROM properties
    WHERE isDeleted=0
END;
GO