CREATE OR ALTER PROCEDURE closeRequest(
    @id INT,
    @userId VARCHAR(255)
)
AS
BEGIN
UPDATE maintenanceRequests SET (status='closed', closedBy=@userId) 
WHERE id=@id
END;
GO