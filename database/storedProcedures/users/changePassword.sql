CREATE OR ALTER PROCEDURE changePassword (
    @id VARCHAR(255),
    @password VARCHAR(255)
)
AS
BEGIN
UPDATE users SET password=@password
WHERE id=@id AND isDeleted=0
END;
GO