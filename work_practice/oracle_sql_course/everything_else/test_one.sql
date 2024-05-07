SELECT BR, DEALNO, SEQ, LIMITSEQ, DOCNUMBER, CCYAMT, discount_function(NVL(CCYAMT, 0)) AS DISCOUNT
FROM FADT
WHERE TO_DATE(FECHA, 'DD/MM/YY') = TO_DATE('26/09/18', 'DD/MM/YY');

CREATE OR REPLACE FUNCTION discount_function (amountToCalculateDiscount NUMBER)
    RETURN NUMBER
IS
    discount NUMBER;
BEGIN
    discount:= 0;

    IF amountToCalculateDiscount > 0 AND amountToCalculateDiscount <= 1000 THEN
            discount:= (amountToCalculateDiscount * .10);

    ELSIF amountToCalculateDiscount > 1001 AND amountToCalculateDiscount <= 10000 THEN
            discount:= (amountToCalculateDiscount * .20);

    ELSIF amountToCalculateDiscount > 10001 AND amountToCalculateDiscount <= 200000
            discount:= (amountToCalculateDiscount * .30);

    ELSIF amountToCalculateDiscount > 200001 THEN
            discount:= (amountToCalculateDiscount * .30);

    END IF;

    RETURN discount;
END;