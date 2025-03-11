SELECT 
    a.id account_id
    ,'****' || t.card_number_mask card_number
    ,a.first_name
    ,a.middle_name
    ,a.last_name
    ,a.email
    ,a.mobile_number
    ,CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', t."timestamp"::TIMESTAMP_NTZ) "timestamp"    
    ,t.points
    ,PARSE_JSON(metadata):branch_code::string branch
    ,PARSE_JSON(metadata):employee_id::string employee_id
    ,PARSE_JSON(metadata):pos_id::string pos_id
    ,PARSE_JSON(metadata):transaction:amount::numeric(12,4) AS transaction_amount
FROM SFC_ISDA.SFC_BRONZE."SFC_RWDS_TRANSACTIONS" t 
INNER JOIN SFC_ISDA.SFC_BRONZE."SFC_RWDS_ACCOUNTS" AS a
ON t.account_id = a.id
WHERE 
    t.type = 'EARN'AND
    t.source = 'INSTORE' AND
    a.first_name = :FIRST_NAME AND
    a.last_name = :LAST_NAME AND
    t.account_id = :ACCOUNT_ID
    --and a.id = 'fa2de506-c716-433f-b326-9c66e1356a3c'
ORDER BY 
    t."timestamp" DESC;

    