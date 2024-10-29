CREATE OR ALTER PROCEDURE updateUser(
    @id VARCHAR(255),
    @firstName VARCHAR(100),
    @lastName VARCHAR(100),
    @userName VARCHAR(100),
    @email VARCHAR(100),
    @contactNumber VARCHAR(15),
    @password VARCHAR(100)
)
AS
BEGIN
UPDATE users SET (firstName=@firstName,lastName=@lastName,userName=@userName,email=ENCRYPTBYPASSPHRASE('theNorthRemembers',@email),contactNumber=@contactNumber,password=@password,role=@role)
WHERE id=@id
END;
GO