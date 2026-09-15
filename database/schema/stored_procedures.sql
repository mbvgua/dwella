-----------------------
-- STORED PROCEDURES --
-----------------------
DELIMITER $$

-- USERS
-- addUser
CREATE PROCEDURE addUser(
    IN p_id VARCHAR(255),
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(150),
    IN p_password_hash VARCHAR(255),
    IN p_role ENUM('tenant','owner','admin'),
    IN p_phone_number VARCHAR(20),
    IN p_image_file VARCHAR(255)
)
BEGIN
    INSERT INTO users(id, username, email, password_hash, role, phone_number, image_file)
    VALUES (p_id, p_username, p_email, p_password_hash, p_role, p_phone_number, p_image_file);
END$$

-- getUserById
CREATE PROCEDURE getUserById(
    IN p_id VARCHAR(255)
)
BEGIN
    SELECT * FROM users
    WHERE id=p_id
    AND is_deleted=0;
END$$

-- getUserByUsername
CREATE PROCEDURE getUserByUsername(
    IN p_username VARCHAR(100)
)
BEGIN
    SELECT * FROM users
    WHERE username=p_username
    AND is_deleted=0;
END$$

-- getUsersByRole
CREATE PROCEDURE getUsersByRole(
    IN p_role ENUM('tenant','owner','admin')
)
BEGIN
    SELECT * FROM users
    WHERE role=p_role
    AND is_deleted=0;
END$$

-- getUsers
CREATE PROCEDURE getUsers()
BEGIN
    SELECT * FROM users
    WHERE is_deleted=0;
END$$

-- updateUser
CREATE PROCEDURE updateUser(
    IN p_id VARCHAR(255),
    IN p_username VARCHAR(100),
    IN p_email VARCHAR(150),
    IN p_phone_number VARCHAR(20)
)
BEGIN
    UPDATE users
    SET username=p_username, email=p_email, phone_number=p_phone_number
    WHERE id=p_id
    AND is_deleted=0;
END$$

-- updateUserPassword
CREATE PROCEDURE updateUserPassword(
    IN p_id VARCHAR(255),
    IN p_password_hash VARCHAR(255)
)
BEGIN
    UPDATE users
    SET password_hash=p_password_hash
    WHERE id=p_id
    AND is_deleted=0;
END$$

-- updateUserImage
CREATE PROCEDURE updateUserImage(
    IN p_id VARCHAR(255),
    IN p_image_file VARCHAR(255)
)
BEGIN
    UPDATE users
    SET image_file=p_image_file
    WHERE id=p_id
    AND is_deleted=0;
END$$

-- deleteUser
CREATE PROCEDURE deleteUser(
    IN p_id VARCHAR(255)
)
BEGIN
    UPDATE users
    SET is_deleted=1
    WHERE id=p_id;
END$$

-- PROPERTIES
-- addProperty
CREATE PROCEDURE addProperty(
    IN p_id VARCHAR(255),
    IN p_owner_id VARCHAR(255),
    IN p_name VARCHAR(100),
    IN p_property_type ENUM('hostel','hotel','motel','office space','apartment'),
    IN p_location JSON,
    IN p_status ENUM('available','not available')
)
BEGIN
    INSERT INTO properties(id,owner_id,name,property_type,location,status)
    VALUES (p_id,p_owner_id,p_name,p_property_type,p_location,p_status);
END$$

-- getPropertyById
CREATE PROCEDURE getPropertyById(
    IN p_id VARCHAR(255)
)
BEGIN
    SELECT * FROM properties
    WHERE id=p_id
    AND is_deleted=0;
END$$

-- getPropertyByName
CREATE PROCEDURE getPropertyByName(
    IN p_name VARCHAR(100)
)
BEGIN
    SELECT * FROM properties
    WHERE name=p_name
    AND is_deleted=0;
END$$

-- getPropertyByType
CREATE PROCEDURE getPropertyByType(
    IN p_property_type ENUM('hostel','hotel','motel','office space','apartment')
)
BEGIN
    SELECT * FROM properties
    WHERE property_type=p_property_type
    AND is_deleted=0;
END$$

-- getAvailableProperties
CREATE PROCEDURE getAvailableProperties()
BEGIN
    SELECT * FROM properties
    WHERE status='available'
    AND is_deleted=0;
