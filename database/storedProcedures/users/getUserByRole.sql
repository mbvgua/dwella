CREATE OR ALTER PROCEDURE getUserByRole(
    @role VARCHAR(50)
)
AS
BEGIN
SELECT * FROM users
WHERE role=@role AND isDeleted=0
END;
GO