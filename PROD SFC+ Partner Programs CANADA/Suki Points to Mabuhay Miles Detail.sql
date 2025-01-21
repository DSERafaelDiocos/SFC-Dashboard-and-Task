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
    ,ROUND(((t.points/500)*100)*0.02,2) CAD_amount

FROM 
    SFC_RWDS_TRANSACTIONS t 
        Inner join SFC_RWDS_ACCOUNTS  a on t.account_id = a.id
WHERE 
    t.type = 'CONVERT_DEBIT'                     
    and t.code = 'APPROVAL'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'   -- PAL
    AND A.CURRENCY = 'CAD'

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
    ,SUM(ROUND(((t.points/500)*100)*0.02,2)) CAD_amount

FROM 
    SFC_RWDS_TRANSACTIONS t 
        Inner join SFC_RWDS_ACCOUNTS  a on t.account_id = a.id
WHERE 
    t.type = 'CONVERT_DEBIT'                     
    and t.code = 'APPROVAL'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'    -- PAL
    AND A.CURRENCY = 'CAD'
    AND CONVERT_TIMEZONE('UTC','America/Los_Angeles',p.INITIATED_AT::TIMESTAMP_NTZ) = :daterange
ORDER BY
    timestamp_pacific;