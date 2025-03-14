SELECT
    CASE WHEN PACCS.GENDER_CODE IS NULL OR PACCS.GENDER_CODE = ' ' THEN 'NOT SPECIFIED' 
        ELSE GENDER_CODE 
    END AS GENDER,
    COUNT(DISTINCT PACCS.ID) AS USERS,
    TO_DECIMAL((COUNT(*) / SUM(COUNT(*)) OVER()) * 100, 10, 2) AS "PERCENTAGE %"

FROM SFC_PLUS_ACCOUNTS PACCS

LEFT JOIN SFC_RWDS_ACCOUNTS RACCS
ON PACCS.REWARDS_ID = RACCS.ID 

WHERE PACCS.MOBILE_NUMBER_COUNTRY_CODE = '1'