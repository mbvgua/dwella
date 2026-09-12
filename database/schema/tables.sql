CREATE DATABASE dwella;
USE dwella;

CREATE TABLE users(
    id VARCHAR(255) PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('tenant','owner','admin') NOT NULL DEFAULT 'tenant',
    phone_number VARCHAR(20) NOT NULL,
    image_file VARCHAR(255) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOL DEFAULT 0,
    is_welcome_email_sent BOOL DEFAULT 0
);

CREATE TABLE properties(
    id VARCHAR(255) PRIMARY KEY,
    owner_id VARCHAR(255),
    name VARCHAR(100) NOT NULL,
    property_type ENUM('hostel','hotel','motel','office space','apartment') NOT NULL,
    location JSON NOT NULL,
    status ENUM('available','not available') NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOL DEFAULT 0,
    FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE units(
    id VARCHAR(255) PRIMARY KEY,
    property_id VARCHAR(255),
    unit_number VARCHAR(20) NOT NULL,
    monthly_rent DECIMAL(10,2) NOT NULL CHECK (monthly_rent > 0),
    is_occupied BOOL DEFAULT 0,
    FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE,
    UNIQUE (property_id, unit_number) -- units in a property MUST be unique
);

CREATE TABLE rental_contracts(
    id VARCHAR(255) PRIMARY KEY,
    unit_id VARCHAR(255),
    tenant_id VARCHAR(255),
    status ENUM('active','expired') NOT NULL DEFAULT 'active',
    rent_amount DECIMAL(10,2) NOT NULL CHECK (rent_amount > 0),
    deposit_amount DECIMAL(10,2) NOT NULL CHECK (deposit_amount > 0),
    start_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    end_date DATETIME NOT NULL,
    is_deleted BOOL DEFAULT 0,
    FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE CASCADE,
    FOREIGN KEY (tenant_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE payments(
    id VARCHAR(255) PRIMARY KEY,
    unit_id VARCHAR(255),
    tenant_id VARCHAR(255),
    amount DECIMAL(10,2) NOT NULL CHECK (amount > 0),
    status ENUM('pending','completed','failed') NOT NULL,
    payment_method ENUM('bank','mpesa','paypal') NOT NULL,
    transaction_reference VARCHAR(200) UNIQUE NOT NULL,
    paid_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_deleted BOOL DEFAULT 0,
    FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE SET NULL,
    FOREIGN KEY (tenant_id) REFERENCES users(id) ON DELETE SET NULL
);

CREATE TABLE reviews(
    id VARCHAR(255) PRIMARY KEY,
    user_id VARCHAR(255),
    unit_id VARCHAR(255),
    stars_rating TINYINT NOT NULL CHECK (stars_rating BETWEEN 1 AND 5),
    message TEXT NOT NULL,
    is_deleted BOOL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE SET NULL
);

CREATE TABLE maintenance_requests(
    id VARCHAR(255) PRIMARY KEY,
    unit_id VARCHAR(255),
    raised_by VARCHAR(255),
    resolved_by VARCHAR(255),
    description TEXT NOT NULL,
    priority ENUM('low','medium','high') NOT NULL DEFAULT 'low',
    status ENUM('pending','in progress','resolved') NOT NULL DEFAULT 'pending',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    resolved_at DATETIME DEFAULT NULL,
    is_deleted BOOL DEFAULT 0,
    FOREIGN KEY (unit_id) REFERENCES units(id) ON DELETE SET NULL,
    FOREIGN KEY (raised_by) REFERENCES users(id) ON DELETE SET NULL
    FOREIGN KEY (resolved_by) REFERENCES users(id) ON DELETE SET NULL
);

-- build when working on messaging with websockets module
-- CREATE TABLE messages();

