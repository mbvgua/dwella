# Scripts

Here are some handy scripts that can be used within the application. Due to the location of these scripts, you need to run them as a module from the root directory, e.g `python -m scripts.generate_database_url`

1. [`generate_database_url.py`](./generate_database_url.py): this is gotten from the official [alembic docs](https://alembic.sqlalchemy.org/en/latest/tutorial.html#escaping-characters-in-ini-files) and is used to help you figure out what your 'DATABASE_URL' is if you are unsure about it.

2. [`test_database_connection.py`]("./test_database_connection.py"): this is from the official [mariadb docs][https://mariadb.com/docs/connectors/mariadb-connector-python/async-usage#creating-an-async-pool] and it tests if your application is able to connect to the database.

3. [`populate_database.py`](./populate_database.py): this populates the database with placeholder values, only 5 rows long on each table.
