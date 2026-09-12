"""
generates an asynchronous(non-blocking) database connection. better since
common IO bound tasks such as database reads and writes happen in the
background and you dont have to wait fore them to execute to completion.
"""

from sqlalchemy.ext.asyncio import AsyncSession, async_sessionmaker, create_async_engine
from sqlalchemy.orm import DeclarativeBase

from app.config import settings

engine = create_async_engine(settings.database_url)

# create transactionpools within the db
async_session_local = async_sessionmaker(
    engine,
    class_=AsyncSession,
    expire_on_commit=False,
)


class Base(DeclarativeBase):
    pass


async def get_db():
    """
    provide sessions to our routes. fastAPI will reference this
    function(through dependency injection) for each request, ensuring that it
    each request has its own session, in which cleanup happens automatically
    """
    async with async_session_local() as db:
        yield db
