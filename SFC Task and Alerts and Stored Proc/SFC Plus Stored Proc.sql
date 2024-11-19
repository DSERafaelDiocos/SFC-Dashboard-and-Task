CREATE OR REPLACE PROCEDURE SFC_PLUS_TRUNCATE()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    TRUNCATE TABLE "BPAY_SFCPLUS_access_codes";
    TRUNCATE TABLE "BPAY_SFCPLUS_accounts";
    TRUNCATE TABLE "BPAY_SFCPLUS_account_identity_verifications";
    TRUNCATE TABLE "BPAY_SFCPLUS_clients";
    TRUNCATE TABLE "BPAY_SFCPLUS_ewb_accounts";
    TRUNCATE TABLE "BPAY_SFCPLUS_payments";
    TRUNCATE TABLE "BPAY_SFCPLUS_pgmigrations";
    TRUNCATE TABLE "BPAY_SFCPLUS_refunds";
    TRUNCATE TABLE "BPAY_SFCPLUS_webhook_logs";
END;
$$;

CALL SFC_PLUS_TRUNCATE();

//INGESTION SESSION
CREATE OR REPLACE PROCEDURE SFC_PLUS_IIS()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    
    INSERT INTO "BPAY_SFCPLUS_access_codes" (
    id,
    access_code,
    starts_at,
    expires_at,
    created_at,
    updated_at,
    deleted_at
)
SELECT 
    id,
    access_code,
    TO_TIMESTAMP_TZ(starts_at) AS starts_at,  -- Convert to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(expires_at) AS expires_at,  -- Convert to TIMESTAMP_TZ
    COALESCE(TO_TIMESTAMP_TZ(created_at), CURRENT_TIMESTAMP()) AS created_at,  -- Handle missing created_at with default
    TO_TIMESTAMP_TZ(updated_at) AS updated_at,  -- Convert to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(deleted_at) AS deleted_at  -- Convert to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."ACCESS_CODES";

INSERT INTO "BPAY_SFCPLUS_account_identity_verifications" 
(
    id,
    account_id,
    session_url,
    session_token,
    status,
    decision,
    expires_at,
    created_at,
    updated_at,
    deleted_at
)
SELECT 
    id,  -- Directly inserting id as VARCHAR
    account_id,  -- Directly inserting account_id as VARCHAR
    session_url,  -- Directly inserting session_url as VARCHAR
    session_token,  -- Directly inserting session_token as VARCHAR
    status,  -- Directly inserting status as VARCHAR
    decision,  -- Using PARSE_JSON to convert decision to VARIANT
    TO_TIMESTAMP_TZ(expires_at),  -- Converting expires_at to TIMESTAMP_TZ
    COALESCE(TO_TIMESTAMP_TZ(created_at), CURRENT_TIMESTAMP),  -- Using TO_TIMESTAMP_TZ for created_at and defaulting to CURRENT_TIMESTAMP if NULL
    TO_TIMESTAMP_TZ(updated_at),  -- Converting updated_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(deleted_at)  -- Converting deleted_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."ACCOUNT_IDENTITY_VERIFICATIONS"; -- Specifying source schema and table

INSERT INTO "BPAY_SFCPLUS_accounts" 
(
    id, talino_id, first_name, middle_name, last_name, email_address, 
    mobile_number_country_code, mobile_number, birth_date, state_address, 
    terms_and_conditions, created_at, updated_at, deleted_at, rewards_id, 
    tax_number, qrpay_id, zip_code
) 
SELECT 
    id, talino_id, first_name, middle_name, last_name, email_address, 
    mobile_number_country_code, mobile_number, birth_date, state_address, 
    terms_and_conditions, 
    COALESCE(TO_TIMESTAMP_TZ(created_at), CURRENT_TIMESTAMP()),  -- Converting created_at to TIMESTAMP_TZ with a fallback to CURRENT_TIMESTAMP
    TO_TIMESTAMP_TZ(updated_at),  -- Converting updated_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(deleted_at),  -- Converting deleted_at to TIMESTAMP_TZ
    rewards_id, tax_number, qrpay_id, zip_code 
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."ACCOUNTS";

INSERT INTO "BPAY_SFCPLUS_clients" 
(
    id, secret, status, created_at, updated_at, deleted_at, name
) 
SELECT 
    id, secret, status, 
    COALESCE(TO_TIMESTAMP_TZ(created_at), CURRENT_TIMESTAMP()),  -- Converting created_at to TIMESTAMP_TZ with a fallback to CURRENT_TIMESTAMP
    TO_TIMESTAMP_TZ(updated_at),  -- Converting updated_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(deleted_at),  -- Converting deleted_at to TIMESTAMP_TZ
    name 
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."CLIENTS";

