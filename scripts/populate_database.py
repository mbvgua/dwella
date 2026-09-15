import asyncio
import json
import mariadb
from app.config import get_settings

settings = get_settings()

# --- SEED DATA DEFINITIONS (At least 5 rows per table) ---

USERS = [
    (
        "usr_admin_01",
        "admin_alice",
        "alice@dwella.com",
        "$2b$12$eImiTXuWVxfM37uY4JANjOL.80F8q4.OqB4.e.4a.2/a",
        "admin",
        "+254700000001",
        "profiles/alice.jpg",
    ),
    (
        "usr_owner_01",
        "owner_bob",
        "bob@properties.com",
        "$2b$12$eImiTXuWVxfM37uY4JANjOL.80F8q4.OqB4.e.4a.2/b",
        "owner",
        "+254700000002",
        "profiles/bob.jpg",
    ),
    (
        "usr_owner_02",
        "owner_charlie",
        "charlie@realestate.com",
        "$2b$12$eImiTXuWVxfM37uY4JANjOL.80F8q4.OqB4.e.4a.2/c",
        "owner",
        "+254700000003",
        "profiles/charlie.jpg",
    ),
    (
        "usr_tenant_01",
        "tenant_david",
        "david@gmail.com",
        "$2b$12$eImiTXuWVxfM37uY4JANjOL.80F8q4.OqB4.e.4a.2/d",
        "tenant",
        "+254700000004",
        "profiles/david.jpg",
    ),
    (
        "usr_tenant_02",
        "tenant_eva",
        "eva@yahoo.com",
        "$2b$12$eImiTXuWVxfM37uY4JANjOL.80F8q4.OqB4.e.4a.2/e",
        "tenant",
        "+254700000005",
        "profiles/eva.jpg",
    ),
    (
        "usr_tenant_03",
        "tenant_frank",
        "frank@outlook.com",
        "$2b$12$eImiTXuWVxfM37uY4JANjOL.80F8q4.OqB4.e.4a.2/f",
        "tenant",
        "+254700000006",
        "profiles/frank.jpg",
    ),
]

PROPERTIES = [
    (
        "prop_01",
        "usr_owner_01",
        "Kilimani Heights",
        "apartment",
        json.dumps({"city": "Nairobi", "street": "Argwings Kodhek Rd"}),
        "available",
    ),
    (
        "prop_02",
        "usr_owner_01",
        "Suburbs Student Residency",
        "hostel",
        json.dumps({"city": "Nairobi", "street": "Magadi Road"}),
        "available",
    ),
    (
        "prop_03",
        "usr_owner_02",
        "Downtown Executive Suites",
        "office space",
        json.dumps({"city": "Nairobi", "street": "Kenyatta Ave"}),
        "available",
    ),
    (
        "prop_04",
        "usr_owner_02",
        "Westlands Luxury Haven",
        "apartment",
        json.dumps({"city": "Nairobi", "street": "Waiyaki Way"}),
        "available",
    ),
    (
        "prop_05",
        "usr_owner_01",
        "Transit Lodge",
        "motel",
        json.dumps({"city": "Mombasa", "street": "Moi Ave"}),
        "not available",
    ),
]

UNITS = [
    ("unit_101", "prop_01", "A-101", 45000.00, True),
    ("unit_102", "prop_01", "A-102", 48000.00, True),
    ("unit_103", "prop_01", "B-201", 52000.00, False),
    ("unit_201", "prop_02", "H-01", 15000.00, True),
    ("unit_301", "prop_03", "Suite 300", 120000.00, True),
]

CONTRACTS = [
    (
        "cntr_01",
        "unit_101",
        "usr_tenant_01",
        "active",
        45000.00,
        90000.00,
        "2026-01-01 00:00:00",
        "2026-12-31 23:59:59",
        "2026-01-05 00:00:00",
    ),
    (
        "cntr_02",
        "unit_102",
        "usr_tenant_02",
        "active",
        48000.00,
        96000.00,
        "2026-02-01 00:00:00",
        "2027-01-31 23:59:59",
        "2026-02-05 00:00:00",
    ),
    (
        "cntr_03",
        "unit_201",
        "usr_tenant_03",
        "active",
        15000.00,
        30000.00,
        "2026-03-01 00:00:00",
        "2026-08-31 23:59:59",
        "2026-03-05 00:00:00",
    ),
    (
        "cntr_04",
        "unit_301",
        "usr_tenant_01",
        "expired",
        120000.00,
        240000.00,
        "2025-01-01 00:00:00",
        "2025-12-31 23:59:59",
        "2025-01-05 00:00:00",
    ),
    (
        "cntr_05",
        "unit_103",
        "usr_tenant_02",
        "expired",
        52000.00,
        104000.00,
        "2025-06-01 00:00:00",
        "2026-05-31 23:59:59",
        "2025-06-05 00:00:00",
    ),
]

