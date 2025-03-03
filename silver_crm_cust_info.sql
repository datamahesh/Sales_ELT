with silver_crm_cust_info as (
    select * from {{ ref('CRM_CUSTOMER_INFO') }}
)
select 
    * 
    from 
silver_crm_cust_info
