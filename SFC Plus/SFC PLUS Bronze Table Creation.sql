-- SHOW PARAMETERS
-- ALTER SESSION SET TIMEZONE ='Asia/Manila'

CREATE OR REPLACE TABLE "BPAY_SFCPLUS_access_codes"
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    access_code VARCHAR NOT NULL,
    starts_at TIMESTAMP_TZ NOT NULL,
    expires_at TIMESTAMP_TZ NOT NULL,
    created_at TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_TZ,
    deleted_at TIMESTAMP_TZ
);

CREATE OR REPLACE TABLE "BPAY_SFCPLUS_account_identity_verifications"
(
    id VARCHAR NOT NULL,
    account_id VARCHAR NOT NULL,
    session_url VARCHAR NOT NULL,
    session_token VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    decision VARIANT,
    expires_at TIMESTAMP_TZ,
    created_at TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_TZ,
    deleted_at TIMESTAMP_TZ
);

CREATE OR REPLACE TABLE SFC_PLUS_ACCOUNTS
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    talino_id VARCHAR,
    first_name VARCHAR,
    middle_name VARCHAR,
    last_name VARCHAR,
    email_address VARCHAR,
    mobile_number_country_code VARCHAR NOT NULL,
    mobile_number VARCHAR NOT NULL,
    birth_date DATE,
    state_address VARCHAR,
    terms_and_conditions BOOLEAN,
    created_at TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_TZ,
    deleted_at TIMESTAMP_TZ,
    rewards_id VARCHAR,
    tax_number VARCHAR,
    qrpay_id VARCHAR(8),
    zip_code VARCHAR,
    prefix VARCHAR,
    suffix VARCHAR,
    place_of_birth VARCHAR,
    gender_code VARCHAR,
    civil_status_code VARCHAR
);

CREATE OR REPLACE TABLE "BPAY_SFCPLUS_clients"
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    secret VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    created_at TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_TZ,
    deleted_at TIMESTAMP_TZ,
    name VARCHAR
);

CREATE OR REPLACE TABLE "BPAY_SFCPLUS_ewb_accounts"
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    account_id VARCHAR NOT NULL,
    application_id VARCHAR NOT NULL,
    case_number VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    account_number VARCHAR,
    customer_number VARCHAR,
    auth_first_name VARCHAR,
    auth_last_name VARCHAR,
    auth_email_address VARCHAR,
    auth_phone_number VARCHAR,
    created_at TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_TZ,
    deleted_at TIMESTAMP_TZ
);

CREATE OR REPLACE TABLE "BPAY_SFCPLUS_payments"
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    client_id VARCHAR NOT NULL,
    account_id VARCHAR,
    reference_id VARCHAR NOT NULL,
    currency VARCHAR(3) NOT NULL,
    amount DOUBLE PRECISION NOT NULL,
    status VARCHAR NOT NULL,
    reason VARCHAR,
    barcode VARCHAR NOT NULL,
    initiated_at TIMESTAMP_TZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
    processed_at TIMESTAMP_TZ,
    partially_refunded_at TIMESTAMP_TZ,
    channel_reference_id VARCHAR,
    channel_error VARCHAR,
    metadata VARIANT,
    fully_refunded_at TIMESTAMP_TZ,
    particulars VARIANT,
    properties VARIANT
);

CREATE OR REPLACE TABLE "BPAY_SFCPLUS_pgmigrations"
(
    id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    run_on TIMESTAMP_TZ NOT NULL
);

CREATE OR REPLACE TABLE "BPAY_SFCPLUS_refunds"
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    payment_id VARCHAR NOT NULL,
    amount BIGINT NOT NULL,
    status VARCHAR NOT NULL,
    created_at TIMESTAMP_TZ NOT NULL,
    updated_at TIMESTAMP_TZ,
    deleted_at TIMESTAMP_TZ
);

CREATE OR REPLACE TABLE "BPAY_SFCPLUS_webhook_logs"
(
    id VARCHAR NOT NULL,
    reference_id VARCHAR,
    type VARCHAR NOT NULL,
    from_ip VARCHAR NOT NULL,
    req_path VARCHAR NOT NULL,
    req_headers VARIANT NOT NULL,
    req_payload VARIANT NOT NULL,
    res_headers VARIANT,
    res_payload VARIANT,
    res_status INTEGER,
    received_at TIMESTAMP_TZ NOT NULL,
    responded_at TIMESTAMP_TZ
);

CREATE OR REPLACE TABLE SFC_PLUS_REMITTANCES
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    recipient_id VARCHAR NOT NULL,
    exchange_rate VARCHAR NOT NULL,
    reference_id VARCHAR NOT NULL,
    transaction_fee FLOAT NOT NULL,
    landed_currency VARCHAR NOT NULL,
    landed_amount FLOAT NOT NULL,
    transaction_currency VARCHAR NOT NULL,
    paycode VARCHAR NOT NULL,
    transaction_amount FLOAT NOT NULL,
    properties VARIANT,
    snapshot VARIANT,
    status VARCHAR,
    message VARCHAR,
    purpose VARCHAR,
    reason VARCHAR,
    created_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP(),
    accepted_at TIMESTAMP_TZ,
    rejected_at TIMESTAMP_TZ,
    posted_at TIMESTAMP_TZ,
    landed_at TIMESTAMP_TZ,
    refunded_at TIMESTAMP_TZ,
    created_by VARCHAR,
    accepted_by VARCHAR,
    rejected_by VARCHAR,
    posted_by VARCHAR,
    metadata VARIANT,
    processor VARCHAR,
    remittance_number VARCHAR,
    remittance_remarks VARCHAR,
    processor_notes VARIANT,
    processor_events VARIANT,
    claimed_at TIMESTAMP_TZ,
    form_of_payment VARCHAR
);

