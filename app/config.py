"""
defines the applications environmental variables. use pyrdantic_settings is a
modern replacement for the classic python_dotenv module with some added niceties

NOTE:
    - ref: https://fastapi.tiangolo.com/advanced/settings/
"""

from functools import lru_cache

from pydantic import SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """
    defines the settings class that will hold our specific environmental
    varibales. it inherits from the BaseSettings pydantic class. pydantic reads
    these values in a case-insensitive way
    """

    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

    db_host: str
    db_port: str
    db_user: str
    db_password: SecretStr = SecretStr("")
    db_name: str
    db_test_name: str


@lru_cache()
def get_settings() -> Settings:
    """
    this methods makes it easier to use our Settings defined above via
    dependency injection. Normally, we would use "settings=Settings()", but
    this defines 1 default instance throughout our application. instead calling
    it this way with lru_cache creates it only once and caches it, andalso allows
    for dependency overrides
    """
    return Settings()
