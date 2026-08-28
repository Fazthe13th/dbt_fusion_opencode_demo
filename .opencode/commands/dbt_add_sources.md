---
description: Add new dbt sources configuration based on existing database tables or views
agent: reviewer
model: ollama/qwen3:14b
subtask: true
---

# dbt add sources

## Objective
Create or update dbt source YAML files to document raw data tables or views in the data warehouse.

## Context
- dbt sources represent raw data tables or views in your data warehouse
- Sources should be defined before creating staging models
- Each source table should include descriptions, column definitions, and basic tests
- Sources are typically defined in models/sources/ directory

## Workflow

### Phase 1: Analysis
1. Identify target sources
   - Review the database schema or table list provided by the user
   - Understand the business context of the data
   - Identify table relationships and dependencies

2. Assess existing sources
   - Check models/sources/ for existing source configurations
   - Identify if adding to existing sources or creating new ones

### Phase 2: Source Configuration Design

For each source, determine the structure following this template:
```yaml
version: 2
sources:
  - name: source_name (e.g.,ERP, salesforce, stripe, raw_events)
    description: business description of the source system
    database: database_name (if different from target)
    schema: schema_name
    freshness:
      warn_after:
        count: number_of_hours
        period: hour
      error_after:
        count: number_of_hours
        period: hour
      filter: timestamp_column > current_timestamp - interval 'X hours'
    tables:
      - name: table_name
        description: description of what this table represents
        freshness:
          warn_after:
            count: number_of_hours
            period: hour
        loaded_at_field: timestamp_field_for_freshness
        columns:
          - name: column_name
            description: column description
            tests:
              - not_null
              - unique
              - accepted_values:
                  values: ['value1', 'value2']
            tags: ['tag1']
```

### Phase 3: Quality Checks

1. Column Analysis
   - Identify primary key columns: add unique and not_null tests
   - Identify foreign key columns: add relationships tests
   - Identify categorical columns: add accepted_values tests
   - Identify timestamp columns: use for freshness checks

01-------------2. Naming Conventions
   - Source names: lowercase, underscored (e.g., ERP, salesforce, google_analytics)
   - Table names: match actual database names exactly
   - Column names: match actual database names exactly

3. Documentation
   - Every source should have a description
   - Every table should have a business description
   - Critical columns should have descriptions
   - Add tags for discoverability

### Phase 4: Output Generation

1. Generate or update YAML files
   - Create models/sources/_source_name.yml
   - Include proper YAML formatting and comments
   - Ensure version: 2 is at the top

2. Provide implementation notes
   - Any manual steps needed (granting permissions, etc.)
   - Testing instructions
   - Freshness check configuration notes

## Example Structure

models/sources/
  _sources.yml (main source definitions)
  _sources_salesforce.yml
  _sources_stripe.yml
  _sources_google_analytics.yml

## Validation Checklist

Before finalizing, verify:
- Source names follow naming conventions
- All tables have descriptions
- Primary keys have uniqueness tests
- Timestamp columns have freshness configurations
- YAML is syntactically valid
- No duplicate source names
- Appropriate tags are applied

## Notes
- Focus on accuracy over completeness
- Document 5 columns well rather than 50 poorly
- Include tests only where confident in data quality
- Add comments for columns where business meaning might be ambiguous