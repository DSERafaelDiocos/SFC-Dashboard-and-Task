SELECT							
	'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)- INTERVAL '1 DAY','MM/DD/YYYY') AS Description						
	,TO_CHAR(IFNULL(SUM(CAST(amount AS NUMERIC)),0),'FM999,999,999.00') AS amount						
	,TO_CHAR(COUNT(*),'FM999,999,999') as count					
FROM SFC_ISDA.SFC_BRONZE.SFC_PLUS_PAYMENTS p						
	INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_CLIENTS c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS a ON p.account_id = a.id
WHERE							
	p.status = 'APPROVED'						
	AND c.name = 'SM Gift Pass Choice Canada'		
    AND p.CURRENCY = 'CAD'
	AND CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE) < DATE_TRUNC('WEEK', CURRENT_TIMESTAMP )
    AND PARSE_JSON(p.particulars, 's')['items'][0]['item_name']::STRING LIKE '%5,000.00%'
    
UNION ALL							
							
SELECT												
	TO_CHAR(CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE), 'MM/DD/YYYY')  Description						
	,TO_CHAR(IFNULL(SUM(CAST(amount AS NUMERIC)),0),'FM999,999,999.00') AS amount										
	,TO_CHAR(COUNT(*),'FM999,999,999') as count						
FROM SFC_ISDA.SFC_BRONZE.SFC_PLUS_PAYMENTS p						
	INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_CLIENTS c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS a ON p.account_id = a.id	
WHERE							
	p.status = 'APPROVED'					
	AND c.name = 'SM Gift Pass Choice Canada'			
    AND p.CURRENCY = 'CAD'
	AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', p.initiated_at) AS DATE) > CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
    AND PARSE_JSON(p.particulars, 's')['items'][0]['item_name']::STRING LIKE '%5,000.00%'
    
GROUP BY							
	CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE)						

UNION ALL

-- Total points as of current week
SELECT
   'Total' AS Description
    ,TO_CHAR(IFNULL(SUM(CAST(amount AS NUMERIC)),0),'FM999,999,999.00') AS amount						
	,TO_CHAR(COUNT(*),'FM999,999,999') as count
FROM SFC_ISDA.SFC_BRONZE.SFC_PLUS_PAYMENTS p						
	INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_CLIENTS c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS a ON p.account_id = a.id
WHERE        
    p.status || '-' || c.name = 'APPROVED-SM Gift Pass Choice Canada'
    AND p.CURRENCY = 'CAD'
    AND PARSE_JSON(p.particulars, 's')['items'][0]['item_name']::STRING LIKE '%5,000.00%'
ORDER BY		
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END,
    Description asc;