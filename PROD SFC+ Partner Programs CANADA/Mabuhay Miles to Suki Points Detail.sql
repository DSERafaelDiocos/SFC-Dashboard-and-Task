SELECT    
    
    CONVERT_TIMEZONE('America/Los_Angeles', t."timestamp") timestamp_pacific
    ,a.first_name
    ,a.middle_name
    ,a.last_name
    ,a.email
    ,a.mobile_number
    ,'****' || RIGHT(a.card_number,4) card_number
    ,t.source
    ,t.type
    ,t.code
    ,t.points
    ,PARSE_JSON(t.metadata):account_number::string mm_card_number
    ,PARSE_JSON(t.metadata):points::integer mm_points
    ,ROUND(((CAST(metadata:"points" AS INTEGER)/500)*100)*0.01,2) CAD_amount

FROM 
    SFC_RWDS_TRANSACTIONS t 
        Inner join SFC_RWDS_ACCOUNTS  a on t.account_id = a.id
WHERE 
    t.type = 'CONVERT_CREDIT'                     
    and t.code = 'APPROVAL'
    AND A.CURRENCY = 'CAD'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'   -- PAL

UNION ALL

SELECT    
    
    NULL timestamp_pacific
    ,NULL first_name
    ,NULL middle_name
    ,NULL last_name
    ,NULL email
    ,NULL mobile_number
    ,NULL card_number
    ,NULL source
    ,NULL type
    ,'Total: ' || TO_CHAR(COUNT(*)) code
    ,SUM(t.points) points
    ,NULL mm_card_number
    ,SUM(PARSE_JSON(t.metadata):points::integer) mm_points
    ,SUM(ROUND(((CAST(metadata:"points" AS INTEGER)/500)*100)*0.01,2)) CAD_amount

FROM 
    SFC_RWDS_TRANSACTIONS t 
        Inner join SFC_RWDS_ACCOUNTS  a on t.account_id = a.id
WHERE 
    t.type = 'CONVERT_CREDIT'                     
    and t.code = 'APPROVAL'
    AND A.CURRENCY = 'CAD'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'    -- PAL

ORDER BY
    timestamp_pacific;