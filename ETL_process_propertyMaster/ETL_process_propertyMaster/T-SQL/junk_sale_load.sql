use PropertymasterDW

INSERT INTO [dbo].[Junk_Sale] 
SELECT s, c, a 
FROM 
	  (
		VALUES 
			  ('Pre-sale')
			, ('For Sale')
			, ('Under Offer')
			, ('Sold')
			, ('Cancelled')
	  ) 
	AS Status(s)
	
	, (
		VALUES 
			  ('very poor')
			 , ('poor')
			 , ('acceptable')
			 , ('good')
			 , ('very good')
			 , (NULL)
	  ) 
	AS Condition(c)

	, (
		VALUES
			('Deal')
			, ('No Deal')
			, (NULL)
	)
	AS Agreement(a);