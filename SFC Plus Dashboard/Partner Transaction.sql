SELECT        
    convert_timezone('America/Los_Angeles', p.initiated_at)  payment_timestamp_pacific
    ,a.first_name
    ,a.middle_name
    ,a.last_name
    ,a.email_address
    ,a.mobile_number
    --,a.card_number
    ,c.name partner
        
    ,p.amount payment_amount
    ,p.currency payment_currency
    ,p.reference_id payment_reference_id
    ,p.status payment_status
    ,PARSE_JSON(p.particulars):items[0].item_name item_name
    ,PARSE_JSON(p.particulars):items[0].value item_value
FROM 
    SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_payments" p                        
    INNER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_clients" c ON c.id = p.client_id                        
    LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE."BPAY_SFCPLUS_accounts" a ON p.account_id = a.id                        
WHERE                            
    p.status = 'APPROVED'    
    AND payment_timestamp_pacific::date = :initiatedate
               

ORDER BY payment_timestamp_pacific;