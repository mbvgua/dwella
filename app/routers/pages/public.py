"""
this router defines endpoints that will be visible to the general public, hence
the naming :/. the routes do not need any backend functionality and all just
render certain templates.

are included in the main OpenAPI json schema since they do not convey sensitive
information
"""

from fastapi import APIRouter, Depends, Request, status
from fastapi.responses import HTMLResponse

from app.database import get_db
from app.main import templates

router = APIRouter()


@router.get("/", response_class=HTMLResponse)
async def home(request: Request):
    """
    this is the application main entrypoint. it renders the index page for of
    the website and from there one moves to other separate sections.
    """
    return templates.TemplateResponse(
        request,
        name="index.html",
        status_code=status.HTTP_200_OK,
    )


@router.get("/property-listings", response_class=HTMLResponse)
async def property_listings(request: Request):
    """
    this endpoint returns all available property listings
    """
    return templates.TemplateResponse(
        request,
        name="property_listings.html",
        status_code=status.HTTP_200_OK,
    )


@router.get("/property-details", response_class=HTMLResponse)
async def property_details(request: Request):
    """
    this endpoint returns all available property details
    """
    return templates.TemplateResponse(
        request,
        name="property_details.html",
        status_code=status.HTTP_200_OK,
    )


@router.get("/users")
async def list_users(db=Depends(get_db)):
    await db.execute("SELECT * FROM users;")
    data = await db.fetchall()
    return data
