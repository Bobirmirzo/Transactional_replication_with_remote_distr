-- Install this remote server  as a remote Distributor.
-- we should specify here password in the case of remote distributor.
USE master
EXEC sp_adddistributor
@distributor = 'distributor',
@password = 'MyDistributorPassword$$'


-- If yo uwanbt to remove, run the below.
-- Disable the publication database.
USE [AdventureWorks2019]
EXEC sp_removedbreplication 'AdventureWorks2019'
GO
-- Remove the local server at the distributor
EXEC sp_dropdistributor;
GO