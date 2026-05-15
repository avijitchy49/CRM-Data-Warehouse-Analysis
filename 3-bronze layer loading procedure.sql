/*
===============================================================================
Load Bronze Layer (Source -> Bronze) with Stored Procedure
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.
	- Put this process in a procedure named 'bronze.load_bronze'
	- Used TRY and CATCH statement to decode error
	- Declared and set start time, end time and batch start time, batch end time to calculate 
	  total loading duration and per table loading duration to optimize the query

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT 'LOADING THE BRONZE LAYER';
		PRINT 'LOADING CRM TABLES';

		SET @start_time = GETDATE();
		PRINT '>> Truncating and Inserting data into bronze.crm_customer_info';
		TRUNCATE TABLE bronze.crm_customer_info;
		BULK INSERT bronze.crm_customer_info
		FROM 'G:\Data Analytics Projects\CRM Data Warehouse Analysis\source_crm\customer_info.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' SECONDS ';
		PRINT '>> ===========================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating and Inserting data into bronze.crm_product_info';
		TRUNCATE TABLE bronze.crm_product_info;
		BULK INSERT bronze.crm_product_info
		FROM 'G:\Data Analytics Projects\CRM Data Warehouse Analysis\source_crm\product_info.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' SECONDS ';
		PRINT '>> ===========================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating and Inserting data into bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;
		BULK INSERT bronze.crm_sales_details
		FROM 'G:\Data Analytics Projects\CRM Data Warehouse Analysis\source_crm\sales_details.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' SECONDS ';
		PRINT '>> ===========================================================';

		PRINT 'LOADING THE ERP TABLES';

		SET @start_time = GETDATE();
		PRINT '>> Truncating and Inserting data into bronze.erp_location_info';
		TRUNCATE TABLE bronze.erp_location_info;
		BULK INSERT bronze.erp_location_info
		FROM 'G:\Data Analytics Projects\CRM Data Warehouse Analysis\source_erp\location_info.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' SECONDS ';
		PRINT '>> ===========================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating and Inserting data into bronze.erp_customer_details';
		TRUNCATE TABLE bronze.erp_customer_details;
		BULK INSERT bronze.erp_customer_details
		FROM 'G:\Data Analytics Projects\CRM Data Warehouse Analysis\source_erp\customer_details.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
				SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' SECONDS ';
		PRINT '>> ===========================================================';

		SET @start_time = GETDATE();
		PRINT '>> Truncating and Inserting data into bronze.erp_product_catagory';
		TRUNCATE TABLE bronze.erp_product_catagory;
		BULK INSERT bronze.erp_product_catagory
		FROM 'G:\Data Analytics Projects\CRM Data Warehouse Analysis\source_erp\product_catagory.CSV'
		WITH(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' SECONDS ';
		PRINT '>> ===========================================================';
		
		SET @batch_end_time = GETDATE();
		PRINT '>> TOTAL BULK DATA LOAD DURATION : ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' SECONDS ';
		PRINT '>> ===========================================================';

	END TRY
	BEGIN CATCH
		PRINT '>> ERROR OCCERED DURING BRONZE LAYER LOADING';
		PRINT '>> ERROR MESSAGE' + ERROR_MESSAGE();
		PRINT '>> ERROR MESSAGE' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT '>> ERROR MESSAGE' + CAST(ERROR_STATE() AS NVARCHAR);
	END CATCH
END