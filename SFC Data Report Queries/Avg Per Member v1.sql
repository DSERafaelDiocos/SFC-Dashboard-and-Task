with E as (
    SELECT 
        DATE_PART(Week, REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP) AS WEEK_COUNT,
        TO_CHAR(DATE_TRUNC('WEEK', REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP)::DATE, 'MM/DD/YYYY') AS WEEK_OF,
        REQUEST_STORE_NAME AS STORE,
        COUNT(*) AS UNIT_SOLD_NON_MEMBER,
        SUM(TOTAL) AS TOTAL_TRANSACTION_AMOUNT_NON_MEMBER
    FROM EPT_STRFD_REGISTER_TRANS RT
    WHERE CARD_NO IS NULL
    GROUP BY 
        WEEK_COUNT,
        WEEK_OF,
        STORE
), D as (
    SELECT 
        DATE_PART(Week, REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP) AS WEEK_COUNT,
        TO_CHAR(DATE_TRUNC('WEEK', REPLACE(REPLACE(DATETIME, 'AM', ''), 'PM', '')::TIMESTAMP)::DATE, 'MM/DD/YYYY') AS WEEK_OF,
        REQUEST_STORE_NAME AS STORE,
        COUNT(*) AS UNIT_SOLD_MEMBER,
        SUM(TOTAL) AS TOTAL_TRANSACTION_AMOUNT_MEMBER,
    FROM EPT_STRFD_REGISTER_TRANS RT
    WHERE CARD_NO LIKE '83%' AND CARD_NO NOT LIKE '%XXXXX%'
    GROUP BY 
        WEEK_COUNT,
        WEEK_OF,
        STORE
), C as (
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
    WHERE (CUST_ID LIKE '83%' AND CUST_ID NOT LIKE '%XXXXX%') OR CUST_ID IS NULL
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
    A.STORE,
    A.UNIT_SOLD / B.NUMBER_OF_TRANSACTIONS AS AVG_BASKET_SIZE,
    D.UNIT_SOLD_MEMBER / B.NUMBER_OF_TRANSACTIONS as AVG_BASKET_SIZE_MEMBER,
    E.UNIT_SOLD_NON_MEMBER / B.NUMBER_OF_TRANSACTIONS as AVG_BASKET_SIZE_NON_MEMBER,
    A.TOTAL_TRANSACTION_AMOUNT / B.NUMBER_OF_TRANSACTIONS AS AVG_BASKET_AMOUNT,
    D.TOTAL_TRANSACTION_AMOUNT_MEMBER / B.NUMBER_OF_TRANSACTIONS AS AVG_BASKET_AMOUNT_MEMBER,
    E.TOTAL_TRANSACTION_AMOUNT_NON_MEMBER / B.NUMBER_OF_TRANSACTIONS AS AVG_BASKET_AMOUNT_NON_MEMBER,
    C.MEMBER_COUNT,
    C.NON_MEMBER_COUNT
FROM A
INNER JOIN B ON A.STORE = B.STORE
    AND A.WEEK_COUNT = B.WEEK_COUNT
    AND A.WEEK_OF = B.WEEK_OF
INNER JOIN C ON A.STORE = C.STORE
    AND A.WEEK_COUNT = C.WEEK_COUNT
    AND A.WEEK_OF = C.WEEK_OF
INNER JOIN D ON A.STORE = D.STORE
    AND A.WEEK_COUNT = D.WEEK_COUNT
    AND A.WEEK_OF = D.WEEK_OF
INNER JOIN E ON A.STORE = E.STORE
    AND A.WEEK_COUNT = E.WEEK_COUNT
    AND A.WEEK_OF = E.WEEK_OF
ORDER BY A.WEEK_COUNT, A.STORE;