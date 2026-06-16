---
description: Create singular dbt tests for complex data quality validations
agent: tester
model: ollama/qwen2.5-coder:7b
subtask: true
---

# dbt write singular test

## Objective
Create singular dbt tests that validate complex business rules and data quality requirements that cannot be expressed through generic schema tests.

## Context
- Singular tests are SQL queries that return failing records
- They are stored in tests/ directory
- Each test should return zero rows to pass
- Tests run during dbt test execution
- Singular tests complement schema tests for complex validations

## When to Use Singular Tests

Use singular tests when:
- Business logic involves multiple columns
- Validation requires joins between tables
- Rules span across multiple models
- Conditional logic is required
- Temporal validations are needed

Do not use singular tests for:
- Simple null checks (use not_null schema test)
- Primary key uniqueness (use unique schema test)
- Accepted value checks (use accepted_values schema test)
- Basic relationships (use relationships schema test)

## Test Categories

### 1. Data Integrity Tests
Validate referential integrity and data consistency

Examples:
- Orphan records in child tables
- Duplicate records with different values
- Invalid parent-child relationships
- Circular dependencies in hierarchical data

### 2. Business Rule Tests
Validate domain-specific business logic

Examples:
- Order dates cannot be in the future
- Discount percentage must be between 0 and 100
- Employee hire date must be after birth date
- Product price must be positive

### 3. Temporal Tests
Validate time-based data quality

Examples:
- No overlapping date ranges for same entity
- Sequential dates have no gaps
- Event timestamps are in correct order
- Data freshness within acceptable range

### 4. Consistency Tests
Validate consistency across related models

Examples:
- Fact table totals match aggregate tables
- Dimension counts match source systems
- Running sums match cumulative values
- Daily totals sum to monthly totals

## Workflow

### Phase 1: Requirements Analysis

1. Understand the validation need
   - What business rule needs validation?
   - Which models or sources are involved?
   - What is the expected behavior?
   - How critical is this validation?

2. Identify failure conditions
   - What data patterns indicate a problem?
   - What are the edge cases?
   - Are there valid exceptions?
   - What is acceptable failure rate?

### Phase 2: Test Design

1. Define the test scope
   - Single model or cross-model validation
   - Current state or historical analysis
   - Full table scan or targeted check
   - Performance considerations

2. Design the failure query
   - Return only records that violate rules
   - Include meaningful context columns
   - Add diagnostic information
   - Consider query performance

3. Plan for maintainability
   - Use ref() for model references
   - Use source() for source references
   - Avoid hard-coded values
   - Document assumptions

### Phase 3: Implementation

Test file naming convention:
tests/assert_description_of_test.sql

Test file structure:
1. Header comment explaining the test
2. Configuration block if needed
3. SQL query returning failing records

Standard test template elements:

Header comment must include:
- Test description explaining what is validated
- Business context explaining why it matters
- Expected result (zero rows for passing)
- Related models and dependencies
- Assumptions and limitations

Query structure should:
- Use CTEs for complex logic
- Include descriptive column names
- Add diagnostic columns for debugging
- Handle nulls explicitly
- Filter to only failing records

### Phase 4: Test Configuration

Optional config block settings:

severity: error or warn
- error: stops pipeline on failure (default)
- warn: continues pipeline but logs warning

enabled: true or false
- Control when test executes
- Useful for conditional testing

tags:
- Add tags for selective test execution
- Enable test grouping and filtering

store_failures: true or false
- Persist failing records for analysis
- Useful for debugging and monitoring

limit: number
- Limit number of failing records returned
- Prevent overwhelming output

### Phase 5: Documentation Standards

Test header documentation format:

Section 1: Purpose
- One-line description of what this test validates

Section 2: Business Context
- Why this validation matters
- Impact of test failures
- Who should be alerted

Section 3: Failure Conditions
- What constitutes a failure
- Examples of passing and failing scenarios
- Known exceptions

Section 4: Dependencies
- Models referenced using ref()
- Sources referenced using source()
- Variables used

Section 5: Performance Notes
- Expected runtime
- Table scan considerations
- Indexing requirements

### Phase 6: Testing Patterns

Pattern 1: Simple Violation Check
Purpose: Find records violating a single rule
Structure: Single query with WHERE clause
Example: Find customers with invalid email format

Pattern 2: Cross-Reference Validation
Purpose: Find inconsistencies between models
Structure: JOIN between models with mismatch check
Example: Find orders without valid customer references

Pattern 3: Aggregation Validation
Purpose: Verify aggregated values
Structure: Compare aggregated counts with expected
Example: Verify daily order count equals sum of hourly

Pattern 4: Temporal Validation
Purpose: Find time-based anomalies
Structure: Window functions for sequence analysis
Example: Find gaps in daily reporting

Pattern 5: Conditional Logic
Purpose: Validate rules with multiple conditions
Structure: CASE statements for complex logic
Example: Validate discount rules based on customer tier

## Performance Guidelines

Query optimization rules:
1. Filter early with WHERE clauses
2. Use appropriate indexes
3. Limit joins to necessary tables
4. Avoid SELECT *
5. Use EXISTS instead of IN where possible
6. Consider incremental validation for large tables

Resource management:
1. Set appropriate severity levels
2. Use store_failures selectively
3. Add limits for development
4. Schedule heavy tests appropriately
5. Monitor test execution times

## Error Handling

Handle edge cases:
- Null values in comparison columns
- Empty tables or sources
- Missing reference data
- Division by zero in calculations
- Date boundary conditions

Provide clear error messages:
- Include identifying keys of failing records
- Add calculated values showing violations
- Provide expected vs actual comparisons
- Include timestamps for temporal issues

## Validation Checklist

Before finalizing test, verify:
- Test description clearly states purpose
- Business context is documented
- Query returns zero rows in expected passing state
- Query returns records for known failure scenarios
- Performance is acceptable for data volume
- Edge cases are handled
- Null values are considered
- Severity level is appropriate
- Tags are applied for grouping
- Dependencies are correctly referenced
- Test file follows naming convention
- Documentation includes examples
- Assumptions are clearly stated

## dbt Fusion Considerations

Test execution context:
- Tests can reference models across projects
- Consider access controls for cross-project tests
- Model versions may affect test scope

Performance features:
- Use newer adapter features for optimization
- Consider parallel test execution
- Leverage incremental testing where available

Monitoring integration:
- Log test results for trend analysis
- Set up alerts for critical test failures
- Track test execution history