END$$

-- getAllProperties
CREATE PROCEDURE getAllProperties()
BEGIN
    SELECT * FROM properties
    WHERE is_deleted=0;
END$$

-- updateProperty
CREATE PROCEDURE updateProperty(
    IN p_id VARCHAR(255),
    IN p_owner_id VARCHAR(255),
    IN p_name VARCHAR(100),
    IN p_property_type ENUM('hostel','hotel','motel','office space','apartment'),
    IN p_location JSON,
    IN p_status ENUM('available','not available')
)
BEGIN
    UPDATE properties
    SET owner_id=p_owner_id,name=p_name,property_type=p_property_type,location=p_location,status=p_status
    WHERE id=p_id
    AND is_deleted=0;
END$$

-- deleteProperty
CREATE PROCEDURE deleteProperty(
    IN p_id VARCHAR(255)
)
BEGIN
    UPDATE properties
    SET is_deleted=1
    WHERE id=p_id;
END$$

-- UNITS
-- addUnit
CREATE PROCEDURE addUnit(
    IN p_id VARCHAR(255),
    IN p_property_id VARCHAR(255),
    IN p_unit_number VARCHAR(20),
    IN p_monthly_rent DECIMAL(10,2)
)
BEGIN
    INSERT INTO units(id,property_id,unit_number,monthly_rent)
    VALUES (p_id,p_property_id,p_unit_number,p_monthly_rent);
END$$

-- getUnitById
CREATE PROCEDURE getUnitById(
    IN p_id VARCHAR(255)
)
BEGIN
    SELECT * FROM units
    WHERE id=p_id;
END$$

-- getUnitByUnitNumber
CREATE PROCEDURE getUnitByUnitNumber(
    IN p_unit_number VARCHAR(20)
)
BEGIN
    SELECT * FROM units
    WHERE unit_number=p_unit_number;
END$$

-- getVacantUnits
CREATE PROCEDURE getVacantUnits()
BEGIN
    SELECT * FROM units
    WHERE is_occupied=0;
END$$

-- updateUnit
CREATE PROCEDURE updateUnit(
    IN p_id VARCHAR(255),
    IN p_property_id VARCHAR(255),
    IN p_unit_number VARCHAR(20),
    IN p_monthly_rent DECIMAL(10,2),
    IN p_is_occupied BOOL
)
BEGIN
    UPDATE units
    SET property_id=p_property_id,unit_number=p_unit_number,monthly_rent=p_monthly_rent,is_occupied=p_is_occupied
    WHERE id=p_id;
END$$

-- deleteUnit
CREATE PROCEDURE deleteUnit(
    IN p_id VARCHAR(255)
)
BEGIN
    DELETE FROM units
    WHERE id=p_id;
END$$

-- RENTAL_CONTRACTS
-- addRentalContract
-- transaction ensures unit is vacant
--      if not, it rollsback
--      if vacant, add rental_contract then update unit as occupied
CREATE PROCEDURE addRentalContract(
    p_id VARCHAR(255),
    p_unit_id VARCHAR(255),
    p_tenant_id VARCHAR(255),
    p_status ENUM('active','expired'),
    p_rent_amount DECIMAL(10,2),
    p_deposit_amount DECIMAL(10,2),
    p_billing_date DATETIME
)
BEGIN
    DECLARE vacant_units INT DEFAULT 0;
    DECLARE rollback_message VARCHAR(255) DEFAULT 'Transaction rolled back: Unit is not vacant!';

    START TRANSACTION;

    -- verify unit is vacant
    SELECT COUNT(*) INTO vacant_units
    FROM units
    WHERE id=p_unit_id
    AND is_occupied=0;

    IF vacant_units IS NULL OR vacant_units=0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT=rollback_message;
    ELSE
        INSERT INTO rental_contracts(id,unit_id,tenant_id,status,rent_amount,deposit_amount,billing_date)
        VALUES (p_id,p_unit_id,p_tenant_id,p_status,p_rent_amount,p_deposit_amount,p_billing_date);

        UPDATE units
        SET is_occupied=1
        WHERE id=p_unit_id;
        COMMIT;
    END IF;

END$$

