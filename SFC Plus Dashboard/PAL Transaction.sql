SELECT
    convert_timezone('America/Los_Angeles', t."timestamp") timestamp_pacific 
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

    ,PARSE_JSON(t.properties):account_number::STRING mm_account_number
    ,PARSE_JSON(t.properties):points::STRING mm_points

FROM "BPAY_SFCRWDS_transactions" t
    INNER JOIN "BPAY_SFCRWDS_accounts" a ON t.account_id = a.id
WHERE    
    t.type  IN('CONVERT_CREDIT','CONVERT_DEBIT') 
    AND t.code = 'APPROVAL'
    AND timestamp_pacific::date = :paldate
ORDER BY
    timestamp_pacific;