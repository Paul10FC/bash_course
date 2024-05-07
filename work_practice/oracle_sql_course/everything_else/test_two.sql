
SELECT contar_registros('T') AS total_registros FROM DUAL;

CREATE OR REPLACE FUNCTION contar_registros (tipo VARCHAR2)
RETURN NUMBER
IS
    total_registros NUMBER(4);
    count_opi NUMBER(4);
    count_oper NUMBER(4);
BEGIN
    total_registros:= 0;
    count_opi:= 0;
    count_oper:= 0;
    IF tipo = 'T' THEN
        SELECT COUNT(*) INTO count_opi FROM OPI_MX_MAE_USERS_DRO;
        SELECT COUNT(*) INTO count_oper FROM OPER;
        total_registros:= count_opi + count_oper;
    ELSIF tipo = 'L' THEN
        SELECT COUNT(*) INTO total_registros FROM OPI_MX_MAE_USERS_DRO;
    ELSIF tipo = 'R' THEN
        SELECT COUNT(*) INTO total_registros FROM OPER;
    END IF;
    RETURN total_registros;
END;