-- getRentalContractsByTenant
CREATE PROCEDURE getRentalContractsByTenant(
    IN p_tenant_id VARCHAR(255)
)
BEGIN
    SELECT * FROM rental_contracts
    WHERE tenant_id=p_tenant_id
    AND is_deleted=0;
END$$

-- getRentalContractsByStatus
CREATE PROCEDURE getRentalContractsByStatus(
    IN p_status ENUM('active','expired')
)
BEGIN
    SELECT * FROM rental_contracts
    WHERE status=p_status
    AND is_deleted=0;
END$$

-- getAllRentalContracts
CREATE PROCEDURE getAllRentalContracts()
BEGIN
    SELECT * FROM rental_contracts
    WHERE is_deleted=0;
END$$

-- updateRentalContract
CREATE PROCEDURE updateRentalContract(
    p_id VARCHAR(255),
    p_unit_id VARCHAR(255),
    p_tenant_id VARCHAR(255),
    p_status ENUM('active','expired'),
    p_rent_amount DECIMAL(10,2),
    p_deposit_amount DECIMAL(10,2),
    p_billing_date DATETIME
)
BEGIN
    UPDATE rental_contracts
    SET unit_id=p_unit_id,tenant_id=p_tenant_id,status=p_status,rent_amount=p_rent_amount,deposit_amount=p_deposit_amount,billing_date=p_billing_date
    WHERE id=p_id;
END$$

-- deleteRentalContract
-- transaction ensures unit has an active rental contract
--      if not, it rollsback
--      if present, updates it to expires and soft deletes it
CREATE PROCEDURE deleteRentalContract(
    p_id VARCHAR(255)
)
BEGIN
    DECLARE select_unit_id VARCHAR(255);
    DECLARE rollback_message VARCHAR(255) DEFAULT 'Transaction rolled back: Unit id not found';

    START TRANSACTION;

    -- get unit id
    SELECT unit_id INTO select_unit_id
    FROM rental_contracts
    WHERE id=p_id
    AND status='active'
    AND is_deleted=0;

    IF select_unit_id is NULL THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT=rollback_message;
    ELSE
        UPDATE rental_contracts
        SET is_deleted=1,status='expired'
        WHERE id=p_id;

        UPDATE units
        SET is_occupied=0
        WHERE id=unit_id;

        COMMIT;
    END IF;
END$$

-- PAYMENTS
-- addPayment
-- transcation ensures user paying has active rental contract
--      if not, rollsback
--      if present, make payment
CREATE PROCEDURE addPayment(
    IN p_id VARCHAR(255),
    IN p_unit_id VARCHAR(255),
    IN p_tenant_id VARCHAR(255),
    IN p_amount DECIMAL(10,2),
    IN p_status ENUM('pending','completed','failed'),
    IN p_payment_method ENUM('bank','mpesa','stripe'),
    IN p_transaction_reference VARCHAR(200)
)
BEGIN
    DECLARE valid_contracts INT DEFAULT 0;
    DECLARE rollback_message VARCHAR(255) DEFAULT 'Transaction rolled back: No valid rental contract found';

    START TRANSACTION;

    -- does user have active contracts?
    SELECT COUNT(*) INTO valid_contracts
    FROM rental_contracts
    WHERE tenant_id=p_tenant_id
    AND status='active'
    AND is_deleted=0;

    IF valid_contracts IS NULL OR valid_contracts=0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT=rollback_message;
    ELSE
        INSERT INTO payments(id,unit_id,tenant_id,amount,status,payment_method,transaction_reference)
        VALUES (p_id,p_unit_id,p_tenant_id,p_amount,p_status,p_payment_method,p_transaction_reference);
        COMMIT;
    END IF;
END$$

-- getPaymentsByTenant
CREATE PROCEDURE getPaymentsByTenant(
    IN p_tenant_id VARCHAR(255)
)
BEGIN
    SELECT * FROM payments
    WHERE tenant_id=p_tenant_id
    AND is_deleted=0;
END$$

-- getPaymentsForUnit
CREATE PROCEDURE getPaymentsForUnit(
    IN p_unit_id VARCHAR(255)
)
BEGIN
    SELECT * FROM payments
    WHERE unit_id=p_unit_id
    AND is_deleted=0;
END$$

