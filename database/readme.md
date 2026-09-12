# Database Architecture

> [!IMPORTANT]
> **Architectural Decisions & Naming Conventions**
>
> - **MariaDB Engine**: Chosen as the primary relational database system.
>
> - **Raw SQL Strategy**: was torn between using the SQLAlchemy ORM and managed with Alembic migrations or writing things in pure SQL. Came to the conclusion that advanced logic such as Database Views, Stored Procedures, Triggers, and Functions might prove to be difficult to implement in the SQLAlchemy ORM, hence opted for the later. With the help of some [bash scripting](./setup) configuartion is much easier. Also SQL **is** the DSL for working with databases for a reason :)
>
> - **Parameter Naming Standard**: All parameters in Stored Procedures and Functions **must** be prefixed with `p_` (e.g., `p_user_id`, `p_unit_id`). This strictly prevents variable shadowing in MariaDB, where identical parameter and column names (such as `WHERE id = id`) cause catastrophic query logic errors.

### Schema Overview

- **Tables**:
  - [x] `users`
  - [x] `properties`
  - [x] `units`
  - [x] `rental_contracts`
  - [x] `payments`
  - [x] `maintenance_requests`
  - [x] `reviews`
  - [x] `messages`
- **Stored Procedures**:
- **Views**: Optimized read-only models for dashboards (e.g., Landlord Occupancy, Tenant Balance statements).
- **Triggers**: Event-driven timestamp and status management (e.g., Setting `resolved_at` on maintenance ticket completion).
- **Functions**: Scalable calculated values (e.g., Calculating total outstanding tenant balances).

### Core Tables
