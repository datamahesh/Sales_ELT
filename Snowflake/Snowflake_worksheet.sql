USE ROLE accountadmin;
USE WAREHOUSE compute_wh;
CREATE OR REPLACE DATABASE PROJECTS;
CREATE OR REPLACE SCHEMA PROJECTS.raw;

--File Formats--

--To load data--
create or replace file format file_format_skip_header
type = 'csv'
compression = 'auto'
field_delimiter = ','
record_delimiter = '\n'
field_optionally_enclosed_by = '\042'
skip_header = 1;

--To create tables--
create or replace file format file_format_parquet_parse_header
type = 'csv'
compression = 'auto'
field_delimiter =','
record_delimiter ='\n'
field_optionally_enclosed_by = '\042'
parse_header = true;

--Storage integration with S3--

CREATE OR REPLACE STORAGE INTEGRATION s3_integrate_obj
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::941377154993:role/Snowflake_aws'
    STORAGE_ALLOWED_LOCATIONS = ('s3://datawarehousesource/source/')
    ENABLED = TRUE
    COMMENT = 'Integration Object for AWS S3 buckets';

DESC STORAGE INTEGRATION  s3_integrate_obj;

--External Stages--

CREATE OR REPLACE STAGE projects.raw.ext_stage_crm
url = 's3://datawarehousesource/source/crm/'
storage_integration = s3_integrate_obj;

CREATE OR REPLACE STAGE projects.raw.ext_stage_erp
url = 's3://datawarehousesource/source/erp/'
storage_integration = s3_integrate_obj;

LIST @projects.raw.ext_stage_crm;
LIST @projects.raw.ext_stage_erp;

--Tables--

--CRM TABLES--
CREATE OR REPLACE TABLE crm_customer_info 
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) 
    FROM TABLE(
        INFER_SCHEMA(
            LOCATION => '@ext_stage_crm/cust_info.csv', 
            FILE_FORMAT => 'file_format_parse_header'
        )
    )
) ;

CREATE OR REPLACE TABLE crm_prd_info 
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) 
    FROM TABLE(
        INFER_SCHEMA(
            LOCATION => '@ext_stage_crm/prd_info.csv', 
            FILE_FORMAT => 'file_format_parse_header'
        )
    )
) ;

CREATE OR REPLACE TABLE crm_sales_details 
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) 
    FROM TABLE(
        INFER_SCHEMA(
            LOCATION => '@ext_stage_crm/sales_details.csv', 
            FILE_FORMAT => 'file_format_parse_header'
        )
    )
) ;

--ERP TABLES--
CREATE OR REPLACE TABLE ERP_CUST_AZ12 
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) 
    FROM TABLE(
        INFER_SCHEMA(
            LOCATION => '@ext_stage_erp/CUST_AZ12.csv', 
            FILE_FORMAT => 'file_format_parse_header'
        )
    )
) ;

CREATE OR REPLACE TABLE ERP_LOC_A101 
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) 
    FROM TABLE(
        INFER_SCHEMA(
            LOCATION => '@ext_stage_erp/LOC_A101.csv', 
            FILE_FORMAT => 'file_format_parse_header'
        )
    )
) ;

CREATE OR REPLACE TABLE ERP_PX_CAT_G1V2
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*)) 
    FROM TABLE(
        INFER_SCHEMA(
            LOCATION => '@ext_stage_erp/PX_CAT_G1V2.csv', 
            FILE_FORMAT => 'file_format_parse_header'
        )
    )
) ;


select * from projects.raw.crm_customer_info;
select * from projects.raw.crm_prd_info;
select * from projects.raw.crm_sales_details;
select * from projects.raw.ERP_CUST_AZ12;
select * from projects.raw.erp_loc_a101;
select * from projects.raw.erp_px_cat_g1v2;


--SnowPipes--

CREATE OR REPLACE PIPE PROJECTS.raw.SNOW_PIPE
    AUTO_INGEST = TRUE
AS
    COPY INTO projects.raw.crm_customer_info
    FROM @ext_stage_crm/cust_info.csv
    FILE_FORMAT = file_format_skip_header;

CREATE OR REPLACE PIPE PROJECTS.raw.SNOW_PIPE2
    AUTO_INGEST = TRUE
AS
    COPY INTO projects.raw.crm_prd_info
    FROM @ext_stage_crm/prd_info.csv
    FILE_FORMAT = file_format_skip_header;

CREATE OR REPLACE PIPE PROJECTS.raw.SNOW_PIPE3
    AUTO_INGEST = TRUE
AS
    COPY INTO projects.raw.crm_sales_details
    FROM @ext_stage_crm/sales_details.csv
    FILE_FORMAT = file_format_skip_header;

CREATE OR REPLACE PIPE PROJECTS.raw.SNOW_PIPE4
    AUTO_INGEST = TRUE
AS
    COPY INTO projects.raw.erp_cust_az12
    FROM @ext_stage_erp/CUST_AZ12.csv
    FILE_FORMAT = file_format_skip_header;

CREATE OR REPLACE PIPE PROJECTS.raw.SNOW_PIPE5
    AUTO_INGEST = TRUE
AS
    COPY INTO projects.raw.erp_loc_a101
    FROM @ext_stage_erp/LOC_A101.csv
    FILE_FORMAT = file_format_skip_header;

CREATE OR REPLACE PIPE PROJECTS.raw.SNOW_PIPE6
    AUTO_INGEST = TRUE
AS
    COPY INTO projects.raw.erp_px_cat_g1v2
    FROM @ext_stage_erp/PX_CAT_G1V2.csv
    FILE_FORMAT = file_format_skip_header;
    
DESC PIPE PROJECTS.BRONZE.SNOW_PIPE;

    
ALTER PIPE PROJECTS.raw.SNOW_PIPE REFRESH;
ALTER PIPE PROJECTS.raw.SNOW_PIPE2 REFRESH;
ALTER PIPE PROJECTS.raw.SNOW_PIPE3 REFRESH;
ALTER PIPE PROJECTS.raw.SNOW_PIPE4 REFRESH;
ALTER PIPE PROJECTS.raw.SNOW_PIPE5 REFRESH;
ALTER PIPE PROJECTS.raw.SNOW_PIPE6 REFRESH;



