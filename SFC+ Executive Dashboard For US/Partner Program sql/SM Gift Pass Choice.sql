SELECT							
	'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)- INTERVAL '1 DAY','MM/DD/YYYY') AS Description						
	,TO_CHAR(SUM(CAST(amount AS NUMERIC)),'FM999,999,999') AS amount						
	,TO_CHAR(COUNT(*),'FM999,999,999') as count					
FROM SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_payments" p						
	INNER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_clients" c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_accounts" a ON p.account_id = a.id						
WHERE							
	p.status = 'APPROVED'						
	AND c.name = 'SM Gift Pass Choice'						
	-- AND CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE) < DATE_TRUNC('WEEK', CURRENT_TIMESTAMP )
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', p.initiated_at) AS DATE) < CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
							
UNION ALL							
							
SELECT												
	TO_CHAR(CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE), 'MM/DD/YYYY')  Description						
	,TO_CHAR(SUM(CAST(amount AS NUMERIC)),'FM999,999,999') AS amount						
	,TO_CHAR(COUNT(*),'FM999,999,999') as count						
FROM SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_payments" p						
	INNER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_clients" c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_accounts" a ON p.account_id = a.id						
WHERE							
	p.status = 'APPROVED'					
	AND c.name = 'SM Gift Pass Choice'						
	AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', p.initiated_at) AS DATE) > CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', p.initiated_at) AS DATE) != CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)

GROUP BY							
	CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE)						

UNION ALL

-- Total points as of current week
SELECT
   'Total' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)),'FM999,999,999') AS amount						
	,TO_CHAR(COUNT(*),'FM999,999,999') as count
FROM SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_payments" p						
	INNER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_clients" c ON c.id = p.client_id						
	LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_accounts" a ON p.account_id = a.id
WHERE        
    p.status || '-' || c.name = 'APPROVED-SM Gift Pass Choice'
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', p.initiated_at) AS DATE) != CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)
ORDER BY		
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END,
    Description asc;

-- SELECT DISTINCT TO_CHAR(DATE(convert_timezone('America/Los_Angeles', p.initiated_at)), 'MM/DD/YYYY') FROM SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_payments" p	