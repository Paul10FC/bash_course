CREATE OR REPLACE PACKAGE BODY bank_package 
AS

    FUNCTION insert_customer(sequence NUMBER, name VARCHAR2, last_name VARCHAR2, age NUMBER)
        RETURN NUMBER
    IS
        return_code NUMBER;
    BEGIN
CREATE OR REPLACE PACKAGE BODY bank_package 
AS

    FUNCTION insert_customer(sequence NUMBER, name VARCHAR2, last_name VARCHAR2, age NUMBER)
        RETURN NUMBER
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        return_code NUMBER;
    BEGIN
        INSERT INTO OPICS_CLIENT_PRACTICE VALUES(sequence, name, last_name, age);
        COMMIT;
        return_code := 0;
        RETURN return_code;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            return_code := 10;
            RETURN return_code;
        WHEN OTHERS THEN
            return_code := 20;
            dbms_output.put_line('Error: ' || SQLERRM);
            RETURN return_code;
    END insert_customer;

 ------------------------------------------------------------------------------------

    FUNCTION update_customer(sequence NUMBER, name VARCHAR2, last_name VARCHAR2, age NUMBER)
        RETURN NUMBER
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        return_code NUMBER := 0;
    BEGIN
        UPDATE OPICS_CLIENT_PRACTICE
        SET nombre = name,
            apellido = last_name,
            edad = age
        WHERE secuencia = sequence;
        COMMIT;
        RETURN return_code;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            return_code := 10;
            RETURN return_code;
        WHEN OTHERS THEN
            return_code := 20;
            RETURN return_code;
            dbms_output.put_line('Error: ' || SQLERRM);
    END update_customer;

 ------------------------------------------------------------------------------------

    FUNCTION delete_customer(sequence NUMBER)
        RETURN NUMBER
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        return_code NUMBER := 0;
    BEGIN
        DELETE FROM OPICS_CLIENT_PRACTICE WHERE secuencia = sequence;
        COMMIT;
        RETURN return_code;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            return_code := 10;
            RETURN return_code;
        WHEN OTHERS THEN
            return_code := 20;
            dbms_output.put_line('Error: ' || SQLERRM);
            RETURN return_code;
    END delete_customer;

--------------------PAYMENTS----------------------------------------------------------------

    FUNCTION insert_payment(sequence NUMBER, amount NUMBER, interest_rate NUMBER, desc_mov VARCHAR2, start_date DATE, end_date DATE)
        RETURN NUMBER
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        return_code NUMBER := 0;
    BEGIN

        INSERT INTO OPICS_MX_MOV_PRACTICE VALUES(
            sequence, 
            amount, 
            interest_rate, 
            ((interest_rate * amount) / 100),
            desc_mov, 
            start_date,
            end_date,
            TO_CHAR(SYSDATE, 'HH24:MI'), 
            SYSDATE
        );
        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            return_code := 20;
            RETURN return_code;
            dbms_output.put_line('Error: ' || SQLERRM);

        RETURN return_code;
    END insert_payment;

------------------------------------------------------------------------------------

    FUNCTION update_payment(sequence NUMBER, amount NUMBER, interest_rate NUMBER, desc_mov VARCHAR2, start_date DATE, end_date DATE)
        RETURN NUMBER
    IS
        return_code NUMBER := 0;
    BEGIN

    -- UPDATE POR TODO

        UPDATE OPICS_MX_MOV_PRACTICE
        SET monto = amount,
            tasa = interest_rate,
            desc_movimiento = desc_mov,
            fecha_inicio = start_date,
            fecha_fin = end_date,
            fecha_actualizacion = SYSDATE
        WHERE secuencia = sequence;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            return_code := 10;
        WHEN OTHERS THEN
            return_code := 20;
            dbms_output.put_line('Error: ' || SQLERRM);
        RETURN return_code;

    END update_payment;

------------------------------------------------------------------------------------

    FUNCTION delete_payment(sequence NUMBER)
        RETURN NUMBER
    IS
        return_code NUMBER := 0;
    BEGIN

        DELETE FROM OPICS_MX_MOV_PRACTICE WHERE OPICS_MX_MOV_PRACTICE.secuencia = sequence;
        RETURN return_code;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            return_code := 10;
            RETURN return_code;
        WHEN OTHERS THEN
            return_code := 20;
            dbms_output.put_line('Error: ' || SQLERRM);
            RETURN return_code;
    END delete_payment;

