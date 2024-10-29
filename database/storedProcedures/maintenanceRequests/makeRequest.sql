CREATE OR ALTER PROCEDURE makeRequest(
    @id,
    @propepertyId,
    @tenantId,
    @requestDate,
    @issueDescription,
    @status        
)
AS
BEGIN
INSERT INTO maintenanceRequests (id, propepertyId, tenantId, requestDate, issueDescription, status)
VALUES (@id, @propepertyId, @tenantId, @requestDate, @issueDescription, @status)
END;
GO