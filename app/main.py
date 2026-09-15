from contextlib import asynccontextmanager

from fastapi import Depends, FastAPI

from app.database import get_db, init_pool, close_pool


@asynccontextmanager
async def lifespan(app: FastAPI):
    # startup initializes pool
    await init_pool()

    yield

    # shutdown closes pool
    await close_pool()


app = FastAPI(
    title="dwella",
    lifespan=lifespan,
    description="""a comprehensive digital platform designed to bridge 
    communication and management gaps for rental properties""",
    license_info={
        "name": "MIT",
        "url": "https://opensource.org/license/mit",
    },
)


@app.get("/")
async def home():
    return "hello there"


@app.get("/users")
async def list_users(db=Depends(get_db)):
    await db.execute("SELECT * FROM users;")
    data = await db.fetchall()
    return data
