{{
    config(
            materialized='table'
    )
}}
select * from {{source("Data_Engineering","ERP_PX_CAT_G1V2")}}
