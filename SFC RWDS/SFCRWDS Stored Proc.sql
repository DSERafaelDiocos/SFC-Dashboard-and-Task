CREATE OR REPLACE PROCEDURE SFC_RWDS_CONTINOUS_GRANTING()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
   GRANT SELECT ON TABLE SFC_RWDS_ACCOUNTS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_ACCOUNT_PROGRAMS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_API_KEYS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_BATCHES TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_BATCH_STATUS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_BATCH_SUMMARY TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_BATCH_TRANSACTIONS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_FM_INV TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_ITEMCODES TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PARTNERS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PARTNER_ACCOUNT TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PARTNER_BINS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PARTNER_CARD_NUMBERS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PARTNER_PROGRAMS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PROGRAMS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_REPORTS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_REPORT_DETAILS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_REWARDS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_SCHEMA_MIGRATIONS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_TRANSACTIONS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_TRANSACTION_TYPES TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_TRANSFERS TO ROLE SFC_EXECUTIVE_ROLE;
   GRANT SELECT ON VIEW SFC_PLUS_TRANSACTIONS_BASKETSIZE TO ROLE ANALYST_ROLE;
    GRANT SELECT ON TABLE SFC_RWDS_ACCOUNTS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_ACCOUNT_PROGRAMS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_API_KEYS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_BATCHES TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_BATCH_STATUS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_BATCH_SUMMARY TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_BATCH_TRANSACTIONS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_FM_INV TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_ITEMCODES TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PARTNERS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PARTNER_ACCOUNT TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PARTNER_BINS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PARTNER_CARD_NUMBERS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PARTNER_PROGRAMS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_PROGRAMS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_REPORTS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_REPORT_DETAILS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_REWARDS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_SCHEMA_MIGRATIONS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_TRANSACTIONS TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_TRANSACTION_TYPES TO ROLE BRONZE_VISITOR_ROLE;
   GRANT SELECT ON TABLE SFC_RWDS_TRANSFERS TO ROLE BRONZE_VISITOR_ROLE;
END;
$$;

CALL SFC_RWDS_CONTINOUS_GRANTING();

CREATE OR REPLACE PROCEDURE SFC_RWDS_TRUNCATE()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    TRUNCATE TABLE SFC_RWDS_ACCOUNTS;
    TRUNCATE TABLE SFC_RWDS_ACCOUNT_PROGRAMS;
    TRUNCATE TABLE SFC_RWDS_API_KEYS;
    TRUNCATE TABLE SFC_RWDS_BATCHES;
    TRUNCATE TABLE SFC_RWDS_BATCH_STATUS;
    TRUNCATE TABLE SFC_RWDS_BATCH_SUMMARY;
    TRUNCATE TABLE SFC_RWDS_BATCH_TRANSACTIONS;
    TRUNCATE TABLE SFC_RWDS_PARTNERS;
    TRUNCATE TABLE SFC_RWDS_PARTNER_ACCOUNT;
    TRUNCATE TABLE SFC_RWDS_PARTNER_BINS;
    TRUNCATE TABLE SFC_RWDS_PARTNER_CARD_NUMBERS;
    TRUNCATE TABLE SFC_RWDS_PROGRAMS;
    TRUNCATE TABLE SFC_RWDS_PARTNER_PROGRAMS;
    TRUNCATE TABLE SFC_RWDS_REPORTS;
    TRUNCATE TABLE SFC_RWDS_REPORT_DETAILS;
    TRUNCATE TABLE SFC_RWDS_SCHEMA_MIGRATIONS;
    TRUNCATE TABLE SFC_RWDS_TRANSACTIONS;
    TRUNCATE TABLE SFC_RWDS_TRANSACTION_TYPES;
    TRUNCATE TABLE SFC_RWDS_TRANSFERS;        
END;
$$;

CALL SFC_RWDS_TRUNCATE();

//INGESTION SESSION
CREATE OR REPLACE PROCEDURE SFC_RWDS_IIS()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    INSERT INTO SFC_RWDS_ACCOUNT_PROGRAMS (
    id,
    account_id,
    program_id,
    enabled,
    details,
    balance,
    balance_at,
    created_at,
    linked_at,
    deleted_at,
    program_account_number
)
SELECT
    id,
    account_id,
    program_id,
    enabled,
    TRY_PARSE_JSON(details) AS details,                 -- Convert details to VARIANT using TRY_PARSE_JSON
    balance,
    TO_TIMESTAMP_TZ(balance_at) AS balance_at,          -- Convert balance_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(created_at) AS created_at,          -- Convert created_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(linked_at) AS linked_at,            -- Convert linked_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(deleted_at) AS deleted_at,          -- Convert deleted_at to TIMESTAMP_TZ
    program_account_number
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."ACCOUNT_PROGRAMS";

