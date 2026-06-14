---
name: dbt-testing
description: Implement dbt testing strategies for data quality validation
---

# dbt Testing Skill

## Objective
Implement comprehensive data quality testing using dbt schema tests, singular tests, and custom validations.

## Test Types

### Schema Tests (Generic)
Built-in, configured in schema.yml
- not_null: column must not contain nulls
- unique: column values must be unique
- accepted_values: column must contain listed values
- relationships: foreign key must exist in referenced table

### Singular Tests (Custom)
SQL queries in tests/ directory
- Complex business rules
- Multi-table validations
- Temporal checks
- Conditional logic

### Custom Generic Tests
Reusable test macros
- Created as macros with test_ prefix
- Parameterized for flexibility
- Used like built-in tests

## Test Configuration

### Schema Test Configuration
Place in schema.yml under model columns:
- Test name with optional parameters
- Severity: error (default) or warn
- Tags for grouping
- Custom error messages

### Test Severity Levels
- error: fails build, blocks deployment (default)
- warn: logs warning, continues execution
- Use warn for informational validations
- Use error for critical data quality

### Test Tags
- Group related tests: data_quality, business_rules
- Enable selective execution: dbt test --select tag:critical
- Organization: source_freshness, referential_integrity

## Test Coverage Strategy

### Minimum Required Tests
Every model must have:
- Primary key unique test
- Not null on required fields
- Relationships on foreign keys

### Recommended Tests
Add based on data characteristics:
- accepted_values on categorical columns
- Range validations on numeric columns
- Date validations on temporal columns
- Pattern matching on formatted strings

### Advanced Testing
Complex validations:
- Cross-model consistency checks
- Historical trend analysis
- Statistical anomaly detection
- Business rule compliance

## Custom Test Creation

### Generic Test Macro Structure
1. Define with test_ prefix
2. Accept model and column_name parameters
3. Return failing records
4. Include in schema.yml like built-in tests

### Singular Test Structure
1. Place in tests/ directory
2. Write SQL returning violations
3. Add descriptive header comment
4. Use ref() and source() for references

## Testing Workflow

### Development Testing
- Test individual models during development
- Use --select for targeted testing
- Quick feedback loop

### Pre-Commit Testing
- Test all changed models
- Include downstream dependencies
- Verify no regressions

### CI/CD Testing
- Run full test suite
- Block deployment on failures
- Store results for trending

### Production Monitoring
- Schedule critical tests
- Alert on failures
- Track data quality trends

## Test Performance Optimization

### Efficiency Guidelines
- Limit store_failures for large datasets
- Use where clauses to reduce scan
- Index commonly tested columns
- Schedule heavy tests separately

### Resource Management
- Set appropriate thread count
- Use --fail-fast during development
- Limit test scope with tags
- Monitor test execution times

## Troubleshooting Failures

### Common Issues
- Source data changes causing test failures
- Schema changes breaking tests
- Timing issues with incremental loads
- Data volume affecting performance

### Resolution Steps
1. Use --store-failures to capture violations
2. Analyze failure patterns
3. Update tests or fix data
4. Document known exceptions

## dbt Fusion Testing Features

### Contract Testing
- Enforce column types and constraints
- Validate model contracts
- Catch schema drifts early

### Version Testing
- Test across model versions
- Validate backward compatibility
- Ensure migration safety

## Validation Checklist
- All models have minimum required tests
- Test severity levels are appropriate
- Custom tests documented with business context
- Performance impact assessed
- CI/CD pipeline includes testing
- Failure handling procedures defined
- Test coverage documented