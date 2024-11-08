CREATE OR ALTER PROCEDURE deleteContract(
    @id INT
)
AS
BEGIN
UPDATE rentalContracts SET isDeleted=1
WHERE id=@id
END;
GO