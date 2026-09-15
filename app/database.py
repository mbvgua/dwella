"""
generates an asynchronous(non-blocking) database connection. better since
common IO bound tasks such as database reads and writes happen in the
background and you dont have to wait fore them to execute to completion.

NOTE:
    - opted to go with basic maridb python connector, since I have some stored
      procedures and views that are hard to implement using SQLAlchemyORM &
      alembic migrations. I recently used the SQLAlchemyORM and the grass is
      always greener... :)
"""

import mariadb

from app.config import get_settings

settings = get_settings()
pool: mariadb.ConnectionPool | None = None


async def init_pool():
    global pool

    pool = await mariadb.create_async_pool(
        host=settings.db_host,
        user=settings.db_user,
        password=settings.db_password.get_secret_value(),
        database=settings.db_name,
        min_size=5,
        max_size=10,
    )


async def close_pool():
    global pool

    # close pool when done
    if pool:
        await pool.close()


async def get_db():
    """
    works in tandem with the lifespan to yield a dictionary cursor per request.
    it will automatically return a cursor and connection to the pool when
    finished
    """
    if pool is None:
        raise RuntimeError("Database pool has not been initialized")

    # Double context manager: acquires connection and creates cursor,
    # auto-closing both when the HTTP request finishes.
    async with await pool.acquire() as conn:
        async with conn.cursor(dictionary=True) as cursor:
            yield cursor