-- getPaymentsByStatus
CREATE PROCEDURE getPaymentsByStatus(
    IN p_status ENUM('pending','completed','failed')
)
BEGIN
    SELECT * FROM payments
    WHERE status=p_status
    AND is_deleted=0;
END$$

-- getPaymentsByMethod
CREATE PROCEDURE getPaymentsByMethod(
    IN p_payment_method ENUM('bank','mpesa','stripe')
)
BEGIN
    SELECT * FROM payments
    WHERE payment_method=p_payment_method
    AND is_deleted=0;
END$$

-- getPayments
CREATE PROCEDURE getPayments()
BEGIN
    SELECT * FROM payments
    WHERE is_deleted=0;
END$$

-- updatePayment
CREATE PROCEDURE updatePayment(
    IN p_id VARCHAR(255),
    IN p_unit_id VARCHAR(255),
    IN p_tenant_id VARCHAR(255),
    IN p_amount DECIMAL(10,2),
    IN p_status ENUM('pending','completed','failed'),
    IN p_payment_method ENUM('bank','mpesa','stripe'),
    IN p_transaction_reference VARCHAR(200)
)
BEGIN
    UPDATE payments
    SET unit_id=p_unit_id,tenant_id=p_tenant_id,amount=p_amount,status=p_status,payment_method=p_payment_method,transaction_reference=p_transaction_reference
    WHERE id=p_id
    AND is_deleted=0;
END$$

-- deletePayment
CREATE PROCEDURE deletePayment(
    IN p_id VARCHAR(255)
)
BEGIN
    UPDATE payments
    SET is_deleted=1
    WHERE id=p_id;
END$$

-- REVIEWS
-- addReview: transaction ensures only tenannt add reviews
CREATE PROCEDURE addReview(
    IN p_id VARCHAR(255),
    IN p_user_id VARCHAR(255),
    IN p_unit_id VARCHAR(255),
    IN p_stars_rating TINYINT,
    IN p_message TEXT
)
BEGIN
    DECLARE user_role ENUM('tenant','owner','admin');
    DECLARE contract_count INT DEFAULT 0;
    DECLARE rollback_role_message VARCHAR(255) DEFAULT 'Transaction rolled back: Admins/Owners cannot add reviews';
    DECLARE rollback_contract_message VARCHAR(255) DEFAULT 'Transaction rolled back: You need to have anactive rental contract to add review';
    -- DECLARE commit_message VARCHAR(255) DEFAULT 'Transaction committed successfully';

    START TRANSACTION;

    -- check user role
    SELECT role INTO user_role 
    FROM users 
    WHERE id=p_user_id 
    AND is_deleted=0;
    -- check tenant rental contract history
    SELECT COUNT(*) INTO contract_count 
    FROM rental_contracts 
    WHERE unit_id=p_unit_id 
    AND tenant_id=p_user_id;

    IF user_role IS NULL OR user_role != 'tenant' THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT=rollback_role_message;
    ELSEIF contract_count=0 THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT=rollback_contract_message;
    ELSE
        INSERT INTO reviews(id,user_id,unit_id,stars_rating,message)
        VALUES (p_id,p_user_id,p_unit_id,p_stars_rating,p_message);
        COMMIT;
    END IF;
END$$

-- getReviewById
CREATE PROCEDURE getReviewById(
    IN p_id VARCHAR(255)
)
BEGIN
    SELECT * FROM reviews
    WHERE id=p_id
    AND is_deleted=0;
END$$

-- getReviewByUserId
CREATE PROCEDURE getReviewByUserId(
    IN p_user_id VARCHAR(255)
)
BEGIN
    SELECT * FROM reviews
    WHERE user_id=p_user_id
    AND is_deleted=0;
END$$

-- getReviewsByStars
CREATE PROCEDURE getReviewsByStars(
    IN p_stars_rating TINYINT
)
BEGIN
    SELECT * FROM reviews
    WHERE stars_rating=p_stars_rating
    AND is_deleted=0;
END$$

-- getReviewsForProperty
CREATE PROCEDURE getReviewsForProperty(
    IN p_unit_id VARCHAR(255)
)
BEGIN
    SELECT * FROM reviews
    WHERE unit_id=p_unit_id
    AND is_deleted=0;
