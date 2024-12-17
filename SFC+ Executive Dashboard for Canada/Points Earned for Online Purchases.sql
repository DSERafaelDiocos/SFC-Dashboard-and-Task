SELECT 
    'Balance as of ' || TO_CHAR(DATE_TRUNC('WEEK', CURRENT_TIMESTAMP) - INTERVAL '1 DAY', 'MM/DD/YYYY') AS Description,
    TO_CHAR(SUM(points), 'FM999,999,999,999') AS Points
FROM SFC_RWDS_TRANSACTIONS t        
    INNER JOIN SFC_RWDS_ACCOUNTS a ON a.id = t.account_id
WHERE        
    t.type || '-' || t.source = 'EARN-ONLINE'    
    -- AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'
    AND partner_id = 'a18641a4-142f-402f-9dd4-76a58dc2537e'-- "INTERNAL-TRANSFER"
    -- AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) < DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) <= CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)

UNION ALL        

SELECT 
    TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE), 'MM/DD/YYYY') AS Description,        
    TO_CHAR(sum(points), 'FM999,999,999,999') AS Points
FROM SFC_RWDS_TRANSACTIONS t        
    INNER JOIN SFC_RWDS_ACCOUNTS a ON a.id = t.account_id    
WHERE        
    t.type || '-' || t.source = 'EARN-ONLINE'    
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'
    AND partner_id = 'a18641a4-142f-402f-9dd4-76a58dc2537e'-- "INTERNAL-TRANSFER"
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) > CAST(CONVERT_TIMEZONE('America/Los_Angeles', DATE_TRUNC('WEEK', CURRENT_TIMESTAMP)) AS DATE)
    -- AND TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE), 'MM/DD/YYYY') > DATE_TRUNC('WEEK', CURRENT_TIMESTAMP) 
    -- AND TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE), 'MM/DD/YYYY') <= CURRENT_DATE
    -- AND TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE), 'MM/DD/YYYY') != CURRENT_DATE
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) != CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)
GROUP BY        
    CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE)

UNION ALL


-- Total points as of current week
SELECT
   'Total' AS Description,
    TO_CHAR(SUM(points), 'FM999,999,999,999') AS Points
FROM SFC_RWDS_TRANSACTIONS t        
    INNER JOIN SFC_RWDS_ACCOUNTS a ON a.id = t.account_id
WHERE        
    t.type || '-' || t.source = 'EARN-ONLINE'    
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'
    AND partner_id = 'a18641a4-142f-402f-9dd4-76a58dc2537e'
    -- AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) < CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) != CAST(CONVERT_TIMEZONE('America/Los_Angeles', CURRENT_TIMESTAMP) AS DATE)
    -- AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) >= DATE_TRUNC('WEEK', CURRENT_DATE) 
-- GROUP BY        
--     CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE)
ORDER BY 
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END, Description ASC;