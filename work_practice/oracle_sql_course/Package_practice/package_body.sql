CREATE OR REPLACE PACKAGE BODY bank_package 
AS

    FUNCTION insert_customer(sequence NUMBER, name VARCHAR2, last_name VARCHAR2, age NUMBER)
        RETURN NUMBER
    IS
        return_code NUMBER;
    BEGIN
        INSERT INTO OPICS_CLIENT_PRACTICE VALUES(sequence, name, last_name, age);
        return_code := 0;
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            return_code := 10;
        WHEN OTHERS THEN
            return_code := 20;
        
        RETURN return_code;
    END insert_customer;

 ------------------------------------------------------------------------------------

    FUNCTION update_customer(sequence NUMBER, name VARCHAR2, last_name VARCHAR2, age NUMBER)
        RETURN NUMBER
    IS
        return_code NUMBER;
    BEGIN

        SELECT * FROM OPICS_CLIENT_PRACTICE WHERE secuencia = sequence;

        IF sql%notfound THEN
                
            -- Actualizar el nombre si se proporciona
            IF name IS NOT NULL THEN
                UPDATE OPICS_CLIENT_PRACTICE SET nombre = name WHERE secuencia = sequence;
            END IF;

            -- Actualizar el apellido si se proporciona
            IF last_name IS NOT NULL THEN
                UPDATE OPICS_CLIENT_PRACTICE SET apellido = last_name WHERE secuencia = sequence;
            END IF;

            -- Actualizar la edad si se proporciona
            IF age IS NOT NULL THEN
                UPDATE OPICS_CLIENT_PRACTICE SET edad = age WHERE secuencia = sequence;
            END IF;

            return_code := 0; -- Éxito en la actualización
        ELSE
            return_code := 10; -- La secuencia no existe
        END IF;

        RETURN return_code;

    END update_customer;

 ------------------------------------------------------------------------------------

    FUNCTION delete_customer(sequence NUMBER)
        RETURN NUMBER
    IS
        return_code NUMBER;
    BEGIN
        SELECT * FROM OPICS_CLIENT_PRACTICE WHERE secuencia = sequence;

        IF sql%notfound THEN
            return_code := 10;
        ELSE
            DELETE FROM OPICS_CLIENT_PRACTICE WHERE secuencia = sequence;
            return_code := 0;
        END IF;

        RETURN return_code;

    END delete_customer;

--------------------PAYMENTS----------------------------------------------------------------

    FUNCTION insert_payment(sequence NUMBER, amount NUMBER, interest_rate NUMBER, desc_mov VARCHAR2, start_date DATE, end_date DATE)
        RETURN NUMBER
    IS
        return_code NUMBER;
    BEGIN

        SELECT * FROM OPICS_MX_MOV_PRACTICE WHERE secuencia = sequence;

        IF sql%notfound THEN
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

            return_code := 0;
        ELSE
            return_code := 10;
        END IF;

        RETURN return_code;

    END insert_payment;

------------------------------------------------------------------------------------

    FUNCTION update_payment(sequence NUMBER, amount NUMBER, interest_rate NUMBER, desc_mov VARCHAR2, start_date DATE, end_date DATE)
        RETURN NUMBER
    IS
        return_code NUMBER;
    BEGIN

        SELECT * FROM OPICS_MX_MOV_PRACTICE WHERE secuencia = sequence;

        IF sql%notfound THEN
            return_code := 10;
        ELSE
        -- Actualizar el monto si se proporciona.
        IF amount IS NOT NULL THEN
            UPDATE OPICS_MX_MOV_PRACTICE SET monto = amount WHERE secuencia = sequence;
        END IF;

        -- Actualizar la tasa de interés si se proporciona.
        IF interest_rate IS NOT NULL THEN
            UPDATE OPICS_MX_MOV_PRACTICE SET tasa = interest_rate WHERE secuencia = sequence;
        END IF;

        -- Actualizar la descripción del movimiento si se proporciona.
        IF desc_mov IS NOT NULL THEN
            UPDATE OPICS_MX_MOV_PRACTICE SET desc_movimiento = desc_mov WHERE secuencia = sequence;
        END IF;

        -- Actualizar la fecha de inicio si se proporciona.
        IF start_date IS NOT NULL THEN
            UPDATE OPICS_MX_MOV_PRACTICE SET fecha_inicio = start_date WHERE secuencia = sequence;
        END IF;

        -- Actualizar la fecha de finalización si se proporciona.
        IF end_date IS NOT NULL THEN
            UPDATE OPICS_MX_MOV_PRACTICE SET fecha_fin = end_date WHERE secuencia = sequence;
        END IF;

        -- Actualizar la fecha de actualización.
        UPDATE OPICS_MX_MOV_PRACTICE SET fecha_actualizacion = SYSDATE WHERE secuencia = sequence;

            return_code := 0;
        END IF;

        RETURN return_code;

    END update_payment;

------------------------------------------------------------------------------------

    FUNCTION delete_payment(sequence NUMBER)
        RETURN NUMBER
    IS
        return_code NUMBER;
    BEGIN

        SELECT * FROM OPICS_MX_MOV_PRACTICE WHERE secuencia = sequence;

        IF sql%notfound THEN
            return_code := 10;
        ELSE
            DELETE FROM OPICS_MX_MOV_PRACTICE WHERE OPICS_MX_MOV_PRACTICE.secuencia = sequence;
            return_code := 0;
        END IF;

        RETURN return_code;

    END delete_payment;

