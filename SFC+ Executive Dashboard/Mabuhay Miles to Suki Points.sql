select											
	'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)- INTERVAL '1 DAY','MM/DD/YYYY') Description					
	,To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points,					
	TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles					
						
from "BPAY_SFCRWDS_transactions" t 
    inner join "BPAY_SFCRWDS_accounts" a on t.account_id = a.id		
where
    t.type = 'CONVERT_CREDIT' -- redemption						
    and t.code = 'APPROVAL'						
    -- AND DATE(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")) < DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) <= CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
						
UNION ALL						
						
select											
	TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp") AS DATE),'MM/DD/YYYY') Description,
    -- CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp") AS DATE) AS Description,
    To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points,					
	TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles				
FROM "BPAY_SFCRWDS_transactions" t
    INNER JOIN "BPAY_SFCRWDS_accounts" a ON t.account_id = a.id
WHERE	
    t.type = 'CONVERT_CREDIT' -- redemption	
    AND t.code = 'APPROVAL'
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) > CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
    -- AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp") AS DATE) > DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) != CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)
GROUP BY						
	CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE)


UNION ALL

-- Total points as of current week
SELECT
   'Total' AS Description,
    To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points,					
	TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles
FROM "BPAY_SFCRWDS_transactions" t        
    INNER JOIN "BPAY_SFCRWDS_accounts" a ON a.id = t.account_id
WHERE        
    t.type || '-' || t.code = 'CONVERT_CREDIT-APPROVAL'
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) != CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)
--     AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) = DATE_TRUNC('WEEK', CURRENT_TIMESTAMP) 
-- GROUP BY        
--     CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE)
ORDER BY 
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END, Description ASC;
