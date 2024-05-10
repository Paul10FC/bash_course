create or replace package bank_package as
    --------------------------------------CRUD Customers----------------------------------------------------------------------------------------
    function insert_customer(sequence NUMBER, name VARCHAR2, last_name VARCHAR2, age NUMBER)
    return number;
    function update_customer(sequence NUMBER, name VARCHAR2, last_name VARCHAR2, age NUMBER)
    return number;
    function delete_customer(sequence NUMBER)
    return number;
    --------------------------------------CRUD Movements----------------------------------------------------------------------------------------
    function insert_payment(sequence NUMBER, amount NUMBER, interest_rate NUMBER, desc_mov VARCHAR2, start_date DATE, end_date DATE)
    return number;
    function update_payment(sequence NUMBER, amount NUMBER, interest_rate NUMBER, desc_mov VARCHAR2, start_date DATE, end_date DATE)
    return number;
    function delete_payment(id NUMBER)
    return number;
    --------------------------------------Procedures---------------------------------------------------------------------------------------------
    procedure payment_interest_calculate(id NUMBER);
    procedure view_payments(pag_to_watch_payments NUMBER);
    procedure view_customers(pag_to_watch_customers NUMBER);
end bank_package;
;