CREATE OR REPLACE TABLE SFC_PLUS_REMIT_RECIPIENTS
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    sender_id VARCHAR NOT NULL,
    paycode VARCHAR NOT NULL,
    prefix VARCHAR,
    last_name VARCHAR NOT NULL,
    first_name VARCHAR NOT NULL,
    middle_name VARCHAR,
    suffix VARCHAR,
    address_line1 VARCHAR,
    address_line2 VARCHAR,
    address_city VARCHAR NOT NULL,
    address_state VARCHAR NOT NULL,
    address_country_code VARCHAR NOT NULL,
    address_zip_code VARCHAR,
    mobile_number VARCHAR NOT NULL,
    date_of_birth VARCHAR,
    relationship_to_sender VARCHAR,
    service_type VARCHAR NOT NULL,
    bank_name VARCHAR,
    bank_account_number VARCHAR,
    remit_message VARCHAR,
    remit_purpose VARCHAR NOT NULL,
    created_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_TZ,
    deleted_at TIMESTAMP_TZ,
    email_address VARCHAR,
    card_design VARCHAR
);

CREATE OR REPLACE TABLE SFC_PLUS_REMIT_SENDERS
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    account_id VARCHAR NOT NULL,
    present_address_line1 VARCHAR NOT NULL,
    present_address_line2 VARCHAR,
    present_address_city VARCHAR NOT NULL,
    present_address_state VARCHAR NOT NULL,
    present_address_country_code VARCHAR NOT NULL,
    present_address_zip_code VARCHAR NOT NULL,
    permanent_address_line1 VARCHAR NOT NULL,
    permanent_address_line2 VARCHAR,
    permanent_address_city VARCHAR NOT NULL,
    permanent_address_state VARCHAR NOT NULL,
    permanent_address_country_code VARCHAR NOT NULL,
    permanent_address_zip_code VARCHAR NOT NULL,
    nationality_code VARCHAR NOT NULL,
    occupation VARCHAR NOT NULL,
    source_of_income VARCHAR NOT NULL,
    employment_status VARCHAR NOT NULL,
    employer_name VARCHAR,
    employer_type VARCHAR,
    employer_contact_number VARCHAR,
    employer_address_line1 VARCHAR,
    employer_address_line2 VARCHAR,
    employer_address_city VARCHAR,
    employer_address_state VARCHAR,
    employer_address_country_code VARCHAR,
    employer_address_zip_code VARCHAR,
    created_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_TZ,
    deleted_at TIMESTAMP_TZ,
    agent_id VARCHAR,
    id_type VARCHAR,
    id_number VARCHAR,
    id_other_details VARCHAR,
    type VARCHAR,
    risk_status VARCHAR,
    override_next_transaction BOOLEAN
);

CREATE OR REPLACE TABLE SFC_PLUS_AGENTS
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    reference_id VARCHAR,
    agent_code VARCHAR,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    agent_iam_id VARCHAR,
    created_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_TZ,
    deleted_at TIMESTAMP_TZ,
    status VARCHAR NOT NULL, --character varying COLLATE pg_catalog."default" NOT NULL DEFAULT 'A'::character varying
    can_onboard BOOLEAN, --boolean DEFAULT false
    can_transact BOOLEAN,
    password VARCHAR,
    deactivated_at TIMESTAMP_TZ,
    reactivated_at TIMESTAMP_TZ,
    type VARCHAR,
    role VARCHAR
);

CREATE OR REPLACE TABLE SFC_PLUS_BLOCKED_ACCOUNTS
(
    mobile_number VARCHAR NOT NULL,
    reason VARCHAR
);

CREATE OR REPLACE TABLE SFC_PLUS_EXCHANGE_RATES
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(), --uuid NOT NULL DEFAULT uuid_generate_v4()
    type VARCHAR NOT NULL, --character varying COLLATE pg_catalog."default" NOT NULL
    source_currency VARCHAR NOT NULL,
    destination_currency VARCHAR NOT NULL,
    rate FLOAT NOT NULL, --double precision NOT NULL
    valid_from TIMESTAMP_TZ NOT NULL, --timestamp with time zone NOT NULL
    valid_until TIMESTAMP_TZ NOT NULL,
    updated_by VARCHAR
);

CREATE OR REPLACE TABLE SFC_PLUS_GLOBAL_CONFIGS
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    code VARCHAR NOT NULL,
    config VARCHAR,
    country_code VARCHAR,
    created_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_TZ
);

CREATE OR REPLACE TABLE SFC_PLUS_SFC_CANADA_LEGACY_REWARDS
(
    card_number VARCHAR NOT NULL,
    first_name VARCHAR,
    last_name VARCHAR,
    phone_area_code VARCHAR,
    phone_number VARCHAR,
    points NUMBER,--bigint DEFAULT 0,
    migrated_at TIMESTAMP_TZ,
    created_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP(),
    source VARCHAR
);

CREATE OR REPLACE TABLE SFC_PLUS_SFC_NORTH_AMERICA_AREA_CODES
(
    area_code VARCHAR NOT NULL,
    time_zone VARCHAR,
    region VARCHAR,
    country VARCHAR,
    region2 VARCHAR,
    created_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP()
);

CREATE OR REPLACE TABLE SFC_PLUS_PROCESSORS
(
    id VARCHAR NOT NULL DEFAULT UUID_STRING(),
    email VARCHAR NOT NULL,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    password VARCHAR NOT NULL,
    status VARCHAR NOT NULL,
    created_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_TZ,
    deactivated_at TIMESTAMP_TZ,
    reactivated_at TIMESTAMP_TZ,
    deleted_at TIMESTAMP_TZ
);