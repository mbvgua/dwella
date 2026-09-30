# Dwella

Dwella is a comprehensive digital platform designed to bridge communication and management gaps for rental properties. The architecture replicates the provided [project-overview.pdf](./docs/project-overview.pdf) structure, relying on a unified space tailored for efficient property management.

---

## Getting Started

> [!NOTE]
> Prerequisites
>
> - Python 3.9+
> - Node.js 16+
> - MariaDB 10.5+
> - Redis
> - RabbitMQ (optional for development; can use in-memory)
> - Docker (recommended)

### Local Development (without Docker)

1. **Clone the repository**

   ```bash
   git clone https://github.com/mbvgua/dwella.git
   cd dwella
   ```

2. **Backend Setup**

   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate        # if on windows, too bad :/
   cp .env.example .env            # Edit .env with your database, JWT secret, etc.
   make install
   make prod
   ```

3. **Frontend Setup**

   ```bash
   cd frontend
   npm install
   cp .env.example .env            # Edit .env with your database, JWT secret, etc.
   npm start
   ```

The backend will be available at `http://localhost:8000` (with docs at `/docs`), and the frontend at `http://localhost:3000`.

### Running with Docker

The easiest way is to use Docker Compose:

    ```bash
    cp .env.example .env            # Edit .env with your database, etc.
    docker-compose up
    ```

This will spin up the backend, frontend, database, Redis, and RabbitMQ.