---------------PROCEDURES--------------------------------------------------------------------


    PROCEDURE payment_interest_calculate(sequence NUMBER)
    IS
        -- Definir longitud
        new_interest_amount NUMBER;
        interest_amount OPICS_MX_MOV_PRACTICE.int_monto%TYPE;
        actual_interest_amount NUMBER;
        days_passed NUMBER;
        amount OPICS_MX_MOV_PRACTICE.monto%TYPE;
        interest_rate OPICS_MX_MOV_PRACTICE.tasa%TYPE;
        is_payment_on_time BOOLEAN;
        start_date OPICS_MX_MOV_PRACTICE.fecha_inicio%TYPE;
        end_date OPICS_MX_MOV_PRACTICE.fecha_fin%TYPE;
        today DATE := SYSDATE;
    BEGIN
        -- Comilla simple
        SELECT fecha_inicio, fecha_fin, monto, tasa, int_monto
        INTO start_date, end_date, amount, interest_rate, interest_amount
        FROM OPICS_MX_MOV_PRACTICE 
        WHERE OPICS_MX_MOV_PRACTICE.secuencia = sequence;

        days_passed := end_date - today;
        is_payment_on_time := days_passed >= 0;
        
        IF NOT is_payment_on_time THEN
            new_interest_amount := (amount + interest_amount) * interest_rate * days_passed;
            UPDATE OPICS_MX_MOV_PRACTICE SET int_monto = new_interest_amount WHERE secuencia = sequence;

            dbms_output.put_line('The new interest is ' || new_interest_amount);

        ELSE 
            dbms_output.put_line('This payment is on time');
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('There is any movement with this sequenece');
        WHEN OTHERS THEN
            dbms_output.put_line('Ups! An error has ocurred');
    END payment_interest_calculate;

-------------------------------------------------------------------------------------------------------------    

    PROCEDURE view_payments(pag_to_watch NUMBER)
    IS
        sequence OPICS_MX_MOV_PRACTICE.secuencia%TYPE;
        amount OPICS_MX_MOV_PRACTICE.monto%TYPE;
        interest_rate OPICS_MX_MOV_PRACTICE.tasa%TYPE;
        interest_amount OPICS_MX_MOV_PRACTICE.int_monto%TYPE;
        desc_mov OPICS_MX_MOV_PRACTICE.desc_movimiento%TYPE;
        start_date OPICS_MX_MOV_PRACTICE.fecha_inicio%TYPE;
        end_date OPICS_MX_MOV_PRACTICE.fecha_fin%TYPE;
        hour OPICS_MX_MOV_PRACTICE.hora%TYPE;
        update_date OPICS_MX_MOV_PRACTICE.fecha_actualizacion%TYPE;
        rows_to_exclude NUMBER := CASE WHEN pag_to_watch = 1 THEN 1 ELSE (pag_to_watch * 10 - 10) END;
        CURSOR pag_query IS
            SELECT secuencia, monto, tasa, int_monto, desc_movimiento, fecha_inicio, fecha_fin, hora, fecha_actualizacion FROM OPICS_MX_MOV_PRACTICE
            ORDER BY secuencia
            OFFSET rows_to_exclude ROWS
            FETCH NEXT 10 ROWS ONLY;
    BEGIN
        IF pag_to_watch >= 1 THEN 
            OPEN pag_query;
            LOOP
              
                FETCH pag_query INTO sequence, amount, interest_rate, interest_amount, desc_mov, start_date, end_date, hour, update_date;
                EXIT WHEN pag_query%NOTFOUND;
                
                dbms_output.put_line('******************************************');
                dbms_output.put_line('Secuencia: ' || sequence);
                dbms_output.put_line('Monto: ' || amount);
                dbms_output.put_line('Tasa de interes: ' || interest_rate);
                dbms_output.put_line('Interes acumulado: ' || interest_amount);
                dbms_output.put_line('Desc movimiento: ' || desc_mov);
                dbms_output.put_line('Fecha de inicio ' || start_date);
                dbms_output.put_line('Fecha de finalizacion: ' || end_date);
                dbms_output.put_line('Hora: ' || hour);
                dbms_output.put_line('Fecha de actualizacion: ' || update_date);
                dbms_output.put_line('******************************************');
            END LOOP;
            CLOSE pag_query;
        ELSE
            dbms_output.put_line('You can not see the 0 pag!');
        END IF;
    END view_payments;

-------------------------------------------------------------------------------------------------------------
    
    PROCEDURE view_customers(pag_to_watch NUMBER)
    IS
        sequence OPICS_CLIENT_PRACTICE.secuencia%TYPE;
        name OPICS_CLIENT_PRACTICE.Nombre%TYPE;
        last_name OPICS_CLIENT_PRACTICE.apellido%TYPE;
        age OPICS_CLIENT_PRACTICE.edad%TYPE;
        rows_to_exclude NUMBER := CASE WHEN pag_to_watch = 1 THEN 1 ELSE (pag_to_watch * 10 - 10) END;
        CURSOR pag_query IS
            SELECT secuencia, nombre, apellido, edad
            FROM OPICS_CLIENT_PRACTICE
            ORDER BY secuencia
            OFFSET rows_to_exclude ROWS
            FETCH NEXT 10 ROWS ONLY;
    BEGIN
        IF pag_to_watch >= 1 THEN 
            OPEN pag_query;
            LOOP
              
                FETCH pag_query INTO sequence, name, last_name, age;
                EXIT WHEN pag_query%NOTFOUND;
                
                dbms_output.put_line('******************************************');
                dbms_output.put_line('Secuencia: ' || sequence);
                dbms_output.put_line('Nombre: ' || name);
                dbms_output.put_line('Apellido: ' || last_name);
                dbms_output.put_line('Edad:' || age);
                dbms_output.put_line('******************************************');
            END LOOP;
            CLOSE pag_query;
        ELSE
            dbms_output.put_line('You can not see the 0 pag!');
        END IF;
    END view_customers; 

END bank_package;