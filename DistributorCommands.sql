-- Check whether this server has been configured as distributor
sp_get_distributor

-- Install the Distributor and the distribution database.
DECLARE @distributor AS sysname;
DECLARE @distributionDB AS sysname;
DECLARE @publisher AS sysname;
DECLARE @directory AS nvarchar(500);
DECLARE @publicationDB AS sysname;
-- Specify the Distributor name.
SET @distributor = N'Distributor';
-- Specify the distribution database.
SET @distributionDB = N'distribution';
-- Specify the Publisher name.
SET @publisher = N'Publisher';
-- Specify the replication working directory.
SET @directory = N'\\' + 'DISTRIBUTOR' + '\Snapshot folder';
-- Specify the publication database.
SET @publicationDB = N'AdventureWorks2019';


-- Install this remote server  as a remote Distributor.
-- we should specify here password in the case of remote distributor.
USE master
EXEC sp_adddistributor
@distributor = @distributor,
@password = 'MyDistributorPassword$$'

-- Create a new distribution database using the defaults, including
-- using Windows Authentication.
USE master
EXEC sp_adddistributiondb @database = @distributionDB, 
    @security_mode = 1;
GO

--At the Distributor, execute sp_adddistpublisher (Transact-SQL), specifying the UNC share 
--that will be used as default snapshot folder for @working_directory. 
--If the Distributor will use SQL Server Authentication when connecting to the Publisher, 
--you must also specify a value of 0 for @security_mode and the Microsoft SQL Server login 
--information for @login and @password.
USE [distribution]
EXEC sp_adddistpublisher @publisher='Publisher', 
    @distribution_db='distribution', 
    @security_mode = 1,
	@password = 'MyPublisherPassword$$',
	@working_directory = '\\DISTRIBUTOR\Snapshot folder'
GO

---------------------------------------------------------------------------------------------------
-- Removing replication

-- Remove the registration of the local Publisher at the Distributor.
USE master
EXEC sp_dropdistpublisher 'Publisher';

-- Delete the distribution database.
EXEC sp_dropdistributiondb 'distribution';

-- Remove the local server as a Distributor.
EXEC sp_dropdistributor;
GO