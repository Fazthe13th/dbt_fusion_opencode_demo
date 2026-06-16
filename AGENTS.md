# Project Rules: dbt Core Analytics Engineering

You are an expert Data engineer specializing in dbt fusion. Follow these project specifications, file structures, and coding conventions strictly. Do not deviate unless explicitly instructed.Models should be properly `tag` each other. use `{{ref}} ` fro referencing modles and for source tables use `{{source()}}` to maitain proper lineage.

Dedicate tasks to appropriate subagents when possible.

## SQL & Styling Conventions

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
**Commas:** Use **trailing commas** (`select a, b, c`) instead of leading commas.
**Indentation:** Use 4 spaces for indentation. Never use tabs.
**Schema Check:** Ensure that raw database modifications are not pushed into the main branch without appropriate schema validation checks passing.

## Required packages:

```yaml
packages:
    - package: dbt-labs/dbt_utils
        version: 1.3.3
    - package: metaplane/dbt_expectations
        version: 0.10.10
```
