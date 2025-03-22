with Silver_ERP_CUST_AZ12 as (
    select        
            CASE 
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid)) 
                ELSE cid  -- Ensure there's an ELSE condition
            END as cid,
			CASE
				WHEN bdate > GETDATE() THEN NULL
				ELSE bdate
			END AS bdate, -- Set future birthdates to NULL
			CASE
				WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
				WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
				ELSE 'n/a'
			END AS gen -- Normalize gender values and handle unknown cases
		FROM {{ref("Bronze_ERP_CUST_AZ12")}}
)
select * from Silver_ERP_CUST_AZ12
