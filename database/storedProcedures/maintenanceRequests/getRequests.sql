CREATE OR ALTER PROCEDURE getRequests

AS
BEGIN
SELECT * FROM maintenanceRequests 
WHERE isDeleted=0
END;
GO