INSERT INTO "BPAY_SFCPLUS_ewb_accounts" 
(
    id, account_id, application_id, case_number, status, 
    account_number, customer_number, auth_first_name, 
    auth_last_name, auth_email_address, auth_phone_number, 
    created_at, updated_at, deleted_at
) 
SELECT 
    id, account_id, application_id, case_number, status, 
    account_number, customer_number, auth_first_name, 
    auth_last_name, auth_email_address, auth_phone_number, 
    COALESCE(TO_TIMESTAMP_TZ(created_at), CURRENT_TIMESTAMP()),  -- Converting created_at to TIMESTAMP_TZ with a fallback to CURRENT_TIMESTAMP
    TO_TIMESTAMP_TZ(updated_at),  -- Converting updated_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(deleted_at)   -- Converting deleted_at to TIMESTAMP_TZ
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."EWB_ACCOUNTS";

INSERT INTO "BPAY_SFCPLUS_payments" 
(
    id, client_id, account_id, reference_id, currency, 
    amount, status, reason, barcode, 
    initiated_at, processed_at, partially_refunded_at, 
    channel_reference_id, channel_error, metadata, 
    fully_refunded_at, particulars, properties
) 
SELECT 
    id, client_id, account_id, reference_id, currency, 
    amount, status, reason, barcode, 
    COALESCE(TO_TIMESTAMP_TZ(initiated_at), CURRENT_TIMESTAMP()),  -- Converting initiated_at to TIMESTAMP_TZ with a fallback to CURRENT_TIMESTAMP
    TO_TIMESTAMP_TZ(processed_at),   -- Converting processed_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(partially_refunded_at),  -- Converting partially_refunded_at to TIMESTAMP_TZ
    channel_reference_id, 
    channel_error,
    metadata,  -- Using TRY_PARSE_JSON for metadata to convert to VARIANT
    TO_TIMESTAMP_TZ(fully_refunded_at),  -- Converting fully_refunded_at to TIMESTAMP_TZ
    particulars,  -- Using TRY_PARSE_JSON for particulars to convert to VARIANT
    properties  -- Using TRY_PARSE_JSON for properties to convert to VARIANT
    -- TRY_PARSE_JSON(metadata),  -- Using TRY_PARSE_JSON for metadata to convert to VARIANT
    -- TO_TIMESTAMP_TZ(fully_refunded_at),  -- Converting fully_refunded_at to TIMESTAMP_TZ
    -- TRY_PARSE_JSON(particulars),  -- Using TRY_PARSE_JSON for particulars to convert to VARIANT
    -- TRY_PARSE_JSON(properties)  -- Using TRY_PARSE_JSON for properties to convert to VARIANT
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."PAYMENTS";

INSERT INTO "BPAY_SFCPLUS_pgmigrations" 
(
    id, name, run_on
) 
SELECT 
    id, 
    name, 
    COALESCE(TO_TIMESTAMP_TZ(run_on), CURRENT_TIMESTAMP())  -- Converting run_on to TIMESTAMP_TZ with a fallback to CURRENT_TIMESTAMP
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."PGMIGRATIONS";

INSERT INTO "BPAY_SFCPLUS_refunds" 
(
    id, 
    payment_id, 
    amount, 
    status, 
    created_at, 
    updated_at, 
    deleted_at
) 
SELECT 
    id, 
    payment_id, 
    amount, 
    status, 
    TO_TIMESTAMP_TZ(created_at),  -- Converting created_at to TIMESTAMP_TZ
    updated_at, 
    deleted_at 
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."REFUNDS";

INSERT INTO "BPAY_SFCPLUS_webhook_logs" 
(
    id, 
    reference_id, 
    type, 
    from_ip, 
    req_path, 
    req_headers, 
    req_payload, 
    res_headers, 
    res_payload, 
    res_status, 
    received_at, 
    responded_at
) 
SELECT 
    id, 
    reference_id, 
    type, 
    from_ip, 
    req_path, 
    req_headers,  -- Converting req_headers to VARIANT
    req_payload,  -- Converting req_payload to VARIANT
    res_headers,  -- Converting res_headers to VARIANT
    PARSE_JSON(res_payload),  -- Converting res_payload to VARIANT
    -- PARSE_JSON(req_headers),  -- Converting req_headers to VARIANT
    -- PARSE_JSON(req_payload),  -- Converting req_payload to VARIANT
    -- PARSE_JSON(res_headers),  -- Converting res_headers to VARIANT
    -- PARSE_JSON(res_payload),  -- Converting res_payload to VARIANT
    res_status, 
    TO_TIMESTAMP_TZ(received_at),  -- Converting received_at to TIMESTAMP_TZ
    responded_at 
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."WEBHOOK_LOGS";
    
END;
$$;

CALL SFC_PLUS_IIS();