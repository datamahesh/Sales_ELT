WITH Gold_Dim_Customers AS (
    SELECT
        ROW_NUMBER() OVER (ORDER BY "cst_id") AS customer_key, -- Surrogate key
        ci."cst_id"                         AS customer_id,
        ci."cst_key"                         AS customer_number,
        ci.cst_firstname                     AS first_name,
        ci.cst_lastname                      AS last_name,
        la.cntry                             AS country, -- Fixed typo
        ci.cst_marital_status                AS marital_status,
        CASE 
            WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the primary source for gender
            ELSE COALESCE(ca.gen, 'n/a')  			   -- Fallback to ERP data
        END                                  AS gender,
        ca.bdate                             AS birthdate,
        ci."cst_create_date"                   AS create_date
    FROM {{ref('Silver_CRM_CUST_INFO')}} ci
    LEFT JOIN {{ref('Silver_ERP_CUST_AZ12')}} ca
        ON ci."cst_key" = ca.cid
    LEFT JOIN {{ref('Silver_ERP_LOC_A101')}} la
        ON ci."cst_key" = la.cid
)
SELECT * FROM Gold_Dim_Customers
