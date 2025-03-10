ALTER SESSION SET WEEK_OF_YEAR_POLICY = 1;
with C as (
    SELECT 
        DATE_PART(Week, REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP) AS WEEK_COUNT,
        TO_CHAR(DATE_TRUNC('WEEK', REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP)::DATE, 'MM/DD/YYYY') AS WEEK_OF,
        REQUEST_STORE_NAME AS STORE,
        SUM(CASE WHEN CUST_ID IS NOT NULL THEN 1 ELSE 0 END) AS MEMBER_COUNT,
        SUM(CASE WHEN CUST_ID IS NULL THEN 1 ELSE 0 END) AS NON_MEMBER_COUNT
    FROM EPT_STRFD_REGISTER_HEADER
    WHERE (CUST_ID LIKE '83%' AND CUST_ID NOT LIKE '%XXXXX%') OR CUST_ID IS NULL
    GROUP BY 
        WEEK_COUNT,
        WEEK_OF,
        STORE
),B as (
    SELECT 
        DATE_PART(Week, REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP) AS WEEK_COUNT,
        TO_CHAR(DATE_TRUNC('WEEK', REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP)::DATE, 'MM/DD/YYYY') AS WEEK_OF,
        REQUEST_STORE_NAME AS STORE,
        COUNT(*) AS NUMBER_OF_TRANSACTIONS,
    FROM EPT_STRFD_REGISTER_HEADER
    GROUP BY
        WEEK_COUNT,
        WEEK_OF,
        STORE
), A AS (
    SELECT 
        DATE_PART(Week, REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP) AS WEEK_COUNT,
        TO_CHAR(DATE_TRUNC('WEEK', REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP)::DATE, 'MM/DD/YYYY') AS WEEK_OF,
        REQUEST_STORE_NAME AS STORE,
        COUNT(*) AS UNIT_SOLD,
        SUM(TOTAL) AS TOTAL_TRANSACTION_AMOUNT,
    FROM EPT_STRFD_REGISTER_TRANS RT
    WHERE (CARD_NO LIKE '83%' AND CARD_NO NOT LIKE '%XXXXX%') OR CARD_NO IS NULL
    GROUP BY 
        WEEK_COUNT,
        WEEK_OF,
        STORE
)
SELECT
    A.WEEK_COUNT,
    A.WEEK_OF,
    CASE 
            WHEN A.STORE = 'Las Vegas' THEN 'Seafood City Las Vegas'
            WHEN A.STORE = 'Concord' THEN 'Seafood City Concord'
            WHEN A.STORE = 'Arroyo Crossing' THEN 'Seafood City Arroyo Crossing'
            WHEN A.STORE = 'Santa Clarita' THEN 'Seafood City Santa Clarita'
            WHEN A.STORE = 'Seattle' THEN 'Seafood City Seattle'
            WHEN A.STORE = 'Sacramento' THEN 'Seafood City Sacramento'
            WHEN A.STORE = 'Rancho Cucamonga' THEN 'Seafood City Rancho Cucamonga'
            WHEN A.STORE = 'Irvine' THEN 'Seafood City Irvine'
            WHEN A.STORE = 'Henderson' THEN 'Seafood City Henderson'
            WHEN A.STORE = 'Shadow Mountain' THEN 'Seafood City Shadow Mountain'
            WHEN A.STORE = 'Hayward' THEN 'Seafood City Hayward'
            WHEN A.STORE = 'Oxnard' THEN 'Seafood City Oxnard'
            WHEN A.STORE = 'Eagle Rock' THEN 'Seafood City Eagle Rock'
            WHEN A.STORE = 'Milpitas' THEN 'Seafood City Milpitas'
            WHEN A.STORE = 'Sugarland' THEN 'Seafood City Sugarland'
            WHEN A.STORE = 'Los Angeles' THEN 'Seafood City Los Angeles'
            WHEN A.STORE = 'Mira Mesa' THEN 'Seafood City Mira Mesa'
            WHEN A.STORE = 'Cerritos' THEN 'Seafood City Cerritos'
            WHEN A.STORE = 'Chula Vista' THEN 'Seafood City Chula Vista'
            WHEN A.STORE = 'Panorama' THEN 'Seafood City Panorama'
            WHEN A.STORE = 'North Hills' THEN 'Seafood City North Hills'
            WHEN A.STORE = 'Vallejo' THEN 'Seafood City Vallejo'
            WHEN A.STORE = 'Union' THEN 'Seafood City Union'
            WHEN A.STORE = 'Carson' THEN 'Seafood City Carson'
            WHEN A.STORE = 'West Covina' THEN 'Seafood City West Covina'
            WHEN A.STORE = 'Anaheim' THEN 'Seafood City Anaheim'
            WHEN A.STORE = 'South San Francisco' THEN 'Seafood City South San Francisco'
            WHEN A.STORE = 'Wanpaihu' THEN 'Seafood City Wanpaihu'
            WHEN A.STORE = 'Chicago' THEN 'Seafood City Chicago'
            WHEN A.STORE = 'National City' THEN 'Manila Seafood National City'
            WHEN A.STORE = 'Manila National City' THEN 'Manila Seafood National City'
            ELSE A.STORE
        END as STORE,
    A.UNIT_SOLD / B.NUMBER_OF_TRANSACTIONS AS AVG_BASKET_SIZE,
    A.TOTAL_TRANSACTION_AMOUNT / B.NUMBER_OF_TRANSACTIONS AS AVG_BASKET_VALUE,
    C.MEMBER_COUNT,
    C.NON_MEMBER_COUNT
FROM A
INNER JOIN B ON A.STORE = B.STORE
    AND A.WEEK_COUNT = B.WEEK_COUNT
    AND A.WEEK_OF = B.WEEK_OF
INNER JOIN C ON A.STORE = C.STORE
    AND A.WEEK_COUNT = C.WEEK_COUNT
    AND A.WEEK_OF = C.WEEK_OF
ORDER BY A.STORE,
A.WEEK_COUNT;