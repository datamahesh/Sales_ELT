{{
    config(
            materialized='table'
    )
}}
select * from {{source("Data_Engineering","CRM_SALES_DETAILS")}}

