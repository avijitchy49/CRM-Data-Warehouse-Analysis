-- CHECKING bronze.crm_customer_info TABLE FOR DATA CLEANING

SELECT * FROM bronze.crm_customer_info;

-------------------------------------------------------------
-- CHECKING NULL OR DUPLICATES IN PRIMARY KEY
SELECT cst_id, COUNT(*) 
FROM bronze.crm_customer_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT *
FROM bronze.crm_customer_info
WHERE crm_customer_info.cst_id = 29466;

SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_customer_info
WHERE crm_customer_info.cst_id = 29466;

SELECT *
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_customer_info
) t 
WHERE flag_last != 1;

-- REMOVING NULL AND DUPLICATES IN PRIMARY KEY
SELECT *
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
FROM bronze.crm_customer_info
) t 
WHERE flag_last = 1 AND cst_id IS NOT NULL;

-------------------------------------------------------------------------------
-- CHECKING UNWANTED SPACES
-- CHECKING UNWANTED SPACES IN cst_key
SELECT cst_key
FROM bronze.crm_customer_info
WHERE cst_key != TRIM(cst_key);

-- REMOVING UNWANRED SPACE FROM cst_firstname
SELECT TRIM(cst_key) AS cst_key
FROM bronze.crm_customer_info;

-----------------------------------------------------------------------
-- CHECKING UNWANTED SPACES IN cst_firstname
SELECT cst_firstname
FROM bronze.crm_customer_info
WHERE cst_firstname != TRIM(cst_firstname);

-- REMOVING UNWANRED SPACE FROM cst_firstname
SELECT TRIM(cst_firstname) AS cst_firstname
FROM bronze.crm_customer_info;

-----------------------------------------------------------------------------------
SELECT cst_lastname
FROM bronze.crm_customer_info
WHERE cst_lastname != TRIM(cst_lastname);

-- REMOVING UNWANRED SPACE FROM cst_lastname
SELECT TRIM(cst_lastname) AS cst_lastname
FROM bronze.crm_customer_info;

------------------------------------------------------------------------------------------
SELECT cst_gndr
FROM bronze.crm_customer_info
WHERE cst_gndr != TRIM(cst_gndr);

------------------------------------------------------------------------
-- PERFORMING DATA STANDARDIZATION AND CONSISTENCY
-- CHECKING DISTINCT VALUES OF cst_gndr
SELECT DISTINCT cst_gndr
FROM bronze.crm_customer_info;

-- REMOVING NULL VALUES AND STANDARDIZING THE DATA
-- REMOVING UNWANRED SPACE FROM cst_gndr
SELECT 
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
        ELSE 'N/A'
    END AS cst_gndr
FROM bronze.crm_customer_info;

--------------------------------------------------------------------------
-- CHECKING DISTINCT VALUES OF cst_marital_status
SELECT DISTINCT cst_marital_status
FROM bronze.crm_customer_info;

-- REMOVING NULL VALUES AND STANDARDIZING THE DATA
-- REMOVING UNWANRED SPACE FROM cst_marital_status
SELECT 
    CASE 
        WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'N/A'
    END AS cst_marital_status
FROM bronze.crm_customer_info;

--------------------------------------------------------------------------
-- CHECKING cst_create_date
SELECT cst_create_date
FROM bronze.crm_customer_info