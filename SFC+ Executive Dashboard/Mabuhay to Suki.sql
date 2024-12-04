select						
	0 SortOrder					
	,'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_DATE)- INTERVAL '1 DAY','MM/DD/YYYY') Description					
	,SUM(points) To_Suki_Points,					
	SUM(CAST(metadata:"points" AS INTEGER))  AS  From_Mabuhay_Miles					
						
from "BPAY_SFCRWDS_transactions" t 
    inner join "BPAY_SFCRWDS_accounts" a on t.account_id = a.id		
where
    t.type = 'CONVERT_CREDIT' -- redemption						
    and t.code = 'APPROVAL'						
    AND DATE(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")) < DATE_TRUNC('WEEK', CURRENT_DATE)						
						
UNION ALL						
						
select						
	1 SortOrder					
	,TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp") AS DATE),'MM/DD/YYYY') Description					
	,SUM(points) To_Suki_Points					
	,SUM(CAST(metadata:"points" AS INTEGER))  AS  From_Mabuhay_Miles				
FROM "BPAY_SFCRWDS_transactions" t
    INNER JOIN "BPAY_SFCRWDS_accounts" a ON t.account_id = a.id
WHERE	
    t.type = 'CONVERT_CREDIT' -- redemption	
    AND t.code = 'APPROVAL'	
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp") AS DATE) >= DATE_TRUNC('WEEK', CURRENT_DATE)
    AND TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp") AS DATE), 'MM/DD/YYYY') = :sfcdate
GROUP BY						
	DATE(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp"))					
ORDER BY						
	SORTORDER;	