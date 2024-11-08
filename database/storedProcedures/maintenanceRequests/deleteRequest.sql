CREATE OR ALTER PROCEDURE deleteRequest(
    @id INT,
    @userId VARCHAR(255)
)
AS
BEGIN
UPDATE maintenanceRequests SET (isDeleted=1, closedBy=@userId)
WHERE id=@id
END;
GO