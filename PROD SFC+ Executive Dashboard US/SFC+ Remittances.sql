SELECT 
    id remittance_id
    ,r.remittance_number
    ,reference_id
    ,transaction_amount
    ,transaction_currency
    ,r.snapshot:response:exchange_rate::FLOAT exchange_rate
    ,landed_amount
    ,landed_currency
    ,transaction_fee
    ,paycode
    ,properties:agent_id::VARCHAR agent_id
    ,r.properties:branch_code::VARCHAR branch_code
    ,r.properties:pos_id::VARCHAR pos_id
    ,r.status
    ,r.purpose
    ,CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', r.created_at ::TIMESTAMP_NTZ) created_at
    ,CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', r.accepted_at ::TIMESTAMP_NTZ) accepted_at
    ,CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', r.posted_at ::TIMESTAMP_NTZ) posted_at
    ,CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', r.claimed_at ::TIMESTAMP_NTZ) claimed_at
    ,snapshot:sender:first_name::VARCHAR sender_first_name
    ,snapshot:sender:last_name::VARCHAR sender_last_name
    ,snapshot:sender:mobile_number::VARCHAR sender_mobile_number
    ,snapshot:recipient:first_name::VARCHAR receiver_first_name
    ,snapshot:recipient:last_name::VARCHAR receiver_last_name
    ,snapshot:recipient:mobile_number::VARCHAR receiver_mobile_number
    
FROM
    SFC_ISDA.SFC_BRONZE.SFC_PLUS_REMITTANCES r
WHERE
   -- r.accepted_at IS NOT NULL
    r.remittance_number IS NOT NULL
    AND TRANSACTION_CURRENCY = 'USD'
    AND TO_DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', r.accepted_at::TIMESTAMP_NTZ)) = :daterange;