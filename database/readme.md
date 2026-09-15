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
  - [x] `users`: the person whose relation to a property could be either a tenant, owner, admin
  - [x] `properties`: the property holds units. payments are made for units.
  - [x] `units`: what tenant pay for.
  - [x] `rental_contracts`: contract between the owner and the tenant for a unit.
  - [x] `payments`: what is paid for a unit.
  - [x] `maintenance_requests`: maintenance requets made by tenants for a unit.
  - [x] `reviews`: what tenants think of your units.
  - [x] `messages`: chats between different users.

- **Stored Procedures**:
  _Users_
  - [x] `addUser`
  - [x] `getUserById`
  - [x] `getUserByUsername`
  - [x] `getUsersByRole`
  - [x] `getUsers`
  - [x] `updateUser`
  - [x] `updateUserPassword`
  - [x] `updateUserImage`
  - [x] `deleteUser`
        _Properties_
  - [x] `addProperty`
  - [x] `getPropertyById`
  - [x] `getPropertyByName`
  - [x] `getPropertyByType`
  - [x] `getAvailableProperties`
  - [x] `getAllProperties`
  - [x] `updateProperty`
  - [x] `deleteProperty`
        _Units_
  - [x] `addUnit`
  - [x] `getUnitById`
  - [x] `getUnitByUnitNumber`
  - [x] `getVacantUnits`
  - [x] `updateUnit`
  - [x] `deleteUnit`
        _Rental Contracts_
  - [x] `addRentalContract`
  - [x] `getRentalContractsByTenant`
  - [x] `getRentalContractsByStatus`
  - [x] `getAllRentalContracts`
  - [x] `updateRentalContract`
  - [x] `deleteRentalContract`
        _Payments_
  - [x] `addPayment`
  - [x] `getPaymentsByTenant`
  - [x] `getPaymentsForUnit`
  - [x] `getPaymentsByStatus`
  - [x] `getPaymentsByMethod`
  - [x] `getPayments`
  - [x] `updatePayment`
  - [x] `deletePayment`
        _Reviews_
  - [x] `addReview`
  - [x] `getReviewById`
  - [x] `getReviewByUserId`
  - [x] `getReviewsByStars`
  - [x] `getReviewsForProperty`
  - [x] `getReviews`
  - [x] `updateReview`
  - [x] `deleteReview`
        _Maintenance Requests_
  - [x] `addMaintenanceRequest`
  - [x] `getMaintenanceRequestsByUserId`
  - [x] `getMaintenanceRequestsForUnit`
  - [x] `getMaintenanceRequestStatus`
  - [x] `getMaintenanceRequests`
  - [x] `updateMaintenanceRequest`
  - [x] `resolveMaintenanceRequest`
  - [x] `deleteMaintenanceRequest`
- **Triggers**: Event-driven timestamp and status management.
  - [x] `set_property_status_trigger`:
  - [x] `set_rental_contract_end_date_trigger`:

- **Views**: Optimized read-only models for dashboards (e.g., Landlord Occupancy, Tenant Balance statements).
- **Functions**: Scalable calculated values (e.g., Calculating total outstanding tenant balances).