INSERT INTO SFC_RWDS_ACCOUNTS (
    id,
    card_number,
    secret,
    first_name,
    last_name,
    middle_name,
    date_of_birth,
    email,
    mobile_number,
    mobile_number_country_code,
    created_at,
    type,
    currency,
    balance
)
SELECT
    id,
    card_number,
    secret,
    first_name,
    last_name,
    middle_name,
    date_of_birth,
    email,
    mobile_number,
    mobile_number_country_code,
    TO_TIMESTAMP_TZ(created_at) AS created_at,   -- Convert created_at to TIMESTAMP_TZ
    type,
    currency,
    balance
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."ACCOUNTS";

INSERT INTO SFC_RWDS_API_KEYS(
    id,
    partner_id,
    key,
    created_at,
    deleted_at
)
SELECT
    id,
    partner_id,
    key,
    TO_TIMESTAMP_TZ(created_at) AS created_at,  -- Convert created_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(deleted_at) AS deleted_at   -- Convert deleted_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."API_KEYS";


INSERT INTO SFC_RWDS_BATCH_STATUS (
    id,
    batch_id,
    code,
    status,
    source_ip_address,
    user_id,
    created_at
)
SELECT
    id,
    batch_id,
    code,
    status,
    source_ip_address,
    user_id,
    TO_TIMESTAMP_TZ(created_at) AS created_at  -- Convert created_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."BATCH_STATUS";

INSERT INTO SFC_RWDS_BATCH_SUMMARY (
    id,
    batch_id,
    ttl_cnt,
    ttl_pts,
    ern_cnt,
    ern_pts,
    ern_cntx,
    ern_ptsx,
    created_at
)
SELECT
    id,
    batch_id,
    ttl_cnt,
    ttl_pts,
    ern_cnt,
    ern_pts,
    ern_cntx,
    ern_ptsx,
    TO_TIMESTAMP_TZ(created_at) AS created_at  -- Convert created_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."BATCH_SUMMARY";

INSERT INTO SFC_RWDS_BATCH_TRANSACTIONS (
    id,
    batch_id,
    transaction_id,
    transaction_timestamp,
    short_id,
    partner_id,
    partner_name,
    account_id,
    first_name,
    last_name,
    mobile_number,
    mobile_number_country_code,
    card_number_mask,
    source,
    type,
    code,
    status,
    points,
    balance,
    reference_id,
    original_reference_id,
    details,
    properties,
    metadata,
    source_ip_address,
    "timestamp"
)
SELECT
    id,
    batch_id,
    transaction_id,
    TO_TIMESTAMP_TZ(transaction_timestamp) AS transaction_timestamp,  -- Convert transaction_timestamp to TIMESTAMP_TZ
    short_id,
    partner_id,
    partner_name,
    account_id,
    first_name,
    last_name,
    mobile_number,
    mobile_number_country_code,
    card_number_mask,
    source,
    type,
    code,
    status,
    points,
    balance,
    reference_id,
    original_reference_id,
    details,
    TRY_PARSE_JSON(properties) AS properties,  -- Convert properties to VARIANT using TRY_PARSE_JSON
    TRY_PARSE_JSON(metadata) AS metadata,      -- Convert metadata to VARIANT using TRY_PARSE_JSON
    source_ip_address,
    TO_TIMESTAMP_TZ("TIMESTAMP") AS "timestamp"  -- Convert TIMESTAMP to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."BATCH_TRANSACTIONS";

INSERT INTO SFC_RWDS_BATCHES (
    id,
    partner_id,
    filename,
    source_ip_address,
    user_id,
    created_at
)
SELECT
    id,
    partner_id,
    filename,
    source_ip_address,
    user_id,
    TO_TIMESTAMP_TZ(created_at) AS created_at  -- Convert created_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."BATCHES";

INSERT INTO SFC_RWDS_PARTNER_ACCOUNT(
    id,
    partner_id,
    account_id,
    created_at
)
SELECT
    id,
    partner_id,
    account_id,
    TO_TIMESTAMP_TZ(created_at) AS created_at  -- Convert created_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."PARTNER_ACCOUNTS";


INSERT INTO SFC_RWDS_PARTNER_BINS (
    id,
    partner_id,
    bin,
    created_at
)
SELECT
    id,
    partner_id,
    bin,
    TO_TIMESTAMP_TZ(created_at) AS created_at  -- Convert created_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."PARTNER_BINS";


