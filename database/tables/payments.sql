CREATE DATABASE dwella;
GO

USE dwella;
GO

CREATE TABLE payments(
    id INT IDENTITY(1,1) PRIMARY KEY,
    contractId INT NOT NULL,
    paymentDate DATE NOT NULL,
    amount DECIMAL(9,2) CHECK (amount > 0),
    FOREIGN KEY (contractId) REFERENCES rentalContracts(id)
);
GO

CREATE INDEX index_payments_paymentDate ON payments(paymentDate);
CREATE INDEX index_payments_contractId ON payments(contractId);
GO