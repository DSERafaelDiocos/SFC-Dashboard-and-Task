SELECT 
    p.doing_business_as Partner
    ,CONVERT_TIMEZONE('America/Los_Angeles', "timestamp")::date as Transact_Date_PST
    ,LPAD(metadata:"account_number"::string,11,'0') Miles_Account_Number
    ,metadata:points::string Miles_Points
    ,'****' || t.card_number_mask as Card_Number    
    ,t.points Suki_Points
    ,a.first_name || ' ' || a.last_name as Name
    ,a.mobile_number
    ,a.email
from SFC_ISDA.SFC_BRONZE.SFC_RWDS_TRANSACTIONS t 
    Inner join SFC_ISDA.SFC_BRONZE.SFC_RWDS_ACCOUNTS  a on t.account_id = a.id
    INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_RWDS_PARTNERS p ON t.partner_id = p.id
where t.type = 'CONVERT_CREDIT' 					
    and t.code = 'APPROVAL'
    AND partner_id = 'a19c59e4-f55e-428e-9efd-e9bd98d231af'
    AND CAST(CONVERT_TIMEZONE('America/Los_Angeles', "timestamp") AS DATE) = :daterange
ORDER BY
    t."timestamp";