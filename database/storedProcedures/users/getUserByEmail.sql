CREATE OR ALTER PROCEDURE getUserByEmail(
    @email VARCHAR(255)
)
AS
BEGIN
SELECT * FROM users
WHERE email=DECRYPTBYPASSPHRASE('theNorthRemembers',@email) AND isDeleted=0
END;
GO