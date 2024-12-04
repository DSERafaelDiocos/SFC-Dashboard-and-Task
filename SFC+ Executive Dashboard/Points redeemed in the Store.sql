SELECT
    'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_TIMESTAMP) - INTERVAL '1 DAY', 'MM/DD/YYYY') AS Description,
    --'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_DATE - INTERVAL '1 DAY'), 'MM/DD/YYYY') AS Description,
    TO_CHAR(sum(points), 'FM999,999,999,999') AS Points    
FROM "BPAY_SFCRWDS_transactions" t        
    INNER JOIN "BPAY_SFCRWDS_accounts" a ON a.id = t.account_id    
WHERE        
    t.type || '-' || t.source = 'REDEEM-INSTORE'    
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'    -- "INTERNAL-TRANSFER"
    -- AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) < DATE_TRUNC('WEEK', CURRENT_TIMESTAMP )
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) <= CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
        
UNION ALL        
        
-- Every day since the start of the week        
SELECT
    TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE), 'MM/DD/YYYY') AS Description,        
    TO_CHAR(sum(points), 'FM999,999,999,999') AS Points   
FROM "BPAY_SFCRWDS_transactions" t        
    INNER JOIN "BPAY_SFCRWDS_accounts" a ON a.id = t.account_id    
WHERE        
    t.type || '-' || t.source = 'REDEEM-INSTORE'    
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'    -- "INTERNAL-TRANSFER"
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) > CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
    -- AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) > DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) != CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)

GROUP BY        
    CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE)
    
UNION ALL


-- Total points as of current week
SELECT
   'Total' AS Description,
    TO_CHAR(SUM(points), 'FM999,999,999,999') AS Points
FROM "BPAY_SFCRWDS_transactions" t        
    INNER JOIN "BPAY_SFCRWDS_accounts" a ON a.id = t.account_id
WHERE        
    t.type || '-' || t.source = 'REDEEM-INSTORE'    
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) != CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)
--     AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) = DATE_TRUNC('WEEK', CURRENT_DATE) 
-- GROUP BY        
--     CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE)
ORDER BY 
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END, Description ASC;
