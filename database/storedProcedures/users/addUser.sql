CREATE OR ALTER PROCEDURE addUser(
    -- parameters for stored procedure here
    @id VARCHAR(255),
    @firstName VARCHAR(100),
    @lastName VARCHAR(100),
    @userName VARCHAR(100),
    @email VARCHAR(100),
    @contactNumber VARCHAR(15),
    @password VARCHAR(100),
    @role VARCHAR(50),
)
AS
BEGIN
-- inser statement for procedure here
INSERT INTO users(id,firstName,lastName,userName,email,contactNumber,password,role)
VALUES (@id,@firstName,@lastName,@userName,ENCRYPTBYPASSPHRASE('theNorthRemembers',@email),@contactNumber,@password,@role)
END;
GO