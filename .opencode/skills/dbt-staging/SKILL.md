---
name: dbt-staging
description: Create and manage dbt staging models for source data standardization
---

# dbt Staging Skill

## Objective
Create staging models that clean and standardize raw source data for downstream use.

## Staging Layer Purpose
- One-to-one mapping with source tables
- Light transformations only
- No joins or aggregations
- No business logic
- Foundation for all downstream models

## Naming Convention
Format: stg_source_name__entity_name.sql
Examples:
- stg_salesforce__accounts.sql
- stg_stripe__payments.sql
- stg_google_analytics__events.sql

## Required Transformations

### Column Renaming
- Use descriptive, consistent names
- Remove source system prefixes
- Standardize naming: customer_id, order_date
- Document original column names in comments

### Data Type Casting
- Convert timestamps to proper datetime
- Cast numeric fields correctly
- Standardize boolean representations
- Handle varchar length issues

### Basic Cleaning
- Trim whitespace from strings
- Standardize null representations
- Convert empty strings to null
- Remove duplicate records

### Metadata Addition
- Add dbt_updated_at timestamp
- Add source system identifier
- Add ingestion timestamp if needed
- Add record hash for change detection

## Staging Model Structure

Config block:
- materialized: view (default for staging)
- tags: ['staging', 'source_system']

SQL structure:
1. Source CTE selecting from source
2. Renamed CTE with standardized column names
3. Cleaned CTE with basic transformations
4. Final SELECT with metadata columns

## Source Dependencies
- Use {{ source('source_name', 'table_name') }}
- Document source freshness requirements
- Note any source limitations
- Handle source schema changes

## Testing Requirements

Schema tests for staging:
- Not null on required fields
- Unique on primary keys
- Accepted values on known categories
- Relationships to reference tables

## Documentation Standards
- Header: source table, refresh frequency, grain
- Column descriptions from source documentation
- Transformation notes for complex casts
- Known data quality issues

## Performance Guidelines
- Keep as views unless performance issue
- Apply column selection (no SELECT *)
- Filter unused columns early
- Document performance considerations

## Common Patterns

### Pattern 1: Standard Staging
- Select all relevant columns
- Rename to standard names
- Cast data types
- Add metadata

### Pattern 2: Incremental Staging
- Use for large source tables
- Add unique_key configuration
- Filter by updated_at timestamp
- Handle deletes if needed

### Pattern 3: Multi-Source Staging
- Union compatible source tables
- Add source identifier column
- Handle schema differences
- Document merge logic

## Validation Checklist
- Naming follows convention
- One-to-one with source table
- No business logic or joins
- Metadata columns added
- Column descriptions complete
- Tests configured for required fields
- Performance acceptable