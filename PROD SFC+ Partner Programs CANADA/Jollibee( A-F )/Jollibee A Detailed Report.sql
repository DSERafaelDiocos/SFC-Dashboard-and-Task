SELECT
    CONCAT(
        IFNULL(a.FIRST_NAME, ''),
        ' ',
        IFNULL(a.MIDDLE_NAME, ''),
        ' ',
        IFNULL(a.LAST_NAME, '')
    ) AS FULL_NAME,
    a.EMAIL_ADDRESS,
    a.MOBILE_NUMBER,
    TO_CHAR(CAST(amount AS NUMERIC),'FM999,999,999.00') AS amount,	
    p.currency,
    CONVERT_TIMEZONE('UTC','America/Los_Angeles',p.INITIATED_AT::TIMESTAMP_NTZ) AS DATE
    ,PARSE_JSON(p.particulars, 's')['items'][0]['item_name']::STRING package
FROM
    SFC_ISDA.SFC_BRONZE.SFC_PLUS_PAYMENTS p
    INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_CLIENTS c ON c.id = p.client_id
    LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS a ON p.account_id = a.id
WHERE
    p.status = 'APPROVED'
    AND c.name = 'Jollibee Canada'
    AND p.CURRENCY = 'CAD'
    AND CONVERT_TIMEZONE('UTC','America/Los_Angeles',p.INITIATED_AT::TIMESTAMP_NTZ) = :daterange
    AND PARSE_JSON(p.particulars, 's')['items'][0]['item_name']::STRING LIKE '%Jollibee SFC+ Package A%'
ORDER BY 
    CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', p.INITIATED_AT::TIMESTAMP_NTZ)