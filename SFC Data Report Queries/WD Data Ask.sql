WITH MAIN AS (
    SELECT 
        HDR.PROC_DATE,
        HDR.DATETIME,
        HDR.EMP_NO,
        HDR.TILL_NO,
        HDR.REGISTER_NO,
        HDR.TRANS_NO,
        CASE 
            WHEN HDR.CUST_ID LIKE '83%' THEN 'Member' ELSE 'Non-Member'
            -- WHEN HDR.CUST_ID LIKE '83%' AND CUST_ID NOT LIKE '%XXXXX%' THEN 'Member'
            -- WHEN HDR.CUST_ID IS NULL THEN 'Non-Member' ELSE 'AAA'
        END AS MEMBERSHIP,
        HDR.REQUEST_STORE_NAME,
        TO_DATE(TO_TIMESTAMP(HDR.DATETIME, 'MM/DD/YYYY HH12:MI:SS PM')) AS DATE,
        MAX(HDR.TOTAL) AS TOTAL, 
        -- SUM(TOT_ITEMS) AS TOTAL_ITEMS
    FROM EPT_STRFD_REGISTER_HEADER HDR
    WHERE HDR.CUST_ID LIKE '83%'
    OR HDR.CUST_ID IS NULL
    GROUP BY 
        HDR.PROC_DATE,
        HDR.DATETIME,
        HDR.EMP_NO,
        HDR.TILL_NO,
        HDR.REGISTER_NO,
        HDR.TRANS_NO,
        MEMBERSHIP,
        HDR.REQUEST_STORE_NAME
)

SELECT
    SUBSTR(DATE, 0, 7) AS YEAR_MONTH,
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
        END as REQUEST_STORE_NAME,
    MEMBERSHIP,
    SUM(TOTAL) AS TOTAL_REVENUE,
    COUNT(*) AS TRX_COUNT,
    SUM(TOTAL) / COUNT(*) AS AOV
FROM MAIN
-- WHERE REQUEST_STORE_NAME LIKE '%Sacramento%'
GROUP BY 
    SUBSTR(DATE, 0, 7),
    REQUEST_STORE_NAME,
    MEMBERSHIP
ORDER BY REQUEST_STORE_NAME ASC, YEAR_MONTH ASC;