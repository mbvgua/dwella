CREATE OR ALTER PROCEDURE getUserRequests(
    @userId VARCHAR(255)
)
AS
BEGIN
SELECT * FROM maintenanceRequests 
WHERE userId=@userId and isDeleted=0
END;
GO