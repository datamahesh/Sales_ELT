with Gold_Dim_Products as(
    SELECT
    ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key, -- Surrogate key
    pn."prd_id"       AS product_id,
    pn.prd_key      AS product_number,
    pn."prd_nm"       AS product_name,
    pn.cat_id       AS category_id,
    pc.cat          AS category,
    pc.subcat       AS subcategory,
    pc.maintenance  AS maintenance,
    pn.prd_cost     AS cost,
    pn.prd_line     AS product_line,
    pn.prd_start_dt AS start_date
FROM  {{ref('Silver_CRM_PRD_INFO')}} pn
LEFT JOIN {{ref('Silver_ERP_PX_CAT_G1V2')}} pc
    ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL -- Filter out all historical data
)
select * from Gold_Dim_Products