END$$

-- getReviews
CREATE PROCEDURE getReviews()
BEGIN
    SELECT * FROM reviews
    WHERE is_deleted=0;
END$$

-- updateReview
CREATE PROCEDURE updateReview(
    IN p_id VARCHAR(255),
    IN p_user_id VARCHAR(255),
    IN p_unit_id VARCHAR(255),
    IN p_stars_rating TINYINT,
    IN p_message TEXT
)
BEGIN
    UPDATE reviews
    SET user_id=p_user_id,unit_id=p_unit_id,stars_rating=p_stars_rating,message=p_message
    WHERE id=p_id
    AND is_deleted=0;
END$$

-- deleteReview
CREATE PROCEDURE deleteReview(
    IN p_id VARCHAR(255)
)
BEGIN
    UPDATE reviews
    SET is_deleted=1
    WHERE id=p_id;
END$$

-- MAINTENANCE_REQUESTS
-- addMaintenanceRequest
CREATE PROCEDURE addMaintenanceRequest(
    IN p_id VARCHAR(255),
    IN p_unit_id VARCHAR(255),
    IN p_raised_by VARCHAR(255),
    IN p_description TEXT,
    IN p_priority ENUM('low','medium','high')
)
BEGIN
    INSERT INTO maintenance_requests(id,unit_id,raised_by,description,priority)
    VALUES (p_id,p_unit_id,p_raised_by,p_description,p_priority);
END$$

-- getMaintenanceRequestsByUserId
CREATE PROCEDURE getMaintenanceRequestsByUserId(
    IN p_user_id VARCHAR(255)
)
BEGIN
    SELECT * FROM maintenance_requests
    WHERE raised_by=p_user_id
    AND is_deleted=0;
END$$

-- getMaintenanceRequestsForUnit
CREATE PROCEDURE getMaintenanceRequestsForUnit(
    IN p_unit_id VARCHAR(255)
)
BEGIN
    SELECT * FROM maintenance_requests
    WHERE unit_id=p_unit_id
    AND is_deleted=0;
END$$

-- getMaintenanceRequestStatus
CREATE PROCEDURE getMaintenanceRequestStatus(
    IN p_status ENUM('pending','in progress','resolved')
)
BEGIN
    SELECT * FROM maintenance_requests
    WHERE status=p_status
    AND is_deleted=0;
END$$

-- getMaintenanceRequests
CREATE PROCEDURE getMaintenanceRequests()
BEGIN
    SELECT * FROM maintenance_requests
    WHERE is_deleted=0;
END$$

-- updateMaintenanceRequest
CREATE PROCEDURE updateMaintenanceRequest(
    IN p_id VARCHAR(255),
    IN p_unit_id VARCHAR(255),
    IN p_raised_by VARCHAR(255),
    IN p_description TEXT,
    IN p_priority ENUM('low','medium','high'),
    IN p_status ENUM('pending','in progress','resolved')
)
BEGIN
    START TRANSACTION;

    IF p_status='resolved' THEN
        UPDATE maintenance_requests
        SET unit_id=p_unit_id,raised_by=p_raised_by,description=p_description,priority=p_priority,status=p_status,resolved_at=NOW()
        WHERE id=p_id
        AND is_deleted=0;

        COMMIT;
    ELSE
        UPDATE maintenance_requests
        SET unit_id=p_unit_id,raised_by=p_raised_by,description=p_description,priority=p_priority,status=p_status
        WHERE id=p_id
        AND is_deleted=0;

        COMMIT;
    END IF;
END$$

-- resolveMaintenanceRequest
CREATE PROCEDURE resolveMaintenanceRequest(
    IN p_id VARCHAR(255),
    IN p_resolved_by VARCHAR(255),
    IN p_resolved_at DATETIME
)
BEGIN
    UPDATE maintenance_requests
    SET resolved_by=p_resolved_by,resolved_at=p_resolved_at
    WHERE id=p_id
    AND is_deleted=0;
END$$

-- deleteMaintenanceRequest
CREATE PROCEDURE deleteMaintenanceRequest(
    p_id VARCHAR(255)
)
BEGIN
    UPDATE maintenance_requests
    SET is_deleted=1
    WHERE id=p_id;
END$$


DELIMITER ;

