USE ROLE SECURITYADMIN;
CREATE USER JSELTZER -- Change the username
    PASSWORD = 'UserJSELTZER' -- Change to a generic password
    FIRST_NAME = 'Juvy' -- Change the first name
    LAST_NAME = 'Seltzer' -- Change the last name
    EMAIL = 'juvy.seltzer@seafoodcity.com' -- Change the email
    DEFAULT_NAMESPACE = SFC_ISDA.SFC_BRONZE -- Change to the desired default environment 
    DISPLAY_NAME = 'JSELTZER' -- Change the display name (copy the username field)
    DEFAULT_ROLE = SFC_EXECUTIVE_ROLE -- Change the role to the default role you wanted the user upon login
    DEFAULT_WAREHOUSE = COMPUTE_WH
    MUST_CHANGE_PASSWORD = TRUE;
    
CREATE USER JVENERACION -- Change the username
    PASSWORD = 'UserJVENERACION' -- Change to a generic password
    FIRST_NAME = 'Jonas' -- Change the first name
    LAST_NAME = 'Veneracion' -- Change the last name
    EMAIL = 'jonas.veneracion@seafoodcity.com' -- Change the email
    DEFAULT_NAMESPACE = SFC_ISDA.SFC_BRONZE -- Change to the desired default environment 
    DISPLAY_NAME = 'JVENERACION' -- Change the display name (copy the username field)
    DEFAULT_ROLE = SFC_EXECUTIVE_ROLE -- Change the role to the default role you wanted the user upon login
    DEFAULT_WAREHOUSE = COMPUTE_WH
    MUST_CHANGE_PASSWORD = TRUE;

CREATE USER EREBAYA -- Change the username
    PASSWORD = 'UserEREBAYA' -- Change to a generic password
    FIRST_NAME = 'Elewin' -- Change the first name
    LAST_NAME = 'Rebaya' -- Change the last name
    EMAIL = 'erebaya.seafoodcity@gmail.com' -- Change the email
    DEFAULT_NAMESPACE = SFC_ISDA.SFC_BRONZE -- Change to the desired default environment 
    DISPLAY_NAME = 'EREBAYA' -- Change the display name (copy the username field)
    DEFAULT_ROLE = SFC_EXECUTIVE_ROLE -- Change the role to the default role you wanted the user upon login
    DEFAULT_WAREHOUSE = COMPUTE_WH
    MUST_CHANGE_PASSWORD = TRUE;

CREATE USER MGO -- Change the username
    PASSWORD = 'UserMGO' -- Change to a generic password
    FIRST_NAME = 'Matthew' -- Change the first name
    LAST_NAME = 'Go' -- Change the last name
    EMAIL = 'matthew.go@seafoodcity.com' -- Change the email
    DEFAULT_NAMESPACE = SFC_ISDA.SFC_BRONZE -- Change to the desired default environment 
    DISPLAY_NAME = 'MGO' -- Change the display name (copy the username field)
    DEFAULT_ROLE = SFC_EXECUTIVE_ROLE -- Change the role to the default role you wanted the user upon login
    DEFAULT_WAREHOUSE = COMPUTE_WH
    MUST_CHANGE_PASSWORD = TRUE;

CREATE USER CGO -- Change the username
    PASSWORD = 'UserCGO' -- Change to a generic password
    FIRST_NAME = 'Cassy' -- Change the first name
    LAST_NAME = 'Go' -- Change the last name
    EMAIL = 'cassy.go@seafoodcity.com' -- Change the email
    DEFAULT_NAMESPACE = SFC_ISDA.SFC_BRONZE -- Change to the desired default environment 
    DISPLAY_NAME = 'CGO' -- Change the display name (copy the username field)
    DEFAULT_ROLE = SFC_EXECUTIVE_ROLE -- Change the role to the default role you wanted the user upon login
    DEFAULT_WAREHOUSE = COMPUTE_WH
    MUST_CHANGE_PASSWORD = TRUE;

-- CREATE USER ETENG
--     PASSWORD = 'UserETENG'
--     FIRST_NAME = 'Edwin'
--     LAST_NAME = 'Teng'
--     EMAIL = 'eteng@talinolabs.com'
--     DEFAULT_NAMESPACE = SFC_ISDA.SFC_BRONZE
--     DISPLAY_NAME = 'ETENG'
--     DEFAULT_ROLE = SFC_EXECUTIVE_ROLE
--     DEFAULT_WAREHOUSE = COMPUTE_WH
--     MUST_CHANGE_PASSWORD =TRUE;

SHOW USERS;
DROP USER CGO;
GRANT ROLE SFC_EXECUTIVE_ROLE TO USER JSELTZER;
GRANT ROLE SFC_EXECUTIVE_ROLE TO USER JVENERACION;
GRANT ROLE SFC_EXECUTIVE_ROLE TO USER EREBAYA;
GRANT ROLE SFC_EXECUTIVE_ROLE TO USER MGO;
GRANT ROLE SFC_EXECUTIVE_ROLE TO USER CGO;
