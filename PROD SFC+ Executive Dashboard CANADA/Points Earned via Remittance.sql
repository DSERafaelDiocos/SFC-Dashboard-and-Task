SELECT
    'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_TIMESTAMP) - INTERVAL '1 DAY', 'MM/DD/YYYY') AS Description,
    TO_CHAR(sum(points), 'FM999,999,999,999') AS Points    
FROM SFC_ISDA.SFC_BRONZE.SFC_RWDS_TRANSACTIONS t        
    INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_RWDS_ACCOUNTS  a ON a.id = t.account_id    
WHERE        
    t.type || '-' || t.source = 'EARN-REMITTANCE'    
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'
    AND partner_id = 'a18641a4-142f-402f-9dd4-76a58dc2537e'	-- Seafood City Canada
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) < CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
    --AND a.CURRENCY = 'CAD'
UNION ALL        
        
-- Every day since the start of the week        
SELECT
    TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE), 'MM/DD/YYYY') AS Description,        
    TO_CHAR(sum(points), 'FM999,999,999,999') AS Points     
FROM SFC_ISDA.SFC_BRONZE.SFC_RWDS_TRANSACTIONS t        
    INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_RWDS_ACCOUNTS  a ON a.id = t.account_id    
WHERE        
    t.type || '-' || t.source = 'EARN-REMITTANCE'    
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'
    AND partner_id = 'a18641a4-142f-402f-9dd4-76a58dc2537e'	-- Seafood City Canada
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) > CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
    --AND a.CURRENCY = 'CAD'
GROUP BY        
        Description

UNION ALL


-- Total points as of current week
SELECT
   'Total' AS Description,
    TO_CHAR(SUM(points), 'FM999,999,999,999') AS Points
FROM SFC_ISDA.SFC_BRONZE.SFC_RWDS_TRANSACTIONS t        
    INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_RWDS_ACCOUNTS  a ON a.id = t.account_id
WHERE        
    t.type || '-' || t.source = 'EARN-REMITTANCE'    
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'
    AND partner_id = 'a18641a4-142f-402f-9dd4-76a58dc2537e'	-- Seafood City Canada
    --AND a.CURRENCY = 'CAD'
ORDER BY 
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END, Description ASC;