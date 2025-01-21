SELECT							
	CONCAT(IFNULL(a.FIRST_NAME, ''), ' ', IFNULL(a.MIDDLE_NAME, ''), ' ', IFNULL(a.LAST_NAME, '')) AS FULL_NAME,
    a.EMAIL_ADDRESS,
    a.MOBILE_NUMBER,
    p.amount,
    p.currency,
    CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', p.INITIATED_AT::TIMESTAMP_NTZ) AS DATE
FROM SFC_ISDA.SFC_BRONZE.SFC_PLUS_PAYMENTS p						
	INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_CLIENTS c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS a ON p.account_id = a.id		
WHERE							
	p.status = 'APPROVED'						
	AND c.name = 'Gawad Kalinga'	
    AND p.CURRENCY = 'USD'
    AND CAST(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', p.INITIATED_AT::TIMESTAMP_NTZ) AS DATE) = :daterange
ORDER BY 
    CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', p.INITIATED_AT::TIMESTAMP_NTZ)
    