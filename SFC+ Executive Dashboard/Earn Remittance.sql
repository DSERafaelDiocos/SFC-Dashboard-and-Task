SELECT 0 AS SortOrder,
    'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_DATE - INTERVAL '1 DAY'), 'MM/DD/YYYY') AS Description,
    -- 'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_DATE) - INTERVAL '1 DAY', 'MM/DD/YYYY') AS Description,
    SUM(Points) AS Points    
FROM "BPAY_SFCRWDS_transactions" t        
    INNER JOIN "BPAY_SFCRWDS_accounts" a ON a.id = t.account_id    
WHERE        
    t.type || '-' || t.source = 'EARN-REMITTANCE'    
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'    -- "INTERNAL-TRANSFER"
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) < DATE_TRUNC('WEEK', CURRENT_DATE)
        
UNION ALL        
        
-- Every day since the start of the week        
SELECT 1 AS SortOrder, 
    TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE), 'MM/DD/YYYY') AS Description,        
    SUM(Points) AS Points    
FROM "BPAY_SFCRWDS_transactions" t        
    INNER JOIN "BPAY_SFCRWDS_accounts" a ON a.id = t.account_id    
WHERE        
    t.type || '-' || t.source = 'EARN-REMITTANCE'    
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'    -- "INTERNAL-TRANSFER"
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) >= DATE_TRUNC('WEEK', CURRENT_DATE) 
    AND TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE), 'MM/DD/YYYY') = :sfcdate
GROUP BY        
    CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE)
ORDER BY        
    SortOrder, Description;