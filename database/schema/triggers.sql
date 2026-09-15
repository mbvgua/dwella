
-----------------------
-- TRIGGERS -----------
-----------------------
DELIMITER $$

-- USERS
-- PROPERTIES
-- checks if all units in an property are occupied, and updates the 'status' column in properties accordingly
CREATE TRIGGER set_property_status_trigger
AFTER UPDATE ON units
FOR EACH ROW
BEGIN
    DECLARE v_available_units INT DEFAULT 0;

    -- counts occupied units for specific property
    SELECT COUNT(*) INTO v_available_units
    FROM units
    WHERE property_id=NEW.property_id
    AND is_occupied=0;

    IF v_available_units IS NULL OR v_available_units=0 THEN
        UPDATE properties
        SET status = 'not available'
        WHERE id = NEW.property_id;
    ELSE
        UPDATE properties
        SET status = 'available'
        WHERE id = NEW.property_id;
    END IF;

END$$

-- RENTAL_CONTRACTS
-- when a new rental contract is added, add +30 days to start date, and set that as the end_date
CREATE TRIGGER set_rental_contract_end_date_trigger
BEFORE INSERT ON rental_contracts
FOR EACH ROW
BEGIN
    -- Fallback to current time if start_date is not explicitly passed
    IF NEW.start_date IS NULL THEN
        SET NEW.start_date = CURRENT_TIMESTAMP;
    END IF;

    -- Set end_date to start_date + 30 days
    SET NEW.end_date = DATE_ADD(NEW.start_date, INTERVAL 30 DAY);
END$$

-- MAINTENANCE_REQUESTS

DELIMITER ;