PAYMENTS = [
    (
        "pay_01",
        "unit_101",
        "usr_tenant_01",
        45000.00,
        "completed",
        "mpesa",
        "MPESA_REF_99812",
    ),
    (
        "pay_02",
        "unit_102",
        "usr_tenant_02",
        48000.00,
        "completed",
        "bank",
        "BANK_REF_33411",
    ),
    (
        "pay_03",
        "unit_201",
        "usr_tenant_03",
        15000.00,
        "completed",
        "mpesa",
        "MPESA_REF_11029",
    ),
    (
        "pay_04",
        "unit_301",
        "usr_tenant_01",
        120000.00,
        "pending",
        "stripe",
        "STRIPE_CH_90021",
    ),
    (
        "pay_05",
        "unit_101",
        "usr_tenant_01",
        45000.00,
        "failed",
        "mpesa",
        "MPESA_REF_44012",
    ),
]

REVIEWS = [
    (
        "rev_01",
        "usr_tenant_01",
        "unit_101",
        5,
        "Spacious unit with great natural light.",
    ),
    (
        "rev_02",
        "usr_tenant_02",
        "unit_102",
        4,
        "Quiet neighborhood, water supply is steady.",
    ),
    (
        "rev_03",
        "usr_tenant_03",
        "unit_201",
        3,
        "Decent hostel room, but Wi-Fi can be slow during peak hours.",
    ),
    (
        "rev_04",
        "usr_tenant_01",
        "unit_301",
        5,
        "Excellent office setup and reliable security.",
    ),
    (
        "rev_05",
        "usr_tenant_02",
        "unit_103",
        2,
        "A bit noisy due to nearby street traffic.",
    ),
]

MAINTENANCE_REQUESTS = [
    (
        "maint_01",
        "unit_101",
        "usr_tenant_01",
        "usr_admin_01",
        "Leaking sink faucet in main bath.",
        "medium",
        "resolved",
    ),
    (
        "maint_02",
        "unit_102",
        "usr_tenant_02",
        None,
        "Balcony sliding door latch is jammed.",
        "low",
        "pending",
    ),
    (
        "maint_03",
        "unit_201",
        "usr_tenant_03",
        "usr_owner_01",
        "Hot shower breaker keeps tripping.",
        "high",
        "in progress",
    ),
    (
        "maint_04",
        "unit_301",
        "usr_tenant_01",
        "usr_admin_01",
        "AC unit leaking water into hallway.",
        "high",
        "resolved",
    ),
    (
        "maint_05",
        "unit_101",
        "usr_tenant_01",
        None,
        "Kitchen light fixture flickers.",
        "low",
        "pending",
    ),
]


async def populate_database():
    pool = None
    try:
        pool = await mariadb.create_async_pool(
            host=settings.db_host,
            user=settings.db_user,
            password=settings.db_password.get_secret_value(),
            database=settings.db_name,
            port=int(settings.db_port),
            min_size=1,
            max_size=5,
            acquire_timeout=10.0,
        )

        async with await pool.acquire() as conn:
            async with conn.cursor() as cursor:
                print("Clearing old data...")
                await cursor.execute("SET FOREIGN_KEY_CHECKS = 0;")
                tables = [
                    "maintenance_requests",
                    "reviews",
                    "payments",
                    "rental_contracts",
                    "units",
                    "properties",
                    "users",
                ]
                for table in tables:
                    await cursor.execute(f"TRUNCATE TABLE {table};")
                await cursor.execute("SET FOREIGN_KEY_CHECKS = 1;")

                print("Inserting users...")
                await cursor.executemany(
                    """INSERT INTO users 
                    (id, username, email, password_hash, role, phone_number, image_file) 
                    VALUES (?, ?, ?, ?, ?, ?, ?)""",
                    USERS,
                )

                print("Inserting properties...")
                await cursor.executemany(
                    """INSERT INTO properties 
                    (id, owner_id, name, property_type, location, status) 
                    VALUES (?, ?, ?, ?, ?, ?)""",
                    PROPERTIES,
                )

                print("Inserting units...")
                await cursor.executemany(
                    """INSERT INTO units 
                    (id, property_id, unit_number, monthly_rent, is_occupied) 
                    VALUES (?, ?, ?, ?, ?)""",
                    UNITS,
                )

                print("Inserting rental contracts...")
                await cursor.executemany(
                    """INSERT INTO rental_contracts 
                    (id, unit_id, tenant_id, status, rent_amount, deposit_amount, start_date, end_date, billing_date) 
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)""",
                    CONTRACTS,
                )

                print("Inserting payments...")
                await cursor.executemany(
                    """INSERT INTO payments 
                    (id, unit_id, tenant_id, amount, status, payment_method, transaction_reference) 
                    VALUES (?, ?, ?, ?, ?, ?, ?)""",
                    PAYMENTS,
                )

                print("Inserting reviews...")
                await cursor.executemany(
                    """INSERT INTO reviews 
                    (id, user_id, unit_id, stars_rating, message) 
                    VALUES (?, ?, ?, ?, ?)""",
                    REVIEWS,
                )

                print("Inserting maintenance requests...")
                await cursor.executemany(
                    """INSERT INTO maintenance_requests 
                    (id, unit_id, raised_by, resolved_by, description, priority, status) 
                    VALUES (?, ?, ?, ?, ?, ?, ?)""",
                    MAINTENANCE_REQUESTS,
                )

                await conn.commit()
                print("\nDatabase populated successfully!")

    except mariadb.Error as e:
        print(f"MariaDB Population Error: {e}")
    finally:
        if pool:
            await pool.close()


if __name__ == "__main__":
    asyncio.run(populate_database())
