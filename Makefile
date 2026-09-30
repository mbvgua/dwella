.PHONY: all install test dev prod

# default target when you just run make
all: install prod

install:
	@echo "Installing project dependecies..."
	pip install -r requirements.txt
	python -m scripts.populate_database

# test application
test:
	@echo "Testing database connection..."
	python -m scripts.test_database_connection

# run server in development environment, with live reload and logging
dev:
	@echo "Starting local development server..."
	# sass --watch ./static/css/main.scss ./static/css/main.css
	fastapi dev

# run server in production environment, no live reload
prod:
	@echo "Starting production server..."
	fastapi run
