SELECT bank_package.insert_customer(314, 'John', 'Walker', 33) AS RESULTADO FROM DUAL;
SELECT bank_package.update_customer(314, 'Kyle', 'Walker', 33) AS RESULTADO FROM DUAL;
SELECT bank_package.delete_customer(314) AS RESULTADO FROM DUAL;

SELECT bank_package.insert_payment(121, 1000, 10, 'A new movement', TO_DATE('13/05/2023', 'DD/MM/YYYY'), TO_DATE('13/03/2024', 'DD/MM/YYYY')) FROM DUAL;
SELECT bank_package.update_payment(121, 1000, 50, 'A new movement', TO_DATE('13/05/2023', 'DD/MM/YYYY'), TO_DATE('13/03/2024', 'DD/MM/YYYY')) FROM DUAL;
SELECT bank_package.delete_payment(121) FROM DUAL;

BEGIN
    bank_package.payment_interest_calculate(121);
END;

BEGIN
    bank_package.view_customers(1);
END;

BEGIN
    bank_package.view_payments(1);
END;

SELECT * FROM OPICS_MX_MOV_PRACTICE;

SELECT * FROM OPICS_CLIENT_PRACTICE;
