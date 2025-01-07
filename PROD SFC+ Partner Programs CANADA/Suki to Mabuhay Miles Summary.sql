SELECT                                        
    TO_CHAR(CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE),'MM/DD/YYYY') Description,                    
    To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points
    ,TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles    
    ,ROUND(SUM(((t.points/500)*100)*0.02),2) CAD_amount
FROM SFC_RWDS_TRANSACTIONS t 
    Inner join SFC_RWDS_ACCOUNTS  a on t.account_id = a.id
WHERE 
    t.type = 'CONVERT_DEBIT'                     
    and t.code = 'APPROVAL'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'
    AND A.CURRENCY = 'CAD'
GROUP BY                        
    CAST(CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp")AS DATE)

UNION ALL

SELECT
   'Total' AS Description,
    To_Char(SUM(points), 'FM999,999,999') AS To_Suki_Points
    ,TO_CHAR(SUM(CAST(metadata:"points" AS INTEGER)), 'FM999,999,999')  AS  From_Mabuhay_Miles
    ,ROUND(SUM(((t.points/500)*100)*0.02),2) CAD_amount
FROM SFC_RWDS_TRANSACTIONS t        
    INNER JOIN SFC_RWDS_ACCOUNTS  a ON a.id = t.account_id
WHERE               
    t.type || '-' || t.code = 'CONVERT_DEBIT-APPROVAL'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'
    AND A.CURRENCY = 'CAD'
ORDER BY 
    CASE 
        WHEN Description LIKE 'Balance%' THEN 1
        WHEN Description LIKE 'Total%' THEN 3
        ELSE 2
    END, Description ASC;