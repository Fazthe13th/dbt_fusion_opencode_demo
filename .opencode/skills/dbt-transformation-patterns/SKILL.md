---
name: dbt-transformation-patterns
description: Master dbt (data build tool) for analytics engineering with model organization, testing, documentation, and incremental strategies. Use when building data transformations, creating data models, or implementing analytics engineering best practices.
---

# dbt Transformation Patterns

Production-ready patterns for dbt (data build tool) including model organization, testing strategies, documentation, and incremental processing.

## When to Use This Skill

- Building data transformation pipelines with dbt
- Organizing models into staging, intermediate, and marts layers
- Implementing data quality tests
- Creating incremental models for large datasets
- Documenting data models and lineage
- Setting up dbt project structure

## Core Concepts

### 1. Model Layers (Medallion Architecture)

```
sources/          Raw data definitions
    ↓
staging/          1:1 with source, light cleaning
    ↓
flats/            Business logic, joins, aggregations
    ↓
marts/            Final analytics tables
```

### 2. Naming Conventions

| Layer        | Prefix         | Example                       |
| ------------ | -------------- | ----------------------------- |
| Staging      | `stg_`         | `stg_stripe__payments`        |
| Flats        | `f_`           | `f_payments_pivoted`        |
| Marts        | `dim_`, `fct_` | `dim_customers`, `fct_orders` |

## Quick Start

```yaml
# dbt_project.yml
name: "dbt_fusion_demo"
version: "1.0.0"
profile: "dbt_fusion_demo"

model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

vars:
  start_date: "2020-01-01"

models:
  dbt_fusion_demo:
    staging:
      +materialized: view
      +schema: staging
    flats:
      +materialized: table
      +schema: dbt_fusion_flats
    marts:
      +materialized: table
      +schema: dbt_fusion_mart
```

```
# Project structure
├── analyses/
├── macros/
│   └── generate_schema_name.sql  # for proper schema and table name
├── models/
│   ├── staging/        # table data type casting, temp data. materialization should be view if not explicitly specified
│   ├── flats/          # Component logic, complex joins, or heavy aggregations. Non-exposed.
│   ├── marts/        # Final models from where BI tool will read data.
│   └── sources/
│   └── models.yml
└── seeds/
└── tests/
└── snapshots/
```

## Detailed patterns and worked examples

Detailed pattern documentation lives in `references/details.md`. Read that file when the navigation tier above is insufficient.

## Best Practices

### Do's

- **Use staging layer** - Clean data once, use everywhere
- **Test aggressively** - Not null, unique, relationships
- **Document everything** - Column descriptions, model descriptions
- **Use incremental** - For tables > 1M rows
- **Version control** - dbt project in Git

### Don'ts

- **Don't skip staging** - Raw → mart is tech debt
- **Don't hardcode dates** - Use `{{ var('start_date') }}`
- **Don't repeat logic** - Extract to macros
- **Don't test in prod** - Use dev target
- **Don't ignore freshness** - Monitor source data
