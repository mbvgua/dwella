CREATE OR ALTER PROCEDURE getCurrentTenantContract (
    @id INT
)
AS
BEGIN
SELECT * FROM rentalContracts
WHERE id=@id AND isDeleted=0
END;
GO