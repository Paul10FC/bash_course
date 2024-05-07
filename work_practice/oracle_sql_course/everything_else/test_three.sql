CREATE OR REPLACE FUNCTION generate_password (
    id VARCHAR2,
    branch CHAR,
    user_name VARCHAR2,
    profile_fk CHAR
)
    RETURN VARCHAR2
IS
    id_pass VARCHAR2(20);
    branch_pass VARCHAR2(20);
    user_pass VARCHAR2(20);
    profile_pass VARCHAR2(20);
    password VARCHAR2(100) := '';
    password_first_character CHAR(1);
    password_complete VARCHAR2(15) := '';
    len NUMBER := 0;
    done BOOLEAN := false;
    toggle_case BOOLEAN := true;
BEGIN
    WHILE NOT done LOOP
        len := CASE WHEN id IS NULL THEN 3 ELSE 1 END;
        id_pass := SUBSTR(REPLACE(id, ' ', ''), ROUND(dbms_random.value(1, LENGTH(id))), len);
        
        len := CASE WHEN branch IS NULL THEN 3 ELSE 1 END;
        branch_pass := SUBSTR(REPLACE(branch, ' ', ''), ROUND(dbms_random.value(1, LENGTH(branch))), len);

        len := CASE WHEN user_name IS NULL THEN 3 ELSE 1 END;
        user_pass := SUBSTR(REPLACE(user_name, ' ', ''), ROUND(dbms_random.value(1, LENGTH(user_name))), len);
        
        len := CASE WHEN profile_fk IS NULL THEN 3 ELSE 1 END;
        profile_pass := SUBSTR(REPLACE(profile_fk, ' ', ''), ROUND(dbms_random.value(1, LENGTH(profile_fk))), len);

        password := password || id_pass || branch_pass || user_pass || profile_pass; 
        
        IF LENGTH(password) >= 15 THEN
            done := true;
        END IF;

    END LOOP;

    password_first_character := SUBSTR(password, 1, 1);

    FOR i IN 1..15 LOOP
        IF toggle_case THEN
            password_complete := password_complete || UPPER(SUBSTR(password, i, 1));
            toggle_case := false;
        ELSE
            password_complete := password_complete || LOWER(SLUBSTR(password, i, 1));
            toggle_case := true;
        END IF;
    END LOOP;

    RETURN password_complete;
END;
;

