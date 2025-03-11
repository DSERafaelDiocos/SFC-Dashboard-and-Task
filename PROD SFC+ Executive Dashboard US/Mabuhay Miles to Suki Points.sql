select											
	'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)- INTERVAL '1 DAY','MM/DD/YYYY') Description					
	,To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points,					
	TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles					
						
from SFC_ISDA.SFC_BRONZE.SFC_RWDS_TRANSACTIONS t 
    inner join SFC_ISDA.SFC_BRONZE.SFC_RWDS_ACCOUNTS  a on t.account_id = a.id		
where
    t.type = 'CONVERT_CREDIT' -- redemption						
    and t.code = 'APPROVAL'	
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) <= CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
	AND a.CURRENCY = 'USD'		
UNION ALL						
						
select											
	TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp") AS DATE),'MM/DD/YYYY') Description,
    -- CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp") AS DATE) AS Description,
    To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points,					
	TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles				
FROM SFC_ISDA.SFC_BRONZE.SFC_RWDS_TRANSACTIONS t
    INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_RWDS_ACCOUNTS  a ON t.account_id = a.id
WHERE	
    t.type = 'CONVERT_CREDIT' -- redemption	
    AND t.code = 'APPROVAL'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) > CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
    AND a.CURRENCY = 'USD'		
GROUP BY						
	CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE)


UNION ALL

-- Total points as of current week
SELECT
   'Total' AS Description,
    To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points,					
	TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles
FROM SFC_ISDA.SFC_BRONZE.SFC_RWDS_TRANSACTIONS t        
    INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_RWDS_ACCOUNTS  a ON a.id = t.account_id
WHERE        
    t.type || '-' || t.code = 'CONVERT_CREDIT-APPROVAL'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'
    AND a.CURRENCY = 'USD'		
ORDER BY 
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END, Description ASC;