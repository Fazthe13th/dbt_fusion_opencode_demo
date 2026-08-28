---
description: Generate reusable dbt macros for common patterns, transformations, or custom tests
agent: coder
model: ollama/qwen2.5-coder:14b
subtask: true
---

# dbt generate macro

## Objective
Create reusable, efficient, and well-documented dbt macros following best practices for the dbt Fusion update.

## Context
- Macros are Jinja2 functions that generate SQL
- They should be placed in macros/ directory
- Good macros reduce code duplication and improve maintainability
- dbt Fusion supports advanced Jinja features and cross-project references

## Macro Categories

### 1. Transform Macros
For data transformations and calculations

Example clean string macro:
- Purpose: Cleans and standardizes string values
- Operations: Trims whitespace, converts to lowercase, replaces multiple spaces
- Usage: select clean_string('customer_name') from table

### 2. Utility Macros
For common database operations

Example schema generation macro:
- Purpose: Overrides dbt default schema generation
- Allows custom schema naming patterns
- Handles both default and custom schema cases

### 3. Test Macros
For custom data quality tests

Example null proportion test macro:
- Purpose: Tests that at least a proportion of values are not null
- Parameter: proportion (default 0.95)
- Returns validation failures where condition is not met

### 4. Materialization Macros
For custom materialization strategies

Example incremental merge macro:
- Purpose: Custom incremental strategy using merge operations
- Uses adapter dispatch for cross-database support

## Workflow

### Phase 1: Requirements Analysis

1. Understand the use case
   - What problem does this macro solve?
   - How frequently will it be used?
   - Who are the target users (analysts, engineers)?

2. Check existing macros
   - Search macros/ directory for similar functionality
   - Review dbt-utils package for built-in solutions
   - Avoid duplicating existing functionality

### Phase 2: Design

1. Determine macro type
   - Simple expression vs complex logic
   - Single-use vs multi-purpose
   - Database-specific vs cross-database compatible

2. Design parameters
   - Required vs optional parameters
   - Default values for optional parameters
   - Clear parameter names

3. Plan for adaptability
   - Use adapter.dispatch() for cross-database support
   - Include proper error handling
   - Support both single values and lists/arrays

### Phase 3: Implementation

Standard macro documentation structure:

Parameters section should include:
- param_name: data_type - description of purpose
- Default values for optional parameters

Returns section should describe:
- SQL expression or complete statement returned

Usage section should show:
- Basic function call syntax
- Example within a SQL query

Notes section should cover:
- Special considerations for this macro
- Database compatibility requirements
- Performance implications

Examples section should demonstrate:
- Basic usage patterns
- Advanced usage with custom parameters
- Integration in larger queries

### Phase 4: Best Practices

1. Documentation
   - Use Jinja comments {# #} for all documentation
   - Document all parameters thoroughly
   - Provide multiple usage examples
   - Note any database-specific behavior

2. Performance
   - Minimize nesting of complex logic
   - Use appropriate whitespace control {%- -%}
   - Consider query optimization implications
   - Test with large datasets

3. Error Handling
   - Validate required parameters exist
   - Provide meaningful error messages
   - Handle edge cases gracefully
   - Consider null handling

4. Testing
   - Create test cases for the macro
   - Test with various input scenarios
   - Verify cross-database compatibility
   - Test edge cases and error conditions

### Phase 5: Output

1. Create macro file
   - Place in appropriate subdirectory within macros/
   - Name file descriptively (e.g., clean_string.sql)
   - One macro per file for simple macros
   - Group related macros in single files

2. Update documentation
   - Add to project README for commonly used macros
   - Include in team documentation
   - Provide migration guide if replacing old macros

## Common Patterns

### Pattern 1: Safe Division
Purpose: Handle division by zero gracefully
Logic: Return null when denominator is zero
Use case: Financial ratios and calculations

### Pattern 2: Date Spine
Purpose: Generate series of dates
Integration: Use dbt_utils date_spine or custom implementation
Use case: Filling gaps in time series data

### Pattern 3: Star Selector
Purpose: Select all columns except specified ones
Logic: Get all columns from relation, exclude listed ones
Use case: Excluding sensitive or unnecessary columns

### Pattern 4: Audit Columns
Purpose: Add standard audit columns to models
Columns: created_at, updated_at, created_by
Use case: Data lineage and debugging

## Validation Checklist

Before finalizing, verify:
- Macro has clear documentation
- All parameters have default values where appropriate
- Error handling is implemented
- Cross-database compatibility considered
- Performance implications documented
- Usage examples provided
- No duplicate functionality exists
- Proper whitespace control used
- Macro returns expected data types
- Tested with null and edge cases

## dbt Fusion Specific Considerations

1. Cross-project references
   - Macros can be referenced across projects
   - Use project prefixes for clarity

2. Version compatibility
   - Ensure macros work with dbt Fusion features
   - Test with new adapter features

3. Performance monitoring
   - Add logging for long-running macros
   - Consider materialization impact