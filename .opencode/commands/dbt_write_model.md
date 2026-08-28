---
description: Create dbt SQL models following project conventions and best practices
agent: coder
model: ollama/qwen2.5-coder:14b
subtask: true
---

# dbt write model

## Objective
Create dbt SQL models following layered architecture.

## Model Types
- stg_: one-to-one with source, light transformations only
- int_: complex transformations between staging and marts
- dim_: descriptive attributes, fct_: numeric measurements

## Process
1. Determine business need, grain, and sources
2. Choose materialization: view, table, incremental, ephemeral
3. Write SQL with organized CTEs
4. Add config block with materialized type and tags
5. Create schema.yml with tests and column descriptions

## SQL Standards
- CTEs only, no subqueries
- Keywords lowercase
- Filter early, avoid SELECT *
- Add metadata column dbt_updated_at

## Requirements
- Header comment with description, grain, dependencies
- Primary key unique test
- Not null on required fields
- Performance: filter early, appropriate joins

## Validation
Naming convention followed, header complete, schema.yml includes tests, dependencies use ref() and source()