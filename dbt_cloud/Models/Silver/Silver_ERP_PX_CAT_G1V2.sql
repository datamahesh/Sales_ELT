with Silver_ERP_PX_CAT_G1V2 as (
SELECT
			id,
			cat,
			subcat,
			maintenance
		FROM {{ref("Bronze_ERP_PX_CAT_G1V2")}}
)
select * from Silver_ERP_PX_CAT_G1V2
