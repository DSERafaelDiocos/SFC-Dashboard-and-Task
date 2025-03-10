CREATE OR REPLACE PROCEDURE SFC_PLUS_SET_TIMEZONE_AND_CALL_TASK()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
   -- Set the session time zone
   ALTER SESSION SET TIMEZONE = 'UTC';
   
   -- Call your actual procedure
   CALL SFC_PLUS_IIS();
   
   RETURN 'Task executed successfully with UTC time zone';
END;
$$;

CALL SFC_PLUS_SET_TIMEZONE_AND_CALL_TASK();
DROP PROCEDURE SFC_PLUS_SET_TIMEZONE_AND_CALL_TASK();

CREATE OR REPLACE PROCEDURE SFC_PLUS_CONTINOUS_GRANTING()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    GRANT SELECT ON TABLE SFC_PLUS_ACCESS_CODES TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_ACCOUNTS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_ACCOUNT_IDENTITY_VERIFICATIONS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_AGENTS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_AUTHORIZE_DOTNET_TRANSACTIONS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_BLOCKED_ACCOUNTS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_CLIENTS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_EWB_ACCOUNTS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_EXCHANGE_RATES TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_GLOBAL_CONFIGS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_PAYMENTS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_PGMIGRATIONS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_PROCESSORS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_REFUNDS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_REMITTANCES TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_REMIT_RECIPIENTS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_REMIT_SENDERS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_SFC_CANADA_LEGACY_REWARDS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_SFC_NORTH_AMERICA_AREA_CODES TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_WEBHOOK_LOGS TO ROLE SFC_EXECUTIVE_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_UPC TO ROLE ANALYST_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_STORES TO ROLE ANALYST_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_VENDORS TO ROLE ANALYST_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_ACCESS_CODES TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_ACCOUNTS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_ACCOUNT_IDENTITY_VERIFICATIONS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_AGENTS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_AUTHORIZE_DOTNET_TRANSACTIONS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_BLOCKED_ACCOUNTS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_CLIENTS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_EWB_ACCOUNTS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_EXCHANGE_RATES TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_GLOBAL_CONFIGS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_PAYMENTS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_PGMIGRATIONS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_PROCESSORS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_REFUNDS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_REMITTANCES TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_REMIT_RECIPIENTS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_REMIT_SENDERS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_SFC_CANADA_LEGACY_REWARDS TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_SFC_NORTH_AMERICA_AREA_CODES TO ROLE BRONZE_VISITOR_ROLE;
    GRANT SELECT ON TABLE SFC_PLUS_WEBHOOK_LOGS TO ROLE BRONZE_VISITOR_ROLE;
END;
$$;

CALL SFC_PLUS_CONTINOUS_GRANTING();
DROP PROCEDURE SFC_PLUS_CONTINOUS_GRANTING();
GRANT SELECT ON FUTURE TABLES IN SCHEMA SFC_PLUS_STORES TO ROLE ANALYST_ROLE;


CREATE OR REPLACE PROCEDURE SFC_PLUS_TRUNCATE()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    TRUNCATE TABLE SFC_PLUS_ACCESS_CODES;
    TRUNCATE TABLE SFC_PLUS_ACCOUNTS;
    TRUNCATE TABLE SFC_PLUS_ACCOUNT_IDENTITY_VERIFICATIONS;
    TRUNCATE TABLE SFC_PLUS_CLIENTS;
    TRUNCATE TABLE SFC_PLUS_EWB_ACCOUNTS;
    TRUNCATE TABLE SFC_PLUS_PAYMENTS;
    TRUNCATE TABLE SFC_PLUS_PGMIGRATIONS;
    TRUNCATE TABLE SFC_PLUS_REFUNDS;
    TRUNCATE TABLE SFC_PLUS_WEBHOOK_LOGS;
    TRUNCATE TABLE SFC_PLUS_REMITTANCES;
    TRUNCATE TABLE SFC_PLUS_REMIT_RECIPIENTS;
    TRUNCATE TABLE SFC_PLUS_REMIT_SENDERS;
    TRUNCATE TABLE SFC_PLUS_AGENTS;
    TRUNCATE TABLE SFC_PLUS_BLOCKED_ACCOUNTS;
    TRUNCATE TABLE SFC_PLUS_EXCHANGE_RATES;
    TRUNCATE TABLE SFC_PLUS_GLOBAL_CONFIGS;
    TRUNCATE TABLE SFC_PLUS_SFC_CANADA_LEGACY_REWARDS;
    TRUNCATE TABLE SFC_PLUS_SFC_NORTH_AMERICA_AREA_CODES;
    TRUNCATE TABLE SFC_PLUS_PROCESSORS;
