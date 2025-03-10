WITH DUPE_HEADER AS (
    SELECT 
        PROC_DATE, DATETIME, 
        EMP_NO, TILL_NO, 
        CUST_ID, TOTAL, 
        TOT_ITEMS, POINTS_EARNED, 
        TOT_ITEMS_SCANNED, STORE_ID,
        REQUEST_STORE_NAME,
        MAX(INGESTED_DATE)
    FROM 
        EPT_STRFD_REGISTER_HEADER 
    GROUP BY
        PROC_DATE, 
        DATETIME, EMP_NO, 
        TILL_NO, CUST_ID, 
        TOTAL, TOT_ITEMS, 
        POINTS_EARNED, TOT_ITEMS_SCANNED, 
        STORE_ID,
        REQUEST_STORE_NAME
), A AS (
    SELECT 
        PROC_DATE, DATETIME, 
        EMP_NO, TILL_NO, 
        CASE WHEN CUST_ID LIKE '83%' THEN 1 ELSE 0 END AS MEMBER,
        CASE WHEN CUST_ID IS NULL THEN 1 ELSE 0 END AS NON_MEMBER, TOTAL, 
        TOT_ITEMS, POINTS_EARNED, 
        TOT_ITEMS_SCANNED, STORE_ID,
        REQUEST_STORE_NAME,
        MAX(INGESTED_DATE)
    FROM 
        EPT_STRFD_REGISTER_HEADER
    GROUP BY
        PROC_DATE, 
        DATETIME, EMP_NO, 
        TILL_NO, CUST_ID,
        TOTAL, TOT_ITEMS, 
        POINTS_EARNED, TOT_ITEMS_SCANNED, 
        STORE_ID,
        REQUEST_STORE_NAME
        
)
SELECT 
    DATE_PART(Week, REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP) AS WEEK_COUNT,
    TO_CHAR(DATE_TRUNC('WEEK', REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP)::DATE, 'MM/DD/YYYY') AS WEEK_OF,
    CASE 
            WHEN REQUEST_STORE_NAME = 'Las Vegas' THEN 'Seafood City Las Vegas'
            WHEN REQUEST_STORE_NAME = 'Concord' THEN 'Seafood City Concord'
            WHEN REQUEST_STORE_NAME = 'Arroyo Crossing' THEN 'Seafood City Arroyo Crossing'
            WHEN REQUEST_STORE_NAME = 'Santa Clarita' THEN 'Seafood City Santa Clarita'
            WHEN REQUEST_STORE_NAME = 'Seattle' THEN 'Seafood City Seattle'
            WHEN REQUEST_STORE_NAME = 'Sacramento' THEN 'Seafood City Sacramento'
            WHEN REQUEST_STORE_NAME = 'Rancho Cucamonga' THEN 'Seafood City Rancho Cucamonga'
            WHEN REQUEST_STORE_NAME = 'Irvine' THEN 'Seafood City Irvine'
            WHEN REQUEST_STORE_NAME = 'Henderson' THEN 'Seafood City Henderson'
            WHEN REQUEST_STORE_NAME = 'Shadow Mountain' THEN 'Seafood City Shadow Mountain'
            WHEN REQUEST_STORE_NAME = 'Hayward' THEN 'Seafood City Hayward'
            WHEN REQUEST_STORE_NAME = 'Oxnard' THEN 'Seafood City Oxnard'
            WHEN REQUEST_STORE_NAME = 'Eagle Rock' THEN 'Seafood City Eagle Rock'
            WHEN REQUEST_STORE_NAME = 'Milpitas' THEN 'Seafood City Milpitas'
            WHEN REQUEST_STORE_NAME = 'Sugarland' THEN 'Seafood City Sugarland'
            WHEN REQUEST_STORE_NAME = 'Los Angeles' THEN 'Seafood City Los Angeles'
            WHEN REQUEST_STORE_NAME = 'Mira Mesa' THEN 'Seafood City Mira Mesa'
            WHEN REQUEST_STORE_NAME = 'Cerritos' THEN 'Seafood City Cerritos'
            WHEN REQUEST_STORE_NAME = 'Chula Vista' THEN 'Seafood City Chula Vista'
            WHEN REQUEST_STORE_NAME = 'Panorama' THEN 'Seafood City Panorama'
            WHEN REQUEST_STORE_NAME = 'North Hills' THEN 'Seafood City North Hills'
            WHEN REQUEST_STORE_NAME = 'Vallejo' THEN 'Seafood City Vallejo'
            WHEN REQUEST_STORE_NAME = 'Union' THEN 'Seafood City Union'
            WHEN REQUEST_STORE_NAME = 'Carson' THEN 'Seafood City Carson'
            WHEN REQUEST_STORE_NAME = 'West Covina' THEN 'Seafood City West Covina'
            WHEN REQUEST_STORE_NAME = 'Anaheim' THEN 'Seafood City Anaheim'
            WHEN REQUEST_STORE_NAME = 'South San Francisco' THEN 'Seafood City South San Francisco'
            WHEN REQUEST_STORE_NAME = 'Wanpaihu' THEN 'Seafood City Waipahu'
            WHEN REQUEST_STORE_NAME = 'Chicago' THEN 'Seafood City Chicago'
            WHEN REQUEST_STORE_NAME = 'National City' THEN 'Seafood City National City'
            WHEN REQUEST_STORE_NAME = 'Manila Seafood National City' THEN 'Manila National City'
            ELSE REQUEST_STORE_NAME
        END as STORE,
    SUM(TOT_ITEMS) / COUNT(*) AS AVG_BASKET_SIZE,
    SUM(MEMBER) / COUNT(*) AS AVG_BASKET_SIZE_MEMBER,
    SUM(NON_MEMBER) / COUNT(*) AS AVG_BASKET_SIZE_NON_MEMBER,
    SUM(TOTAL) / COUNT(*) AS AVG_BASKET_AMOUNT,
    SUM(MEMBER) / COUNT(*) AS AVG_BASKET_AMOUNT_MEMBER,
    SUM(NON_MEMBER) / COUNT(*) AS AVG_BASKET_AMOUNT_NON_MEMBER
FROM 
    A
    -- AND CUST_ID = '8366880002700306' 
    -- AND DATETIME LIKE '1/27/2025 %'
GROUP BY
    WEEK_COUNT,
    WEEK_OF,
    STORE
ORDER BY WEEK_COUNT, STORE,
    WEEK_OF DESC;