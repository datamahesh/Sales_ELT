# Data Pipeline with AWS, Snowpipe, and Snowflake (Medallion Architecture),dbt cloud

## Project Objective:
The objective of this project is to build a scalable and efficient data pipeline that ingests raw data from CRM and ERP systems, stores it in AWS S3, and processes it through a Snowflake data warehouse using a medallion architecture (Bronze, Silver, Gold layers). The pipeline automates data ingestion, transformation, and storage to enable analytics and reporting for business insights.

## Source Systems: 
CRM and ERP Data.

## Storage: AWS S3 for raw data storage.
### Ingestion: Snowpipe for automated data loading into Snowflake.
### Data Warehouse: Snowflake with a medallion architecture (Bronze, Silver, Gold layers).
### Transformation: Use dbt (data build tool) for transforming data between layers.

## Architecture Overview
The architecture diagram illustrates the flow of data through the pipeline:

Source Systems: Data is generated from CRM and ERP systems.
AWS S3: Raw data is stored in an S3 bucket.
Snowpipe: Automatically ingests data from S3 into Snowflake.
Snowflake Data Warehouse:
Bronze Layer: Raw, unprocessed data as ingested.
Silver Layer: Cleaned and transformed data using dbt.
Gold Layer: Aggregated, business-ready data for analytics using dbt.

## Implementation Steps
### Prerequisites
An AWS account with S3 access.
A Snowflake account with Snowpipe enabled.
dbt (data build tool) installed and configured.
Access to CRM and ERP systems for data extraction.
Basic knowledge of SQL, AWS, Snowflake, and dbt.

### Step 1: Set Up AWS S3

Create an S3 bucket to store raw data from CRM and ERP systems.
Configure IAM roles and policies to allow Snowflake to access the S3 bucket.
Set up an S3 event notification (e.g., using SNS or SQS) to trigger Snowpipe when new data is uploaded.

### Step 2: Configure Snowpipe

In Snowflake, create a pipe to automatically ingest data from the S3 bucket into the Bronze layer.
Define the file format (e.g., CSV, JSON) for the incoming data.
Set up an external stage in Snowflake pointing to the S3 bucket.
Test the Snowpipe ingestion by uploading sample data to S3 and verifying it lands in the Bronze layer.

### Step 3: Set Up Snowflake Medallion Architecture

#### Bronze Layer:

Create a schema in Snowflake for the Bronze layer.
Create a table to store raw data ingested via Snowpipe.
Ensure the table structure matches the incoming data format.

#### Silver Layer:

Create a schema for the Silver layer.
Use dbt to define models that clean and transform the Bronze data (e.g., handle missing values, standardize formats).
Run dbt run to populate the Silver layer.

#### Gold Layer:

Create a schema for the Gold layer.
Use dbt to define models that aggregate and enrich the Silver data for business use cases (e.g., sales reports, customer insights).
Run dbt run to populate the Gold layer.

### Step 4: Automate Data Transformation with dbt

Set up a dbt project in your repository.
Define dbt models for the Silver and Gold layers in the models/ directory.
Example: models/silver/cleaned_customers.sql for cleaning Bronze data.
Example: models/gold/customer_sales_report.sql for aggregating Silver data.
Configure dbt to connect to Snowflake using a profiles.yml file.
Schedule dbt runs using a scheduler (e.g., dbt Cloud, Airflow) to automate transformations.

### Step 5: Test and Validate

Upload sample data from CRM and ERP to S3.
Verify that Snowpipe ingests the data into the Bronze layer.
Run dbt to transform data into the Silver and Gold layers.
Query the Gold layer to ensure the data is accurate and ready for analytics.

### Step 6: Monitor and Optimize

Monitor Snowpipe for ingestion errors using Snowflake’s pipe status.
Use Snowflake’s query history to optimize dbt transformations.
Set up alerts for pipeline failures (e.g., using AWS CloudWatch or Snowflake notifications).


### data-pipeline-project/
├── dbt_project.yml         # dbt project configuration
├── models/                 # dbt models for Silver and Gold layers
│   ├── bronze/             # Bronze layer schemas (optional)
│   ├── silver/             # Silver layer transformations
│   └── gold/               # Gold layer aggregations
├── scripts/                # Scripts for Snowpipe setup and S3 uploads
├── profiles.yml            # dbt connection profile for Snowflake
└── README.md               # This file

## Final Conclusion
This project successfully implemented a data pipeline using AWS S3, Snowpipe, and Snowflake with a medallion architecture. The pipeline automates the ingestion of raw data from CRM and ERP systems, processes it through Bronze, Silver, and Gold layers, and prepares it for analytics. Key outcomes include:

Scalability: The pipeline can handle large volumes of data using Snowpipe and Snowflake’s cloud-native architecture.
Automation: Snowpipe and dbt automate data ingestion and transformation, reducing manual effort.
Data Quality: The medallion architecture ensures data is progressively cleaned and enriched for business use.
Flexibility: The setup can be extended to include additional data sources or analytics tools.
Future improvements could include integrating a visualization tool (e.g., Tableau, Power BI) to create dashboards from the Gold layer, or adding more advanced data quality checks in the Silver layer.
