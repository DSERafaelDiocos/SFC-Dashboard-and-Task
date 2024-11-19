SELECT							
	0 SortOrder						
	,'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_DATE)- INTERVAL '1 DAY','MM/DD/YYYY') AS Description						
	,SUM(CAST(amount AS NUMERIC)) amount						
	,COUNT(*) count						
FROM SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_payments" p						
	INNER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_clients" c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_accounts" a ON p.account_id = a.id						
WHERE							
	p.status = 'APPROVED'						
	AND c.name = 'Seafood City POS'						
	AND CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE) < DATE_TRUNC('WEEK', CURRENT_DATE)		
							
UNION ALL							
							
SELECT							
	1 SortOrder						
	,TO_CHAR(CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE), 'MM/DD/YYYY')  Description						
	,SUM(CAST(amount AS NUMERIC)) amount						
	,COUNT(*) count						
FROM SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_payments" p						
	INNER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_clients" c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_accounts" a ON p.account_id = a.id						
WHERE							
	p.status = 'APPROVED'						
	AND c.name = 'Seafood City POS'						
	AND CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE) >= DATE_TRUNC('WEEK', CURRENT_DATE)
    AND TO_CHAR(CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE), 'MM/DD/YYYY') = :PPF
GROUP BY							
	CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE)						
ORDER BY							
	SortOrder,
    Description asc;