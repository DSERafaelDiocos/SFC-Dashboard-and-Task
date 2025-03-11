(
    SELECT
        CAST(TO_DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', a.CREATED_AT::TIMESTAMP_NTZ)) AS VARCHAR) AS Date,
        TO_CHAR(COUNT(DISTINCT A.ID), 'FM999,999,999') AS "Registration Count"
    FROM SFC_ISDA.SFC_BRONZE.SFC_RWDS_ACCOUNTS A
        INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS core ON A.id = core.rewards_id AND core.deleted_at IS NULL
    WHERE
        TO_DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', a.CREATED_AT::TIMESTAMP_NTZ)) = :DailyRegis
        AND CURRENCY = 'USD'
        AND a.ID NOT IN (
                        '084c35ba-4e90-4cf9-96e6-ffb399c4646b',
                        '204e44d5-87a0-474b-9a58-32015fc5301a'
                        ) -- EXCLUDING SEAFOOD CITY MASTER AND SEAFOOD CITY CANADA
    GROUP BY
        TO_DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', a.CREATED_AT::TIMESTAMP_NTZ))
)
UNION ALL
(
    SELECT
        'TOTAL' AS Date,
        TO_CHAR(COUNT(DISTINCT A.ID), 'FM999,999,999') AS "Registration Count"
    FROM SFC_ISDA.SFC_BRONZE.SFC_RWDS_ACCOUNTS A
        INNER JOIN SFC_ISDA.SFC_BRONZE.SFC_PLUS_ACCOUNTS core ON A.id = core.rewards_id AND core.deleted_at IS NULL
    WHERE
        TO_DATE(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', a.CREATED_AT::TIMESTAMP_NTZ)) = :DailyRegis
        AND CURRENCY = 'USD'
        AND a.ID NOT IN (
                        '084c35ba-4e90-4cf9-96e6-ffb399c4646b',
                        '204e44d5-87a0-474b-9a58-32015fc5301a'
                        ) -- EXCLUDING SEAFOOD CITY MASTER AND SEAFOOD CITY CANADA
)
ORDER BY
    CASE WHEN Date = 'TOTAL' THEN 1 ELSE 0 END,
    Date DESC;


