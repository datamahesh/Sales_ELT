{{
    config(
            materialized='table'
    )
}}
select * from {{source("Data_Engineering","ERP_LOC_A101")}}
