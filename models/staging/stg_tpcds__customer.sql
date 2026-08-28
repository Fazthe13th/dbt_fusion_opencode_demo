{{ config(description='Staging model for TPCDS customer table', materialized='view', tags=['staging', 'tpcds']) }}

with source as (
  select * from {{ source('tpcds', 'customer') }}
),

renamed as (
  select
    custkey as customer_id,
    name as customer_name,
    address as customer_address,
    phone as customer_phone,
    comments as customer_comments,
    current_timestamp() as dbt_updated_at
  from source
)
