CREATE OR ALTER PROCEDURE getPropertyByName(
    @name VARCHAR(100)
)
AS
BEGIN
    SELECT * FROM properties
    WHERE name=@name
    AND isDeleted=0
END;
GO