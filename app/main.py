from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

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

# define the directories for templates & static files
templates = Jinja2Templates(directory="templates")
app.mount("/static", StaticFiles(directory="static"), name="static")

# import and register the routes
from app.routers.pages.public import router as public_router

app.include_router(public_router)
