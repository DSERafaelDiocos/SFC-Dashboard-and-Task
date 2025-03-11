SELECT 
    source
    ,type
    ,code
    ,points
    ,reference_id
    ,t."timestamp"
    ,t.id transaction_id
    ,metadata:"transaction":amount::FLOAT amount
    ,CASE WHEN metadata:"transaction":amount_landed::VARCHAR = '' THEN 0 ELSE metadata:"transaction":amount_landed::VARCHAR::FLOAT END amount_landed
    ,metadata:"transaction":channel::VARCHAR channel
    ,metadata:"transaction":currency::VARCHAR currency
    ,metadata:"transaction":currency_landed::VARCHAR currency_landed
    ,metadata:"transaction":delivery_method::VARCHAR delivery_method
    ,metadata:"transaction":exchange_rate::VARCHAR exchange_rate
    ,metadata:"transaction":mobile_number::VARCHAR mobile_number
    ,metadata:"transaction":recipient::VARCHAR recipient
    ,metadata:"transaction":sender::VARCHAR sender
    ,metadata:"transaction":short_id::VARCHAR short_id
FROM 
    SFC_ISDA.SFC_BRONZE.SFC_RWDS_TRANSACTIONS t
WHERE
    source = 'REMITTANCE'
    --AND metadata:"transaction":"channel" = 'BAYANIPAY-SSO'
    AND metadata:"transaction":"channel" IS NULL
    AND account_id != '084c35ba-4e90-4cf9-96e6-ffb399c4646b'
    --AND LEN(metadata:"transaction":amount_landed) > 0
ORDER BY
    t."timestamp";