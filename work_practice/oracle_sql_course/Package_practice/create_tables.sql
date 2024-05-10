    CREATE TABLE OPICS_CLIENT_PRACTICE (
        secuencia NUMBER PRIMARY KEY NOT NULL,
        nombre VARCHAR2(50),
        apellido VARCHAR2(50),
        edad NUMBER
    );

    CREATE TABLE OPICS_MX_MOV_PRACTICE (
        id_movement NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        secuencia NUMBER NOT NULL,
        monto NUMBER NOT NULL,
        tasa NUMBER NOT NULL,
        int_monto NUMBER NOT NULL,
        desc_movimiento VARCHAR2(100),
        fecha_inicio DATE NOT NULL,
        fecha_fin DATE NOT NULL,
        hora VARCHAR2(100),
        fecha_actualizacion DATE,
        FOREIGN KEY (secuencia) REFERENCES OPICS_CLIENT_PRACTICE(secuencia
    );