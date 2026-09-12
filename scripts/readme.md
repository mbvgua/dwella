# Scripts

Here are some handy scripts that can be used within the application:

1. [`generate_database_url.py`](./generate_database_url.py): this is gotten from the official [alembic docs](https://alembic.sqlalchemy.org/en/latest/tutorial.html#escaping-characters-in-ini-files) and is used to help you figure out what your 'DATABASE_URL' is if you are unsure about it.

> [!NOTE]
>
> Due to the location of these scripts, you need to run them as a module from the root directory, e.g `python -m scripts.generate_database_url`
