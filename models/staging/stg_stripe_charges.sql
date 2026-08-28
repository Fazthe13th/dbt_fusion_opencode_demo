with final as (
    select
        *
    from
        {{ source('stripe', 'charges') }}
)

select * from final