WITH PackageData AS (
    SELECT
        p.amount,
        p.client_id,
        p.account_id,
        PARSE_JSON(p.particulars, 's')['items'][0]['item_name']::STRING AS item_name,
        TO_CHAR(CAST(convert_timezone('America/Los_Angeles', p.initiated_at) AS DATE), 'MM/DD/YYYY')  Dates
    FROM SFC_ISDA.SFC_BRONZE.SFC_PLUS_PAYMENTS p
    INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_CLIENTS c ON c.id = p.client_id
    LEFT OUTER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS a ON p.account_id = a.id
    WHERE p.status || '-' || c.name = 'APPROVED-Jollibee Canada'
    AND p.CURRENCY = 'CAD'
    AND CAST(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', p.INITIATED_AT::TIMESTAMP_NTZ) AS DATE) = :daterange
)

-- Query for Package A
SELECT
    Dates,
    'Package A' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE item_name LIKE '%Jollibee SFC+ Package A%'
GROUP BY Dates

UNION ALL

-- Query for Package B
SELECT
    Dates,
    'Package B' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE item_name LIKE '%Jollibee SFC+ Package B%'
GROUP BY Dates

UNION ALL

-- Query for Package C
SELECT
    Dates,
    'Package C' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE item_name LIKE '%Jollibee SFC+ Package C%'
GROUP BY Dates

UNION ALL

-- Query for Package D
SELECT
    Dates,
    'Package D' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE item_name LIKE '%Jollibee SFC+ Package D%'
GROUP BY Dates

UNION ALL

-- Query for Package E
SELECT
    Dates,
    'Package E' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE item_name LIKE '%Jollibee SFC+ Package E%'
GROUP BY Dates

UNION ALL

-- Query for Package F
SELECT
    Dates,
    'Package F' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)), 'FM999,999,999.00') AS amount,
    TO_CHAR(COUNT(*), 'FM999,999,999') AS count
FROM PackageData
WHERE item_name LIKE '%Jollibee SFC+ Package F%'
GROUP BY Dates

-- Final ORDER BY to sort by Description
UNION ALL

SELECT
    Dates,
   'Total' AS Description,
    TO_CHAR(SUM(CAST(amount AS NUMERIC)),'FM999,999,999.00') AS amount						
	,TO_CHAR(COUNT(*),'FM999,999,999') as count
FROM PACKAGEDATA
WHERE item_name LIKE '%Jollibee SFC+ Package %'
GROUP BY Dates

ORDER BY 
    Dates ,
    Description;
