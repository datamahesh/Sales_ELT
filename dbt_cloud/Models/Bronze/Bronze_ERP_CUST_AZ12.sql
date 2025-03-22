{{
    config(
            materialized='table'
    )
}}
select * from {{source("Data_Engineering","ERP_CUST_AZ12")}}


