-- MEMBERS + LOCATION
WITH MAIN AS (
    SELECT
        DISTINCT TRANS.UPC,
        CASE 
            WHEN RWDS.ID IS NOT NULL THEN 'Member'
            ELSE 'Non-Member'
        END AS MEMBER_STATUS,
        RWDS.CARD_NUMBER,
        CASE 
            WHEN RWDS.ID IS NOT NULL THEN DATEDIFF('YEAR', TRY_TO_DATE(RWDS.DATE_OF_BIRTH), TO_DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', 
            CURRENT_DATE::TIMESTAMP_NTZ))) 
            ELSE 0
        END AS AGE,
        CASE
            WHEN AGE BETWEEN 18 AND 24 THEN 'GEN Z'
            WHEN AGE BETWEEN 25 AND 40 THEN 'MILLENIALS'
            WHEN AGE BETWEEN 41 AND 56 THEN 'GEN X'
            WHEN AGE >= 57 THEN 'BOOMERS'
            ELSE 'OTHERS'
        END AS BRACKET,
        AREA.COUNTRY,
        AREA.REGION,
        UPC.DESCRIPTION,
        1 AS TAG
    
    FROM EPT_STRFD_REGISTER_HEADER HDR
    
    INNER JOIN EPT_STRFD_REGISTER_TRANS TRANS
    ON HDR.PROC_DATE = TRANS.PROC_DATE
    AND HDR.DATETIME = TRANS.DATETIME
    AND HDR.EMP_NO = TRANS.EMP_NO
    AND HDR.TILL_NO = TRANS.TILL_NO
    AND HDR.REGISTER_NO = TRANS.REGISTER_NO
    AND HDR.TRANS_NO = TRANS.TRANS_NO
    
    INNER JOIN SFC_PLUS_UPC UPC
    ON TRANS.UPC = UPC.UPC
    
    LEFT JOIN SFC_RWDS_ACCOUNTS RWDS
    ON HDR.CUST_ID = RWDS.CARD_NUMBER

    LEFT JOIN SFC_PLUS_ACCOUNTS ACCS
    ON RWDS.ID = ACCS.REWARDS_ID

    LEFT JOIN SFC_PLUS_SFC_NORTH_AMERICA_AREA_CODES AREA
    ON LEFT(ACCS.MOBILE_NUMBER, 3) = AREA.AREA_CODE

    WHERE MEMBER_STATUS = 'Member'
    AND AREA.COUNTRY = 'Canada'
    AND UPC.DEPARTMENT != 'PRODUCE'
    AND UPC.UPC NOT IN ('0060698859315',   -- T-Shirt Bag Multiuse
                        '0000000000055',   -- DINE IN
                        '0000000000016',   -- CRV less than 24o
                        '0000000000017',   -- CRV 24oz or More
                        '0017959414053')   -- Reusable Paper Bag
),
CUMULATIVE AS ( -- CUMULATIVE: CALCULATES FOR THE CUMULATIVE TAG PER ITEM
    SELECT
        CARD_NUMBER,
        COUNTRY,
        UPC,
        DESCRIPTION,
        SUM(TAG) OVER(PARTITION BY UPC, DESCRIPTION, COUNTRY ORDER BY CARD_NUMBER) AS CUMULATIVE_CNT
    
    FROM MAIN
)

SELECT 
    UPC,
    DESCRIPTION, 
    COUNTRY,
    MAX(CUMULATIVE_CNT) AS CUSTOMER_COUNT 

FROM CUMULATIVE 

GROUP BY 
    UPC,
    DESCRIPTION,
    COUNTRY

HAVING CUSTOMER_COUNT > 1 -- FILTERING TO > 1 TO MAKE SURE THAT ITEM IS BEING PURCHASED BY MULTIPLE ACCOUNTS/CUSTOMERS

ORDER BY CUSTOMER_COUNT DESC
;