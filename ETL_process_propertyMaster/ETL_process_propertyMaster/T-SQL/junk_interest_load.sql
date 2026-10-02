use PropertymasterDW

INSERT INTO [dbo].[Junk_Interest] 
SELECT s
FROM 
	  (
		VALUES 
			  ('viewing')
			  , ('negotiating price')
			  , ('contract signing')
			  , ('payment')
			  , ('withdrawn')
	  ) 
	AS Status(s);
	