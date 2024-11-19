SELECT CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', t."timestamp"::TIMESTAMP_NTZ) AS timestamp,
       a.id AS account_id,
       a.first_name || ' ' || a.last_name AS customer_name,
       LPAD(TO_VARCHAR(t.metadata:account_number), 11, '0') AS mabuhay_miles_number,
       TO_VARCHAR(t.metadata:points) AS from_mabuhay_miles_points,
       t.points AS to_suki_points
  FROM "BPAY_SFCRWDS_transactions" t,
       "BPAY_SFCRWDS_accounts" a
 WHERE t.account_id = a.id
   AND t.type = 'CONVERT_CREDIT'
   AND t.code = 'APPROVAL'
   AND CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', t."timestamp"::TIMESTAMP_NTZ) >= TO_TIMESTAMP_NTZ('2024-10-01')
   AND CONVERT_TIMEZONE('UTC', 'America/Los_Angeles', t."timestamp"::TIMESTAMP_NTZ) < TO_TIMESTAMP_NTZ('2024-11-01')
   AND LPAD(TO_VARCHAR(t.metadata:account_number), 11, '0') = :mabuhaysuki
 ORDER BY t."timestamp" ASC;
 