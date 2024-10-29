USE dwella;
GO

-- view to provide info on all active rental contacts
CREATE VIEW activeRentalContracts
AS
SELECT 
    p.address,
    u.firstName + ' ' + u.lastName as tenantName,
    rc.startDate,
    rc.endDate,
    rc.rentAmount
FROM rentalContracts AS rc
JOIN users AS u
    ON rc.tenantId = u.id 
JOIN properties AS p
    ON rc.propertId = p.id
WHERE rc.endDate > GETDATE();
GO