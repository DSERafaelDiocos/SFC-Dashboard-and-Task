CREATE OR REPLACE PROCEDURE SFC_RWDS_TRUNCATE()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    TRUNCATE TABLE "BPAY_SFCRWDS_accounts";
    TRUNCATE TABLE "BPAY_SFCRWDS_account_programs";
    TRUNCATE TABLE "BPAY_SFCRWDS_api_keys";
    TRUNCATE TABLE "BPAY_SFCRWDS_batches";
    TRUNCATE TABLE "BPAY_SFCRWDS_batch_status";
    TRUNCATE TABLE "BPAY_SFCRWDS_batch_summary";
    TRUNCATE TABLE "BPAY_SFCRWDS_batch_transactions";
    TRUNCATE TABLE "BPAY_SFCRWDS_partners";
    TRUNCATE TABLE "BPAY_SFCRWDS_partner_accounts";
    TRUNCATE TABLE "BPAY_SFCRWDS_partner_bins";
    TRUNCATE TABLE "BPAY_SFCRWDS_partner_card_numbers";
    TRUNCATE TABLE "BPAY_SFCRWDS_programs";
    TRUNCATE TABLE "BPAY_SFCRWDS_partner_programs";
    TRUNCATE TABLE "BPAY_SFCRWDS_reports";
    TRUNCATE TABLE "BPAY_SFCRWDS_report_details";
    TRUNCATE TABLE "BPAY_SFCRWDS_schema_migrations";
    TRUNCATE TABLE "BPAY_SFCRWDS_transactions";
    TRUNCATE TABLE "BPAY_SFCRWDS_transaction_types";
    TRUNCATE TABLE "BPAY_SFCRWDS_transfers";        
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
    INSERT INTO "BPAY_SFCRWDS_account_programs" (
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

INSERT INTO "BPAY_SFCRWDS_accounts" (
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

INSERT INTO "BPAY_SFCRWDS_api_keys" (
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


INSERT INTO "BPAY_SFCRWDS_batch_status" (
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

INSERT INTO "BPAY_SFCRWDS_batch_summary" (
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

INSERT INTO "BPAY_SFCRWDS_batch_transactions" (
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

INSERT INTO "BPAY_SFCRWDS_batches" (
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

INSERT INTO "BPAY_SFCRWDS_partner_accounts" (
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


INSERT INTO "BPAY_SFCRWDS_partner_bins" (
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


INSERT INTO "BPAY_SFCRWDS_partner_card_numbers" (
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

INSERT INTO "BPAY_SFCRWDS_partner_programs" (
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

INSERT INTO "BPAY_SFCRWDS_partners" (
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

INSERT INTO "BPAY_SFCRWDS_programs" (
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

INSERT INTO "BPAY_SFCRWDS_report_details" (
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

INSERT INTO "BPAY_SFCRWDS_reports" (
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

INSERT INTO "BPAY_SFCRWDS_schema_migrations" (
    version,
    dirty
)
SELECT
    version,
    dirty
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCRWDS_DEV."SCHEMA_MIGRATIONS";

INSERT INTO "BPAY_SFCRWDS_transaction_types" (
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

INSERT INTO "BPAY_SFCRWDS_transactions" (
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

INSERT INTO "BPAY_SFCRWDS_transfers" (
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