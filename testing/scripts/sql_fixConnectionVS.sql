USE [master];
CREATE LOGIN [NT SERVICE\MSSQLServerOLAPService] FROM WINDOWS;

USE [PropertymasterDW];
CREATE USER [NT SERVICE\MSSQLServerOLAPService] FOR LOGIN [NT SERVICE\MSSQLServerOLAPService];
EXEC sp_addrolemember N'db_datareader', N'NT SERVICE\MSSQLServerOLAPService';
