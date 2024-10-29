USE dwella;
GO

-- get unique mainatenance request by users
SELECT id, status, COUNT(DISTINCT userId) AS distinct_maintenanceRequests
FROM maintenanceRequests
GROUP BY status
ORDER BY status;
GO

-- get atotal rent paid by user
SELECT userId, SUM(amount) as 'total rent paid'
FROM payments
GROUP BY userId;
GO