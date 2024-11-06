CREATE DATABASE dwella;
GO

USE dwella;
GO

CREATE TABLE users(
    id VARCHAR(255) PRIMARY KEY,    --random ids.more secure
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    userName VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contactNumber VARCHAR(15) CHECK (contactNumber LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK(role IN ('maintenance','manager','tenant','owner','admin')),
    isDeleted INT DEFAULT 0,
    -- isEmailSent INT DEFAULT 0,
);
GO

-- nonclustered index on email, role, username
CREATE UNIQUE INDEX index_users_email ON users(email);
CREATE UNIQUE INDEX index_users_username ON users(userName);
CREATE INDEX index_users_role ON users(role);
GO