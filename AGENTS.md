# Project Rules: dbt Core Analytics Engineering

You are an expert Data engineer specializing in dbt fusion. Follow these project specifications, file structures, and coding conventions strictly. Do not deviate unless explicitly instructed.Models should be properly `tag` each other. use `{{ref}} ` fro referencing modles and for source tables use `{{source()}}` to maitain proper lineage.

## Project Structure
You should follow this project structure

├── analyses/
├── macros/
│   └── generate_schema_name.sql  # for proper schema and table name
├── models/
│   ├── staging/        # table data type casting, temp data. materialization should be view if not explicitly specified
│   ├── flats/          # Component logic, complex joins, or heavy aggregations. Non-exposed.
│   ├── marts/        # Final models from where BI tool will read data.
│   └── source.yml
│   └── models.yml
└── seeds/
└── tests/
└── snapshots/

### Layer Constraints
*   **Staging:** Prefix with `stg_`. Never join staging files from different source systems together.
*   **flats:** Prefix with `f_`. These should always materialise as `table` or `view` in their file/config headers.
*   **Marts:** Prefix with `dim_` (dimension) or `fct_` (fact). These represent the clean, production-ready data warehouse layer. Their materialization is incremental 

## 2. SQL & Styling Conventions

*   **Dialect:** Snowflake .
*   **Keywords:** Always write SQL keywords in **lowercase** (`select`, `from`, `where`, `left join`, `group by`).
*   **CTE Structure:** Use Common Table Expressions (CTEs) for all imports and logical chunks. Wrap the entire query with a final delivery block.
    *   *Example Structure:*
```sql
with

orders as (
    select * from {{ ref('stg_jaffle_shop__orders') }}
),

payments as (
    select * from {{ ref('stg_stripe__charges') }}
),

final as (
    select
        orders.order_id,
        payments.amount
    from orders
    left join payments on orders.order_id = payments.order_id
)

select * from final
```
*   **Commas:** Use **trailing commas** (`select a, b, c`) instead of leading commas.
*   **Indentation:** Use 4 spaces for indentation. Never use tabs.
*
---

## 3. Testing & Documentation Requirements

Final mart table models added or modified **must** be documented and tested in  `models.yml` or if any business logic test we need to do for example table a innher join table b row counts should be as table as derived table after couple of trasformation named table z row count. For business logic test cases use `metaplane/dbt_expectations`

## Development Loop

**Execute DBT Models:**
```bash
dbt run --select <model_name>
```

**Execute Integration Tests:** Ensure downstream impact is fully evaluated:
```bash
dbt test --select <model_name>
```

**Schema Check:** Ensure that raw database modifications are not pushed into the main branch without appropriate schema validation checks passing.

## Required packages:

```yaml
packages:
    - package: dbt-labs/dbt_utils
        version: 1.3.3
    - package: metaplane/dbt_expectations
        version: 0.10.10
```