---------------PROCEDURES--------------------------------------------------------------------


    PROCEDURE payment_interest_calculate(sequence NUMBER)
    IS
        new_interest_amount NUMBER;
        interest_amount NUMBER;
        actual_interest_amount NUMBER;
        days_passed NUMBER;
        amount NUMBER;
        interest_rate NUMBER;
        is_payment_on_time BOOLEAN;
        start_date DATE;
        end_date DATE;
        today DATE := SYSDATE;
    BEGIN
        SELECT * FROM OPICS_MX_MOV_PRACTICE WHERE OPICS_MX_MOV_PRACTICE.secuencia = sequence;

        IF sql%notfound THEN
            dbms_output.put_line("There isn't any payment with this sequence number");
        ELSE
            SELECT fecha_inicio, fecha_fin, monto, tasa, int_monto
            INTO start_date, end_date, amount, interest_rate, interest_amount
            FROM OPICS_MX_MOV_PRACTICE 
            WHERE OPICS_MX_MOV_PRACTICE.secuencia = sequence;

            days_passed := end_date - today;
            is_payment_on_time := days_passed >= 0;
            
            IF NOT is_payment_on_time THEN
                new_interest_amount := (amount + interest_amount) * interest_rate * days_passed;
                UPDATE OPICS_MX_MOV_PRACTICE SET int_monto = new_interest_amount WHERE secuencia = sequence;

                dbms_output.put_line("The new interest is " || new_interest_amount);

            ELSE 
                dbms_output.put_line("This payment is on time");
            END IF;
    END payment_interest_calculate;

-------------------------------------------------------------------------------------------------------------    

    PROCEDURE view_payments(pag_to_watch NUMBER)
    IS
        sequence NUMBER;
        amount NUMBER;
        interest_rate NUMBER;
        interest_amount NUMBER;
        desc_mov VARCHAR2;
        start_date DATE;
        end_date DATE;
        hour VARCHAR2;
        update_date DATE;
        rows_to_exclude NUMBER := CASE WHEN pag_to_watch = 1 THEN 1 ELSE (pag_to_watch * 10 - 10) END;
        CURSOR pag_query IS
            SELECT secuencia, monto, tasa, int_monto, desc_movimiento, fecha_inicio, fecha_fin, hora, fecha_actualizacion FROM OPICS_MX_MOV_PRACTICE
            ORDER BY secuencia
            OFFSET rows_to_exclude ROWS
            FETCH NEXT 10 ROWS ONLY
    BEGIN
        IF pag_to_watch >= 1 THEN 
            OPEN pag_query;
            LOOP
              
                FETCH pag_query INTO sequence, amount, interest_rate, interest_amount, desc_mov, start_date, end_date, hour, update_date;
                EXIT WHEN pag_query%NOTFOUND;
                
                dbms_output.put_line("******************************************");
                dbms_output.put_line("Secuencia: " || sequence);
                dbms_output.put_line("Monto: " || amount);
                dbms_output.put_line("Tasa de interes: " || interest_rate);
                dbms_output.put_line("Interes acumulado: " || interest_amount);
                dbms_output.put_line("Desc movimiento: " || desc_mov);
                dbms_output.put_line("Fecha de inicio " || start_date);
                dbms_output.put_line("Fecha de finalizacion: " || end_date);
                dbms_output.put_line("Hora: " || hour);
                dbms_output.put_line("Fecha de actualizacion: " || update_date);
                dbms_output.put_line("******************************************");
            END LOOP;
            CLOSE pag_query;
        ELSE
            dbms_output.put_line("You can't see the 0 pag!");
        END IF;
    END view_payments;

-------------------------------------------------------------------------------------------------------------
    
    PROCEDURE view_customer(pag_to_watch NUMBER)
    IS
        sequence NUMBER;
        name VARCHAR2;
        last_name VARCHAR2;
        age NUMBER;
        rows_to_exclude NUMBER := CASE WHEN pag_to_watch = 1 THEN 1 ELSE (pag_to_watch * 10 - 10) END;
        CURSOR pag_query IS
            SELECT secuencia, nombre, apellido, edad
            FROM OPICS_CLIENT_PRACTICE
            ORDER BY secuencia
            OFFSET rows_to_exclude ROWS
            FETCH NEXT 10 ROWS ONLY
    BEGIN
        IF pag_to_watch >= 1 THEN 
            OPEN pag_query;
            LOOP
              
                FETCH pag_query INTO sequence, name, last_name, age;
                EXIT WHEN pag_query%NOTFOUND;
                
                dbms_output.put_line("******************************************");
                dbms_output.put_line("Secuencia: " || sequence);
                dbms_output.put_line("Nombre: " || name);
                dbms_output.put_line("Apellido: " || last_name);
                dbms_output.put_line("Edad:" || age);
                dbms_output.put_line("******************************************");
            END LOOP;
            CLOSE pag_query;
        ELSE
            dbms_output.put_line("You can't see the 0 pag!");
        END IF;
    END view_customer; 

END bank_package;