END;
$$;

CALL SFC_PLUS_TRUNCATE();
DROP PROCEDURE SFC_PLUS_TRUNCATE();

//INGESTION SESSION
CREATE OR REPLACE PROCEDURE SFC_PLUS_IIS()
RETURNS STRING
LANGUAGE SQL
AS
$$
BEGIN
    
    INSERT INTO SFC_PLUS_ACCESS_CODES (
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

INSERT INTO SFC_PLUS_ACCOUNT_IDENTITY_VERIFICATIONS 
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

INSERT INTO SFC_PLUS_ACCOUNTS 
(
    id, talino_id, first_name, middle_name, last_name, email_address, 
    mobile_number_country_code, mobile_number, birth_date, state_address, 
    terms_and_conditions, created_at, updated_at, deleted_at, rewards_id, 
    tax_number, qrpay_id, zip_code, prefix, suffix, place_of_birth, gender_code,
    civil_status_code
) 
SELECT 
    id, talino_id, first_name, middle_name, last_name, email_address, 
    mobile_number_country_code, mobile_number, birth_date, state_address, 
    terms_and_conditions, 
    COALESCE(TO_TIMESTAMP_TZ(created_at), CURRENT_TIMESTAMP()),  -- Converting created_at to TIMESTAMP_TZ with a fallback to CURRENT_TIMESTAMP
    TO_TIMESTAMP_TZ(updated_at),  -- Converting updated_at to TIMESTAMP_TZ
    TO_TIMESTAMP_TZ(deleted_at),  -- Converting deleted_at to TIMESTAMP_TZ
    rewards_id, tax_number, qrpay_id, zip_code, prefix, suffix, place_of_birth, gender_code,
    civil_status_code
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."ACCOUNTS";

INSERT INTO SFC_PLUS_CLIENTS 
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

INSERT INTO SFC_PLUS_EWB_ACCOUNTS 
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

INSERT INTO SFC_PLUS_PAYMENTS 
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

INSERT INTO SFC_PLUS_PGMIGRATIONS 
(
    id, name, run_on
) 
SELECT 
    id, 
    name, 
    COALESCE(TO_TIMESTAMP_TZ(run_on), CURRENT_TIMESTAMP())  -- Converting run_on to TIMESTAMP_TZ with a fallback to CURRENT_TIMESTAMP
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."PGMIGRATIONS";

INSERT INTO SFC_PLUS_REFUNDS 
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

INSERT INTO SFC_PLUS_WEBHOOK_LOGS 
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
    res_payload,
    -- PARSE_JSON(res_payload),  -- Converting res_payload to VARIANT
    -- PARSE_JSON(req_headers),  -- Converting req_headers to VARIANT
    -- PARSE_JSON(req_payload),  -- Converting req_payload to VARIANT
    -- PARSE_JSON(res_headers),  -- Converting res_headers to VARIANT
    -- PARSE_JSON(res_payload),  -- Converting res_payload to VARIANT
    res_status, 
    TO_TIMESTAMP_TZ(received_at),  -- Converting received_at to TIMESTAMP_TZ
    responded_at 
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV."WEBHOOK_LOGS";

INSERT INTO SFC_PLUS_REMITTANCES 
(
    id,
    recipient_id,
    exchange_rate,
    reference_id,
    transaction_fee,
    landed_currency,
    landed_amount,
    transaction_currency,
    paycode,
    transaction_amount,
    properties,
    snapshot,
    status,
    message,
    purpose,
    reason,
    created_at,
    accepted_at,
    rejected_at,
    posted_at,
    landed_at,
    refunded_at,
    created_by,
    accepted_by,
    rejected_by,
    posted_by,
    metadata,
    processor,
    remittance_number,
    remittance_remarks,
    processor_notes,
    processor_events,
    claimed_at,
    form_of_payment
) 
SELECT 
    id,
    recipient_id,
    exchange_rate,
    reference_id,
    transaction_fee,
    landed_currency,
    landed_amount,
    transaction_currency,
    paycode,
    transaction_amount,
    properties,
    snapshot,
    status,
    message,
    purpose,
    reason,
    TO_TIMESTAMP_TZ(created_at),
    TO_TIMESTAMP_TZ(accepted_at),
    TO_TIMESTAMP_TZ(rejected_at),
    TO_TIMESTAMP_TZ(posted_at),
    TO_TIMESTAMP_TZ(landed_at),
    TO_TIMESTAMP_TZ(refunded_at),
    created_by,
    accepted_by,
    rejected_by,
    posted_by,
    metadata,
    processor,
    remittance_number,
    remittance_remarks,
    processor_notes,
    processor_events,
    TO_TIMESTAMP_TZ(claimed_at),
    form_of_payment
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV.REMITTANCES;

INSERT INTO SFC_PLUS_REMIT_RECIPIENTS
(
    id ,
    sender_id,
    paycode,
    prefix,
    last_name,
    first_name,
    middle_name,
    suffix,
    address_line1,
    address_line2,
    address_city,
    address_state,
    address_country_code,
    address_zip_code,
    mobile_number,
    date_of_birth,
    relationship_to_sender,
    service_type,
    bank_name,
    bank_account_number,
    remit_message,
    remit_purpose,
    created_at,
    updated_at,
    deleted_at,
    email_address,
    card_design
) 
SELECT 
    id,
    sender_id,
    paycode,
    prefix,
    last_name,
    first_name,
    middle_name,
    suffix,
    address_line1,
    address_line2,
    address_city,
    address_state,
    address_country_code,
    address_zip_code,
    mobile_number,
    date_of_birth,
    relationship_to_sender,
    service_type,
    bank_name,
    bank_account_number,
    remit_message,
    remit_purpose,
    TO_TIMESTAMP_TZ(created_at),
    TO_TIMESTAMP_TZ(updated_at),
    TO_TIMESTAMP_TZ(deleted_at),
    email_address,
    card_design
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV.REMIT_RECIPIENTS;

INSERT INTO SFC_PLUS_REMIT_SENDERS
(
    id,
    account_id,
    present_address_line1,
    present_address_line2,
    present_address_city,
    present_address_state,
    present_address_country_code,
    present_address_zip_code,
    permanent_address_line1,
    permanent_address_line2,
    permanent_address_city,
    permanent_address_state,
    permanent_address_country_code,
    permanent_address_zip_code,
    nationality_code,
    occupation,
    source_of_income,
    employment_status,
    employer_name,
    employer_type,
    employer_contact_number,
    employer_address_line1,
    employer_address_line2,
    employer_address_city,
    employer_address_state,
    employer_address_country_code,
    employer_address_zip_code,
    created_at,
    updated_at,
    deleted_at,
    agent_id,
    id_type,
    id_number,
    id_other_details,
    type,
    risk_status,
    override_next_transaction
) 
SELECT 
    id,
    account_id,
    present_address_line1,
    present_address_line2,
    present_address_city,
    present_address_state,
    present_address_country_code,
    present_address_zip_code,
    permanent_address_line1,
    permanent_address_line2,
    permanent_address_city,
    permanent_address_state,
    permanent_address_country_code,
    permanent_address_zip_code,
    nationality_code,
    occupation,
    source_of_income,
    employment_status,
    employer_name,
    employer_type,
    employer_contact_number,
    employer_address_line1,
    employer_address_line2,
    employer_address_city,
    employer_address_state,
    employer_address_country_code,
    employer_address_zip_code,
    TO_TIMESTAMP_TZ(created_at),
    TO_TIMESTAMP_TZ(updated_at),
    TO_TIMESTAMP_TZ(deleted_at),
    agent_id,
    id_type,
    id_number,
    id_other_details,
    type,
    risk_status,
    override_next_transaction
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV.REMIT_SENDERS;

INSERT INTO SFC_PLUS_AGENTS
(
    id,
    reference_id,
    agent_code,
    first_name,
    last_name,
    agent_iam_id,
    created_at,
    updated_at,
    deleted_at,
    status,
    can_onboard,
    can_transact,
    password,
    deactivated_at,
    reactivated_at,
    type,
    role
) 
SELECT 
    id,
    reference_id,
    agent_code,
    first_name,
    last_name,
    agent_iam_id,
    TO_TIMESTAMP_TZ(created_at),
    TO_TIMESTAMP_TZ(updated_at),
    TO_TIMESTAMP_TZ(deleted_at),
    status,
    can_onboard,
    can_transact,
    password,
    TO_TIMESTAMP_TZ(deactivated_at),
    TO_TIMESTAMP_TZ(reactivated_at),
    type,
    role 
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV.AGENTS;

INSERT INTO SFC_PLUS_BLOCKED_ACCOUNTS
(
    mobile_number,
    reason
) 
SELECT 
    mobile_number,
    reason
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV.BLOCKED_ACCOUNTS;

INSERT INTO SFC_PLUS_EXCHANGE_RATES
(
    id,
    type,
    source_currency,
    destination_currency,
    rate,
    valid_from,
    valid_until,
    updated_by
) 
SELECT 
    id,
    type,
    source_currency,
    destination_currency,
    rate,
    TO_TIMESTAMP_TZ(valid_from),
    TO_TIMESTAMP_TZ(valid_until),
    updated_by
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV.EXCHANGE_RATES;

INSERT INTO SFC_PLUS_GLOBAL_CONFIGS
(
    id,
    code,
    config,
    country_code,
    created_at,
    updated_at
) 
SELECT 
    id,
    code,
    config,
    country_code,
    TO_TIMESTAMP_TZ(created_at),
    TO_TIMESTAMP_TZ(updated_at)
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV.GLOBAL_CONFIGS;

INSERT INTO SFC_PLUS_SFC_CANADA_LEGACY_REWARDS
(
    card_number,
    first_name,
    last_name,
    phone_area_code,
    phone_number,
    points,
    migrated_at,
    created_at,
    source
) 
SELECT 
    card_number,
    first_name,
    last_name,
    phone_area_code,
    phone_number,
    points,
    TO_TIMESTAMP_TZ(migrated_at),
    TO_TIMESTAMP_TZ(created_at),
    source
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV.SFC_CANADA_LEGACY_REWARDS;

INSERT INTO SFC_PLUS_SFC_NORTH_AMERICA_AREA_CODES
(
    area_code,
    time_zone,
    region,
    country,
    region2,
    created_at
) 
SELECT 
    area_code,
    time_zone,
    region,
    country,
    region2,
    TO_TIMESTAMP_TZ(created_at)
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV.SFC_NORTH_AMERICA_AREA_CODES;

INSERT INTO SFC_PLUS_PROCESSORS
(
    id,
    email,
    first_name,
    last_name,
    password,
    status,
    created_at,
    updated_at,
    deactivated_at,
    reactivated_at,
    deleted_at
) 
SELECT 
    id,
    email,
    first_name,
    last_name,
    password,
    status,
    TO_TIMESTAMP_TZ(created_at),
    TO_TIMESTAMP_TZ(updated_at),
    TO_TIMESTAMP_TZ(deactivated_at),
    TO_TIMESTAMP_TZ(reactivated_at),
    TO_TIMESTAMP_TZ(deleted_at)
FROM 
    SFC_DEV_DATABASE.BAYANIPAY_SFCPLUS_DEV.PROCESSORS;
    
END;
$$;

CALL SFC_PLUS_IIS();
DROP PROCEDURE SFC_PLUS_IIS();




