{{
    config(
            materialized='table'
    )
}}

    
select * from {{source("Data_Engineering","CRM_CUSTOMER_INFO")}}
