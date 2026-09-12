"""
defines the applications environmental variables
"""

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

    database_url: str


settings = Settings()
