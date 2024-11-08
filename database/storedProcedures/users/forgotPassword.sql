CREATE OR ALTER PROCEDURE forgotPassword (
    @id VARCHAR(255)
)
AS
BEGIN
UPDATE users SET forgotPassword=1
WHERE id=@id AND isDeleted=0
END;
GO