CREATE OR ALTER PROCEDURE getPreviousTenantContract (
    @id INT
)
AS
BEGIN
SELECT * FROM rentalContracts
WHERE id=@id AND isDeleted=1
END;
GO