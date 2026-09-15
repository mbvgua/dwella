"""
defines the applications environmental variables
"""

from pydantic import SecretStr
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    """
    use pyrdantic_settings is a modern replacement for the classic
    python_dotenv module.
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


def get_settings() -> Settings:
    return Settings()
