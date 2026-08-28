## ✅ Finalized Sub-Plan: Source Table Definitions & Freshness Strategy

**Objective:** Define source tables and freshness for TPCH_SF10 schema aligned with Snowflake dialect and project conventions.

### 1. sources.yml Structure

Use the provided template to define source tables and freshness policies:

```yaml
version: 2

sources:
  - name: tpcds
    database: prod_db
    schema: tpcds_sf10
    description: "TPCH_SF10 Source Tables (Snowflake)"
    tables:
      - name: src_tpcds__customer
        description: "Customer dimension table with daily freshness"
        columns:
          - name: customer_id
            data_type: INTEGER
          - name: customer_name
            data_type: VARCHAR(255)
        freshness:
          every: 1 day
          warn_after:
            count: 12
            period: hour
          error_after:
            count: 24
            period: hour
      - name: src_tpcds__orders
        description: "Order fact table with daily freshness"
        columns:
          - name: order_id
            data_type: INTEGER
          - name: order_date
            data_type: DATE
        freshness:
          every: 1 day
          warn_after:
            count: 12
            period: hour
          error_after:
            count: 24
            period: hour
```

### 2. Key Configurations
- **Schema:** `tpcds_sf10` (aligns with Snowflake environment).
- **Freshness:** Daily updates with warning/error thresholds for data latency.
- **Lineage:** Columns match TPCH_SF10 schema docs (e.g., `customer_id` as INTEGER).

