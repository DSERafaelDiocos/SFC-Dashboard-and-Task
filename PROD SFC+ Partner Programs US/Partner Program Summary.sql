WITH PackageData AS (
    SELECT
        p.amount,
        p.client_id,
        c.name as name,
        p.account_id,
        PARSE_JSON(p.particulars, 's')['items'][0]['item_name']::STRING AS item_name,
        TO_CHAR(CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE), 'MM/DD/YYYY')  Dates
    FROM SFC_ISDA.SFC_BRONZE.SFC_PLUS_PAYMENTS p
    INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_CLIENTS c ON c.id = p.client_id
    LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS a ON p.account_id = a.id
    WHERE p.status = 'APPROVED'
    AND p.CURRENCY = 'USD'
    AND CAST(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', p.INITIATED_AT::TIMESTAMP_NTZ) AS DATE) = :daterange
)

-- Query for Package A
SELECT
    Dates,
    'ABS-CBN Foundation International' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE NAME = 'ABS-CBN Foundation International'
GROUP BY Dates

UNION ALL

-- Query for Package B
SELECT
    Dates,
    'Gawad Kalinga' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE NAME = 'Gawad Kalinga'
GROUP BY Dates

UNION ALL

-- Query for Package C
SELECT
    Dates,
    'Ideal Vision US' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE NAME = 'Ideal Vision US'
GROUP BY Dates

UNION ALL

-- Query for Package D
SELECT
    Dates,
    'iWantTFC' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE NAME = 'iWantTFC'
GROUP BY Dates

UNION ALL

-- Query for Package E
SELECT
    Dates,
    'Jollibee' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE NAME = 'Jollibee US'
GROUP BY Dates

UNION ALL

-- Query for Package F
SELECT
    Dates,
    'Penshoppe' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE NAME = 'Penshoppe US'
GROUP BY Dates

UNION ALL

-- Query for Package F
SELECT
    Dates,
    'Red Ribbon' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE NAME = 'Red Ribbon US'
GROUP BY Dates

UNION ALL

-- Query for Package F
SELECT
    Dates,
    'SM Gift Pass Choice' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE NAME = 'SM Gift Pass Choice'
GROUP BY Dates

-- Final ORDER BY to sort by Description
UNION ALL

SELECT
    Dates,
   'Total' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)),'FM999,999,999.00') AS amount						
	,TO_CHAR(COUNT(*),'FM999,999,999') as count
FROM PACKAGEDATA
GROUP BY Dates

ORDER BY 
    Dates,
    CASE 
        WHEN Description LIKE 'Total%' THEN 2
        ELSE 1
    END;
