CREATE OR ALTER PROCEDURE deleteUser(
    @id VARCHAR(255)
)
AS
BEGIN
-- soft delete. still remains in db even though deleted
UPDATE users SET isDeleted=1
WHERE id=@id
END;
GO