CREATE OR ALTER PROCEDURE getUserByUserName(
    @userName VARCHAR(100)
)
AS
BEGIN
SELECT * FROM users
WHERE userName=@userName AND isDeleted=0
END;
GO