INSERT INTO SFC_RWDS_PARTNER_CARD_NUMBERS(
    id,
    partner_bin_id,
    sequence,
    created_at
)
SELECT
    id,
    partner_bin_id,
    sequence,
    TO_TIMESTAMP_TZ(created_at) AS created_at  -- Convert created_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."PARTNER_CARD_NUMBERS";

INSERT INTO SFC_RWDS_PARTNER_PROGRAMS (
    id,
    partner_id,
    program_id,
    deleted_at,
    created_at
)
SELECT
    id,
    partner_id,
    program_id,
    TO_TIMESTAMP_TZ(deleted_at) AS deleted_at,  -- Convert deleted_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(created_at) AS created_at    -- Convert created_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."PARTNER_PROGRAMS";

INSERT INTO SFC_RWDS_PARTNERS (
    id,
    doing_business_as,
    phone_number,
    created_at,
    representative,
    email,
    balance,
    phone_number_country_code
)
SELECT
    id,
    doing_business_as,
    phone_number,
    TO_TIMESTAMP_TZ(created_at) AS created_at,  -- Convert created_at to TIMESTAMP_TZ
    representative,
    email,
    balance,
    phone_number_country_code
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."PARTNERS";

INSERT INTO SFC_RWDS_PROGRAMS (
    id,
    partner_id,
    program_code,
    name,
    description,
    parameters,
    enabled,
    created_at,
    deleted_at
)
SELECT
    id,
    partner_id,
    program_code,
    name,
    description,
    PARSE_JSON(parameters) AS parameters,  -- Convert parameters to VARIANT using PARSE_JSON
    enabled,
    TO_TIMESTAMP_TZ(created_at) AS created_at,  -- Convert created_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(deleted_at) AS deleted_at     -- Convert deleted_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."PROGRAMS";

INSERT INTO SFC_RWDS_REPORT_DETAILS (
    id,
    report_id,
    file_type,
    content_type,
    parameters,
    query,
    created_at
)
SELECT
    id,
    report_id,
    file_type,
    content_type,
    parameters,  -- Keep parameters as VARCHAR
    query,
    TO_TIMESTAMP_TZ(created_at) AS created_at  -- Convert created_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."REPORT_DETAILS";

INSERT INTO SFC_RWDS_REPORTS (
    id,
    type,
    name,
    description,
    display_name,
    index,
    created_at
)
SELECT
    id,
    type,
    name,
    description,
    display_name,
    index,
    TO_TIMESTAMP_TZ(created_at) AS created_at  -- Convert created_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."REPORTS";

INSERT INTO SFC_RWDS_SCHEMA_MIGRATIONS (
    version,
    dirty
)
SELECT
    version,
    dirty
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."SCHEMA_MIGRATIONS";

INSERT INTO SFC_RWDS_TRANSACTION_TYPES (
    id,
    name,
    description,
    position,
    created_at
)
SELECT
    id,
    name,
    description,
    position,
    TO_TIMESTAMP_TZ(created_at) AS created_at  -- Convert created_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."TRANSACTION_TYPES";

INSERT INTO SFC_RWDS_TRANSACTIONS (
    id,
    short_id,
    partner_id,
    account_id,
    card_number_mask,
    source,
    type,
    code,
    points,
    balance,
    reference_id,
    original_reference_id,
    properties,  -- Converted to VARIANT using PARSE_JSON
    metadata,    -- Converted to VARIANT using PARSE_JSON
    source_ip_address,
    "timestamp",
    details
)
SELECT
    id,
    short_id,
    partner_id,
    account_id,
    card_number_mask,
    source,
    type,
    code,
    points,
    balance,
    reference_id,
    original_reference_id,
    properties AS properties,  -- Convert properties to VARIANT
    metadata AS metadata,      -- Convert metadata to VARIANT
    source_ip_address,
    TO_TIMESTAMP_TZ(TIMESTAMP) AS "timestamp",  -- Convert timestamp to TIMESTAMP_TZ
    details
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."TRANSACTIONS";

INSERT INTO SFC_RWDS_TRANSFERS (
    id,
    source_transaction_id,
    target_transaction_id,
    currency,
    points,
    amount,
    "timestamp"
)
SELECT
    id,
    source_transaction_id,
    target_transaction_id,
    currency,
    points,
    amount,
    timestamp  -- Convert timestamp to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."TRANSFERS";

END;
$$;

CALL SFC_RWDS_IIS();