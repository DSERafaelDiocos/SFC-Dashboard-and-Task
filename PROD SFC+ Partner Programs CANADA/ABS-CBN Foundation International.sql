SELECT							
	'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)- INTERVAL '1 DAY','MM/DD/YYYY') AS Description						
	,TO_CHAR(SUM(CAST(amount AS NUMERIC)),'FM999,999,999.00') AS amount						
	,TO_CHAR(COUNT(*),'FM999,999,999') as count					
FROM SFC_ISDA.SFC_BRONZE.SFC_PLUS_PAYMENTS p						
	INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_CLIENTS c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS a ON p.account_id = a.id		
WHERE							
	p.status = 'APPROVED'						
	AND c.name = 'ABS-CBN Foundation International Canada'	
    AND p.currency = 'CAD'
    -- As of the previous week
	AND CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE) < DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)
							
UNION ALL							

-- Daily breakdown of the current week
SELECT							
	TO_CHAR(CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE), 'MM/DD/YYYY')  Description						
	,TO_CHAR(SUM(CAST(amount AS NUMERIC)),'FM999,999,999.00') AS amount						
	,TO_CHAR(COUNT(*),'FM999,999,999') as count					
FROM SFC_ISDA.SFC_BRONZE.SFC_PLUS_PAYMENTS p						
	INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_CLIENTS c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS a ON p.account_id = a.id
WHERE							
	p.status = 'APPROVED'						
	AND c.name = 'ABS-CBN Foundation International Canada'
    AND p.CURRENCY = 'CAD'
    -- As of the current week
	AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', p.initiated_at) AS DATE) > CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
GROUP BY							
	CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE)						

UNION ALL

-- Total activity 
SELECT
   'Total' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)),'FM999,999,999.00') AS amount						
	,TO_CHAR(COUNT(*),'FM999,999,999') as count
FROM SFC_ISDA.SFC_BRONZE.SFC_PLUS_PAYMENTS p						
	INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_CLIENTS c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS a ON p.account_id = a.id
WHERE        
    p.status || '-' || c.name = 'APPROVED-ABS-CBN Foundation International Canada'
    AND p.CURRENCY = 'CAD'
ORDER BY		
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END,
    Description asc;
    