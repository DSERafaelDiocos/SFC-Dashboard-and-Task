CREATE OR REPLACE TASK SFC_RWDS_TRUNCATE_TASK
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 30 * * * * UTC'
    AS
    BEGIN
            CALL SFC_RWDS_TRUNCATE();
    END;


-- CREATE OR REPLACE TASK ALTER_SESSION_RWDS_TASK
--     WAREHOUSE = COMPUTE_WH
--     AFTER SFC_RWDS_TRUNCATE_TASK --Minute, Hour, Daily
--     AS
--     ALTER SESSION SET TIMEZONE ='UTC';

CREATE OR REPLACE TASK SFC_RWDS_IIS_TASK
    WAREHOUSE = COMPUTE_WH
    AFTER SFC_RWDS_TRUNCATE_TASK --Minute, Hour, Daily
    AS
    BEGIN
        CALL SFC_RWDS_IIS();
    END;
    
//RESUME
ALTER TASK SFC_RWDS_IIS_TASK RESUME;
-- ALTER TASK ALTER_SESSION_RWDS_TASK RESUME;
//Root Task
ALTER TASK SFC_RWDS_TRUNCATE_TASK RESUME;

//SUSPEND
ALTER TASK SFC_RWDS_TRUNCATE_TASK SUSPEND;
ALTER TASK SFC_RWDS_IIS_TASK SUSPEND;
ALTER TASK ALTER_SESSION_RWDS_TASK SUSPEND;

DROP TASK SFC_RWDS_TRUNCATE_TASK;
DROP TASK SFC_RWDS_IIS_TASK;
DROP TASK ALTER_SESSION_RWDS_TASK;

SHOW TASKS;