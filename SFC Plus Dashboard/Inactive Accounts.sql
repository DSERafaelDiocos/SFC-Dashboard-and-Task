SELECT CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', TO_TIMESTAMP(created_at)) "CREATED_AT_PST", '''' || card_number "CARD NUMBER", first_name, last_name, email, mobile_number, 
    (SELECT COUNT(*) FROM SFC_ISDA.SFC_BRONZE.SFC_RWDS_TRANSACTIONS t WHERE t.account_id = a.id AND type = 'EARN' AND source = 'INSTORE') TransactionCount
    ,rewards.g_branch
    ,rewards.g_giveaway
FROM
    SFC_ISDA.SFC_BRONZE.SFC_RWDS_ACCOUNTS a
        LEFT OUTER JOIN (SELECT DISTINCT G_USERQR, G_BRANCH, G_GIVEAWAY FROM SFC_ISDA.SFC_BRONZE.SFC_RWDS_REWARDS) rewards ON a.card_number = rewards.g_userqr
WHERE
    TransactionCount = 0
    AND type = 'INDIVIDUAL'
    AND TO_CHAR(CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', TO_TIMESTAMP(created_at)), 'MM/DD/YYYY') = :rewardsdate
    -- AND EMAIL NOT LIKE '%talinolabs.com'
ORDER BY
    created_at desc;