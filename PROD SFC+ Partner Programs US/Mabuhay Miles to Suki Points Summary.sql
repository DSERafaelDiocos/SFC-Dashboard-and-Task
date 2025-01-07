SELECT                                        
    TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE),'MM/DD/YYYY') Description,                    
    To_Char(SUM(points), 'FM999,999,999') AS points
    ,TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  mm_points    
    ,ROUND(SUM(((PARSE_JSON(metadata):points::INTEGER/500)*100)*0.01),2) usd_amount
FROM SFC_RWDS_TRANSACTIONS t 
    Inner join SFC_RWDS_ACCOUNTS  a on t.account_id = a.id
WHERE 
    t.type = 'CONVERT_CREDIT'                     
    and t.code = 'APPROVAL'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'
    AND A.CURRENCY = 'USD'
GROUP BY                        
    CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE)

UNION ALL

SELECT
   'Total' AS Description,
    To_Char(SUM(points), 'FM999,999,999') AS points
    ,TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  mm_points
    ,ROUND(SUM(((CAST(metadata:"points" AS INTEGER)/500)*100)*0.01),2) usd_amount
FROM SFC_RWDS_TRANSACTIONS t        
    INNER JOIN SFC_RWDS_ACCOUNTS  a ON a.id = t.account_id
WHERE               
    t.type = 'CONVERT_CREDIT'
    AND t.code = 'APPROVAL'
    AND A.CURRENCY = 'USD'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'
ORDER BY 
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END, Description ASC;
    