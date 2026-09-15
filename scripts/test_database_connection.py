"""
testing the database connection to ensure it works as needed. this script is from the official mariadb docs:
https://mariadb.com/docs/connectors/mariadb-connector-python/async-usage#creating-an-async-pool
"""

import asyncio
import mariadb
from app.config import get_settings

settings = get_settings()


async def main():
    pool = None
    try:
        # Pass explicit parameters and set acquire_timeout to fail fast
        pool = await mariadb.create_async_pool(
            host=settings.db_host,
            user=settings.db_user,
            password=settings.db_password.get_secret_value(),  # Test credentials
            database=settings.db_name,
            min_size=1,  # Keep min_size low for test scripts
            max_size=5,
            acquire_timeout=5.0,  # Stops infinite connection waiting (seconds)
        )

        # Acquire connection with a timeout context
        async with await pool.acquire(timeout=5.0) as conn:
            async with conn.cursor() as cursor:
                await cursor.execute("SELECT 1;")
                row = await cursor.fetchone()
                print("Query Success:", row)

    except mariadb.Error as e:
        print(f"MariaDB Error: {e}")
    except asyncio.TimeoutError:
        print("Connection timed out after 5 seconds.")
    except Exception as e:
        print(f"Unexpected Error: {e}")
    finally:
        # Guarantee pool shutdown even if an exception occurs
        if pool:
            await pool.close()
            print("Pool closed cleanly.")


if __name__ == "__main__":
    asyncio.run(main())
