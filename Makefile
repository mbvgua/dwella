.PHONY: all install test dev prod

# default target when you just run make
all: install prod

install:
	@echo "Installing project dependecies..."
	pip install --pre mariadb
	pip install -r requirements.txt
	# python -m scripts.populate_db

# test:
# 	python ...

# run server in development environment, with live reload and logging
dev:
	@echo "Starting local development server..."
	fastapi dev

# run server in production environment, no live reload
prod:
	@echo "Starting production server..."
	fastapi run
