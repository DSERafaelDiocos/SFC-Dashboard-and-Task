CREATE OR REPLACE TASK SFC_PLUS_TRUNCATE_TASK
    WAREHOUSE = COMPUTE_WH
    SCHEDULE = 'USING CRON 30 * * * * UTC'
    AS
    BEGIN
        CALL SFC_PLUS_TRUNCATE();
    END;;
            
CREATE OR REPLACE TASK ALTER_SESSION_TASK
    WAREHOUSE = COMPUTE_WH
    AFTER SFC_PLUS_TRUNCATE_TASK --Minute, Hour, Daily
    AS
    ALTER SESSION SET TIMEZONE ='UTC';

CREATE OR REPLACE TASK SFC_PLUS_IIS_TASK
    WAREHOUSE = COMPUTE_WH
    AFTER ALTER_SESSION_TASK --Minute, Hour, Daily
    AS
    BEGIN
        CALL SFC_PLUS_IIS();
    END;;

//RESUME
ALTER TASK SFC_PLUS_IIS_TASK RESUME;
ALTER TASK ALTER_SESSION_TASK RESUME;
//Root Task
ALTER TASK SFC_PLUS_TRUNCATE_TASK RESUME;

//SUSPEND 
ALTER TASK SFC_PLUS_TRUNCATE_TASK SUSPEND;
ALTER TASK SFC_PLUS_IIS_TASK SUSPEND;
ALTER TASK ALTER_SESSION_TASK SUSPEND;

SHOW TASKS;