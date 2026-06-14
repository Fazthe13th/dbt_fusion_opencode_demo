---
name: dbt-debug-macro
description: Debug dbt macros and execute ad-hoc SQL using run-operation command
---

# dbt Debug Macro Skill

## Objective
Debug macros, test SQL logic, and execute ad-hoc operations against the database using dbt run-operation.

## Core Commands

### Execute Named Macro
Run a specific macro with arguments:
dbt run-operation macro_name --args '{args_as_yaml}'

### Execute Raw SQL
Run SQL directly without a macro:
dbt run-operation --sql '{sql_or_jinja}'

### Important Notes
- macro and --sql cannot be used together
- --args only works with named macro, not with --sql
- --sql available in dbt Core v1.12 and above
- --args expects YAML string format

## Use Cases

### Debugging Macros
- Test macro logic in isolation
- Validate parameter handling
- Debug Jinja template errors
- Verify SQL output before integration

### Database Operations
- Grant permissions
- Create schemas or tables
- Execute maintenance operations
- Run ad-hoc queries

### Data Validation
- Check row counts
- Verify data loads
- Sample data inspection
- Quick data quality checks

### Development Workflow
- Prototype SQL before creating models
- Test complex expressions
- Validate cross-database compatibility
- Quick environment checks

## Macro Execution Pattern

### Basic Macro Call
Command: dbt run-operation my_macro
When: Macros without parameters
Example: Grant permissions, audit tables

### Macro with Single Argument
Command: dbt run-operation my_macro --args '{key: value}'
When: Parameterized macros
Format: YAML dictionary string in single quotes

### Macro with Multiple Arguments
Command: dbt run-operation my_macro --args '{param1: value1, param2: value2}'
When: Complex macro calls
Note: Quote strings in YAML if they contain special characters

### Macro with Nested Arguments
Command: dbt run-operation my_macro --args '{columns: [col1, col2], config: {key: val}}'
When: Passing lists or dictionaries
Format: Standard YAML syntax for nested structures

## Raw SQL Execution Pattern

### Simple Query
Command: dbt run-operation --sql 'select count(*) from my_table'
When: Quick data checks
Note: ref() and source() functions work in --sql mode

### Query with References
Command: dbt run-operation --sql 'select * from source_table limit 10'
When: Data sampling with source references
Note: Jinja expressions fully supported

### Complex Operations
Command: dbt run-operation --sql 'create table temp as select * from my_model'
When: Database operations
Warning: Changes persist, use with caution in production

## Common Debug Macros

### Print Variable Values
Purpose: Inspect Jinja variables
Method: Use log() function within macro
Use: Debug configuration or parameter values

### Check Graph Structure
Purpose: List model dependencies
Method: Access graph.nodes in macro
Use: Understand lineage and dependencies

### Validate Sources
Purpose: Check source freshness and counts
Method: Query source tables and return stats
Use: Quick data quality checks before runs

### Inspect Relations
Purpose: Get column list from table
Method: Use adapter.get_columns_in_relation()
Use: Schema exploration and validation

## Debug Workflow

### Step 1: Isolate the Issue
- Identify failing macro or SQL
- Extract into minimal reproducible case
- Test in isolation with run-operation

### Step 2: Test with Simple Inputs
- Use hardcoded values initially
- Gradually introduce parameters
- Verify each step independently

### Step 3: Inspect Output
- Use log() to print intermediate values
- Check compiled SQL in target directory
- Verify return values match expectations

### Step 4: Validate Database State
- Check if tables and views exist
- Verify permissions are correct
- Test with actual data samples

## Safety Guidelines

### Production Caution
- Never run destructive operations in production
- Use --target flag to specify environment
- Test thoroughly in development first
- Review compiled SQL before execution

### Destructive Operations to Avoid
- DROP TABLE statements
- DELETE without WHERE filters
- TRUNCATE operations
- Schema modifications
- ALTER TABLE statements

### Read-Only Operations Safe Anywhere
- SELECT queries
- EXPLAIN plans
- Row counts
- Data sampling with LIMIT
- DESCRIBE operations

## Common Patterns

### Pattern 1: Row Count Check
Purpose: Verify data volume
Command: dbt run-operation --sql 'select count(*) from source_table'

### Pattern 2: Sample Data Inspection
Purpose: Check data quality
Command: dbt run-operation --sql 'select * from source_table limit 5'

### Pattern 3: Distinct Values Check
Purpose: Validate categories
Command: dbt run-operation --sql 'select distinct status from orders'

### Pattern 4: Grant Permissions
Purpose: Set up access
Command: dbt run-operation grant_access --args '{schema: analytics, role: analyst}'

### Pattern 5: Macro Unit Test
Purpose: Validate macro output
Command: dbt run-operation clean_string --args '{column_name: TEST_VALUE}'

### Pattern 6: Date Range Check
Purpose: Verify data freshness
Command: dbt run-operation --sql 'select min(date), max(date) from model_name'

## Error Handling

### Common Errors
- Macro not found: Check macro name spelling and file location
- YAML parsing error: Validate --args format and quoting
- Jinja compilation error: Check template syntax
- Database permission error: Verify credentials and access
- Relation not found: Check if table or view exists

### Debug Commands
- dbt compile: Check SQL without execution
- dbt debug: Verify connection settings
- Add --log-format json: Structured logging output
- Add --debug flag: Verbose execution details

## Integration with Development

### Pre-Model Development
- Test SQL logic before creating models
- Validate transformations on sample data
- Check cross-database compatibility

### During Development
- Debug failing models incrementally
- Test complex expressions in isolation
- Verify assumptions about source data

### Code Review Support
- Demonstrate macro behavior to reviewers
- Test edge cases independently
- Validate business logic in isolation

## dbt Fusion Features

### Cross-Project References
- Test macros from other projects
- Validate cross-project dependencies
- Debug project interactions

### New Adapter Features
- Test adapter-specific functionality
- Validate version compatibility
- Explore new dbt features safely

## Validation Checklist
Before executing, verify:
- Test in development environment first
- Review compiled SQL before execution
- Use read-only operations when possible
- Document any database changes made
- Clean up temporary objects after testing
- Verify expected results match actual output
- Command syntax follows: macro OR sql, not both
- Args are valid YAML format when used