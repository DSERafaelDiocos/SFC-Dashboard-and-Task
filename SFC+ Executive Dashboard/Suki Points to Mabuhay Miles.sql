select						
    'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)- INTERVAL '1 DAY','MM/DD/YYYY') Description					
	,TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles,
    To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points				
											
from "BPAY_SFCRWDS_transactions" t 
    Inner join "BPAY_SFCRWDS_accounts" a on t.account_id = a.id
where t.type = 'CONVERT_DEBIT' 					
    and t.code = 'APPROVAL'						
    -- AND DATE(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")) < DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) < CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
						
UNION ALL						
						
select										
	TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE),'MM/DD/YYYY') Description					
	,TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles,
    To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points	
    
from "BPAY_SFCRWDS_transactions" t 
    Inner join "BPAY_SFCRWDS_accounts" a on t.account_id = a.id
where t.type = 'CONVERT_DEBIT' 					
    and t.code = 'APPROVAL'						
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) > CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) != CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)
GROUP BY						
	CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE)	

UNION ALL

-- Total points as of current week
SELECT
   'Total' AS Description,
    TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles,
    To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points	
FROM "BPAY_SFCRWDS_transactions" t        
    INNER JOIN "BPAY_SFCRWDS_accounts" a ON a.id = t.account_id
WHERE               
    t.type || '-' || t.code = 'CONVERT_DEBIT-APPROVAL'
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) != CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)
    -- AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'
--     AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) = DATE_TRUNC('WEEK', CURRENT_TIMESTAMP) 
-- GROUP BY        
--     CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE)
ORDER BY 
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END, Description ASC;	
