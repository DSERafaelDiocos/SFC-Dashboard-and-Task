select						
	0 SortOrder					
	,'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_DATE)- INTERVAL '1 DAY','MM/DD/YYYY') Description					
	,SUM(CAST(metadata:"points" AS INTEGER))  AS  To_Mabuhay_Miles,
    SUM(points) From_Suki_Points				
											
from "BPAY_SFCRWDS_transactions" t 
    Inner join "BPAY_SFCRWDS_accounts" a on t.account_id = a.id
where t.type = 'CONVERT_DEBIT' 					
    and t.code = 'APPROVAL'						
    AND DATE(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")) < DATE_TRUNC('WEEK', CURRENT_DATE)						
						
UNION ALL						
						
select						
	1 SortOrder					
	,TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE),'MM/DD/YYYY') Description					
	,SUM(CAST(metadata:"points" AS INTEGER))  AS  To_Mabuhay_Miles,
    SUM(points) From_Suki_Points	
    
from "BPAY_SFCRWDS_transactions" t 
    Inner join "BPAY_SFCRWDS_accounts" a on t.account_id = a.id
where t.type = 'CONVERT_DEBIT' 					
    and t.code = 'APPROVAL'						
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE) >= DATE_TRUNC('WEEK', CURRENT_DATE)
    AND TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE), 'MM/DD/YYYY') = :sfcdate
GROUP BY						
	CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE)					
ORDER BY						
	SORTORDER,
    Description asc;	