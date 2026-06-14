---
name: dbt-execution
description: Execute dbt commands and manage dbt project runtime operations
---

# dbt Execution Skill

## Objective
Execute dbt commands, manage project runtime, and handle execution workflows.

## Core Commands

### dbt run
Execute models in order of dependencies
- Run all: dbt run
- Run specific: dbt run --select model_name
- Run with tags: dbt run --select tag:tag_name

### dbt test
Execute data quality tests
- Run all: dbt test
- Run specific: dbt test --select model_name
- Store failures: dbt test --store-failures

### dbt build
Run models and tests together
- Full build: dbt build
- Selective: dbt build --select +model_name

### dbt compile
Validate SQL without executing
- Compile all: dbt compile
- Check syntax: dbt compile --select model_name

## Model Selection Syntax

### Tag-Based Selection
- tag:tag_name: select models with specific tag
- tag:tag_name+: select models with tag and their children (downstream)
- +tag:tag_name: select models with tag and their parents (upstream)
- +tag:tag_name+: select models with tag and all parents and children

### Graph Operators
- model_name+: select model and all children (downstream)
- +model_name: select model and all parents (upstream)
- +model_name+: select model and all parents and children
- @model_name: select model and all same-level models
- model_1 model_2: select multiple specific models

### Combining Selectors
- tag:nightly,tag:hourly: models with either tag
- tag:nightly tag:hourly: intersection of both tags
- +tag:daily,stg_salesforce: union of selections
- path:models/marts: models in specific directory

## Execution Flags
- --full-refresh: rebuild incremental models completely
- --fail-fast: stop on first error
- --threads: number of parallel threads
- --target: environment target (dev, prod)
- --vars: pass variables as JSON
- --exclude: exclude specific models from run

## Common Workflows

### Development Flow
1. dbt compile (check syntax)
2. dbt run --select model_name (test model)
3. dbt test --select model_name (validate)
4. Commit when passing

### Full Refresh
Use when: schema changes, data issues, historical reload needed
Command: dbt run --full-refresh --select model_name

### Incremental Run
Use for: daily updates, large tables
Command: dbt run --select tag:daily

### Downstream Impact Run
Use when: model changed and need to refresh dependents
Command: dbt run --select model_name+

### Upstream Dependency Run
Use when: need to ensure all sources are fresh
Command: dbt run --select +model_name

### Full Lineage Run
Use when: complete refresh from source to mart
Command: dbt run --select +model_name+

### Debug Flow
1. dbt debug (check connections)
2. dbt compile (syntax validation)
3. dbt run --fail-fast (stop on errors)
4. Review error logs in logs/dbt.log

## Project Management

### Dependencies
- dbt deps: install packages from packages.yml
- Update packages.yml for new dependencies
- Common: dbt_utils, dbt_expectations, dbt_date

### Documentation
- dbt docs generate: create documentation
- dbt docs serve: view locally
- Update descriptions in schema.yml

### Clean Up
- dbt clean: remove artifacts
- Remove logs, target directories
- Run before fresh builds

## Environment Management

### Profiles
- Located in ~/.dbt/profiles.yml
- Contains connection details per target
- Switch targets: dbt run --target prod

### Variables
- Define in dbt_project.yml or command line
- Access with {{ var('name') }}
- Override: dbt run --vars '{"key":"value"}'

## Troubleshooting

### Common Issues
- Connection errors: run dbt debug first
- Model failures: check logs/dbt.log
- Test failures: use --store-failures for analysis
- Performance: increase threads, optimize models

### Log Analysis
- Check logs/dbt.log for detailed errors
- Look for compiled SQL in target/ directory
- Review run_results.json for execution summary

## Best Practices
- Always compile before running full project
- Test models after changes before committing
- Use --select to limit scope during development
- Full refresh only when necessary
- Store test failures for debugging
- Monitor run time for performance degradation
- Use +tag: and tag:+ to manage dependency chains
- Exclude heavy models during development with --exclude