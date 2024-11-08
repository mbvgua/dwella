CREATE OR ALTER PROCEDURE makePayment(
    @id INT,
    @contractId INT,
    @paymentDate DATE,
    @amount DECIMAL,
)
AS
BEGIN
INSERT INTO payments (id, contractId, paymentDate, amount)
VALUES (@id, @contractId, @paymentDate, @amount)
END;
GO