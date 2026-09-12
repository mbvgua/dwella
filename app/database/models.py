"""
defines our database tables schema using SqlAlchemy ORM. clean and allows
integration with anydatabase of your choosing
"""

from enum import Enum

from sqlalchemy import Boolean, ForeignKey, Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column

from app.database.config import Base


class UserRoles(str, Enum):
    """
    define the 3 distinct user roles within the application
    """

    Tenant = "Tenant"
    Landlord = "Landlord"
    Admin = "Admin"


class User(Base):
    """
    define the "users" table. it contains the following columns:
        - id: str
        - username: str
        - email: str
        - phone_number: str
        - password_hash: str
        - role: UserRoles
        - image_file: str
        - is_deleted: bool
        - is_welcome_email_sent: bool
    """

    __tablename__ = "users"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    username: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    email: Mapped[str] = mapped_column(String(100), unique=True, nullable=False)
    phone_number: Mapped[str] = mapped_column(String(50), nullable=False)
    password_hash: Mapped[str] = mapped_column(String(300), nullable=False)
    # make this an enum
    role: Mapped[UserRoles] = mapped_column(
        String(50), nullable=False, default=UserRoles.Tenant
    )
    image_file: Mapped[str | None] = mapped_column(
        String(200), nullable=True, default=None
    )
    is_deleted: Mapped[bool] = mapped_column(Boolean, default=False)
    is_welcome_email_sent: Mapped[bool] = mapped_column(Boolean, default=False)


class Properties(Base):
    """
    define the properties table. this contains:
        - id: str (PK)
        - owner_id:str (FK)
        - name: str
        - property_type: enum
        - status: enum
        - location: str
        - created_at
        - is_deleted
    """

    __tablename__ = "properties"


class Payments(Base):
    """
    defines the paymentstable. it contains:
        - id: str
        - date_paid
        -
    """
