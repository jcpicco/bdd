-- Insertar/actualizar tabla Reserva
CREATE OR REPLACE PROCEDURE INSERT_UPDATE_RESERVA(  COD_CLIENTE NUMBER,
                                                    COD_HOTEL NUMBER,
                                                    FECHA_INICIO DATE,
                                                    FECHA_FINAL DATE,
                                                    TIPO_HABITACION VARCHAR,
                                                    PRECIO_RESERVA FLOAT,
                                                    LOCALIDAD VARCHAR) IS

UPDATECOUNT NUMBER;

BEGIN
    IF (FECHA_INICIO < FECHA_FIN) THEN
        IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
            SELECT COUNT (*)
            INTO UPDATECOUNT
            FROM PAPEL1.HOTEL17
            WHERE   COD_CLIENTE = CID
                    AND COD_HOTEL = HID;
            
            IF(UPDATECOUNT > 0) THEN
                UPDATE PAPEL1.RESERVA17
                SET FECHA_FIN = FECHA_FINAL,
                    FECHA_INI = FECHA_INICIO,
                    TIPO_HAB = TIPO_HABITACION,
                    PRECIO = PRECIO_RESERVA
                WHERE   COD_CLIENTE = CID
                        AND COD_HOTEL = HID;
            ELSE
                INSERT INTO PAPEL1.RESERVA17
                VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FINAL, FECHA_INI, TIPO_HABITACION, PRECIO_RESERVA);
            ENDIF;
        
        ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
            SELECT COUNT (*)
            INTO UPDATECOUNT
            FROM PAPEL2.HOTEL36
            WHERE   COD_CLIENTE = CID
                    AND COD_HOTEL = HID;
            
            IF(UPDATECOUNT > 0) THEN
                UPDATE PAPEL2.RESERVA36
                SET FECHA_FIN = FECHA_FINAL,
                    FECHA_INI = FECHA_INICIO,
                    TIPO_HAB = TIPO_HABITACION,
                    PRECIO = PRECIO_RESERVA
                WHERE   COD_CLIENTE = CID
                        AND COD_HOTEL = HID;
            ELSE
                INSERT INTO PAPEL2.RESERVA36
                VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FINAL, FECHA_INI, TIPO_HABITACION, PRECIO_RESERVA);
            ENDIF;
        
        ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
            SELECT COUNT (*)
            INTO UPDATECOUNT
            FROM PAPEL3.HOTEL25
            WHERE   COD_CLIENTE = CID
                    AND COD_HOTEL = HID;
            
            IF(UPDATECOUNT > 0) THEN
                UPDATE PAPEL3.RESERVA25
                SET FECHA_FIN = FECHA_FINAL,
                    FECHA_INI = FECHA_INICIO,
                    TIPO_HAB = TIPO_HABITACION,
                    PRECIO = PRECIO_RESERVA
                WHERE   COD_CLIENTE = CID
                        AND COD_HOTEL = HID;
            ELSE
                INSERT INTO PAPEL3.RESERVA25
                VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FINAL, FECHA_INI, TIPO_HABITACION, PRECIO_RESERVA);
            ENDIF;
        
        ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
            SELECT COUNT (*)
            INTO UPDATECOUNT
            FROM PAPEL4.HOTEL48
            WHERE   COD_CLIENTE = CID
                    AND COD_HOTEL = HID;
            
            IF(UPDATECOUNT > 0) THEN
                UPDATE PAPEL4.RESERVA48
                SET FECHA_FIN = FECHA_FINAL,
                    FECHA_INI = FECHA_INICIO,
                    TIPO_HAB = TIPO_HABITACION,
                    PRECIO = PRECIO_RESERVA
                WHERE   COD_CLIENTE = CID
                        AND COD_HOTEL = HID;
            ELSE
                INSERT INTO PAPEL4.RESERVA48
                VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FINAL, FECHA_INI, TIPO_HABITACION, PRECIO_RESERVA);
            ENDIF;

        ELSE
            raise_application_error(20004,'LOCALIDAD NO VÁLIDA');
        ENDIF;
    ELSE
        raise_application_error(20005,'FECHA DE FIN NO PUEDE MAYOR A FECHA DE INICIO');
    ENDIF;
END;

-- Insertar/actualizar tabla Cliente
CREATE OR REPLACE PROCEDURE INSERT_UPDATE_CLIENTE(  COD_CLIENTE NUMBER,
                                                    NOMBRE_CLIENTE NUMBER,
                                                    DNI_CLIENTE NUMBER,
                                                    TLF_CLIENTE NUMBER) IS

CLIENTCOUNT NUMBER;

BEGIN
    SELECT COUNT (*)
    INTO CLIENTCOUNT
    FROM PAPEL1.CLIENTE
    WHERE   COD_CLIENTE = CID;

    IF(CLIENTCOUNT > 0) THEN
        UPDATE PAPEL1.CLIENTE
        SET NOMBRE = NOMBRE_CLIENTE,
            DNI = DNI_CLIENTE,
            TLF = TLF_CLIENTE
        WHERE COD_CLIENTE = CID;

        UPDATE PAPEL2.CLIENTE
        SET NOMBRE = NOMBRE_CLIENTE,
            DNI = DNI_CLIENTE,
            TLF = TLF_CLIENTE
        WHERE COD_CLIENTE = CID;

        UPDATE PAPEL3.CLIENTE
        SET NOMBRE = NOMBRE_CLIENTE,
            DNI = DNI_CLIENTE,
            TLF = TLF_CLIENTE
        WHERE COD_CLIENTE = CID;

        UPDATE PAPEL4.CLIENTE
        SET NOMBRE = NOMBRE_CLIENTE,
            DNI = DNI_CLIENTE,
            TLF = TLF_CLIENTE
        WHERE COD_CLIENTE = CID;

    ELSE
        INSERT INTO PAPEL1.CLIENTE
        VALUES (COD_CLIENTE, NOMBRE_CLIENTE, DNI_CLIENTE, TLF_CLIENTE);

        INSERT INTO PAPEL2.CLIENTE
        VALUES (COD_CLIENTE, NOMBRE_CLIENTE, DNI_CLIENTE, TLF_CLIENTE);

        INSERT INTO PAPEL3.CLIENTE
        VALUES (COD_CLIENTE, NOMBRE_CLIENTE, DNI_CLIENTE, TLF_CLIENTE);

        INSERT INTO PAPEL4.CLIENTE
        VALUES (COD_CLIENTE, NOMBRE_CLIENTE, DNI_CLIENTE, TLF_CLIENTE);
    ENDIF;
END;

-- Insertar/actualizar tabla Hotel
CREATE OR REPLACE PROCEDURE INSERT_UPDATE_HOTEL(COD_HOTEL NUMBER,
                                                COD_DIRECTOR NUMBER,
                                                NOMBRE_HOTEL VARCHAR,
                                                CIUDAD_HOTEL VARCHAR,
                                                PROVINCIA_HOTEL VARCHAR,
                                                NU_HAB NUMBER,
                                                NU_HAB2 NUMBER,
                                                LOCALIDAD VARCHAR) IS

UPDATECOUNT NUMBER;

BEGIN
    IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL1.HOTEL17
        WHERE   COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL1.HOTEL17
            SET EID = COD_DIRECTOR,
                NOMBRE = NOMBRE_HOTEL,
                CIUDAD = CIUDAD_HOTEL,
                PROVINCIA = PROVINCIA_HOTEL,
                N_HAB = NU_HAB,
                N_HAB2 = NU_HAB2
            WHERE   COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL1.HOTEL17
            VALUES (COD_HOTEL, COD_DIRECTOR, NOMBRE_HOTEL, CIUDAD_HOTEL, PROVINCIA_HOTEL, NU_HAB, NU_HAB2);
        ENDIF;
        
    ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL2.HOTEL36
        WHERE   COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL2.HOTEL36
            SET EID = COD_DIRECTOR,
                NOMBRE = NOMBRE_HOTEL,
                CIUDAD = CIUDAD_HOTEL,
                PROVINCIA = PROVINCIA_HOTEL,
        N_HAB = NU_HAB,
        N_HAB2 = NU_HAB2
            WHERE   COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL2.HOTEL36
            VALUES (COD_HOTEL, COD_DIRECTOR, NOMBRE_HOTEL, CIUDAD_HOTEL, PROVINCIA_HOTEL, NU_HAB, NU_HAB2);
        ENDIF;
        
    ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL3.HOTEL25
        WHERE   COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL3.HOTEL25
            SET EID = COD_DIRECTOR,
                NOMBRE = NOMBRE_HOTEL,
                CIUDAD = CIUDAD_HOTEL,
                PROVINCIA = PROVINCIA_HOTEL,
        N_HAB = NU_HAB,
        N_HAB2 = NU_HAB2
            WHERE   COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL3.HOTEL25
            VALUES (COD_HOTEL, COD_DIRECTOR, NOMBRE_HOTEL, CIUDAD_HOTEL, PROVINCIA_HOTEL, NU_HAB, NU_HAB2);
        ENDIF;
        
    ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL4.HOTEL48
        WHERE   COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL4.HOTEL48
            SET EID = COD_DIRECTOR,
                NOMBRE = NOMBRE_HOTEL,
                CIUDAD = CIUDAD_HOTEL,
                PROVINCIA = PROVINCIA_HOTEL,
        N_HAB = NU_HAB,
        N_HAB2 = NU_HAB2
            WHERE   COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL4.HOTEL48
            VALUES (COD_HOTEL, COD_DIRECTOR, NOMBRE_HOTEL, CIUDAD_HOTEL, PROVINCIA_HOTEL, NU_HAB, NU_HAB2);
        ENDIF;

    ELSE
        raise_application_error(20004,'LOCALIDAD NO VÁLIDA');
    ENDIF;
END;

-- Insertar/actualizar tabla Empleado
CREATE OR REPLACE PROCEDURE INSERT_UPDATE_EMPLEADO( COD_EMPLEADO NUMBER,
                                                    COD_HOTEL NUMBER,
                                                    NOMBRE_EMP VARCHAR,
                                                    DIRECCION_EMP VARCHAR,
							                        SALARIO_EMP NUMBER,
                                                    DNI_EMP NUMBER,
							                        TLF_EMP NUMBER,
						                            FECHA_INI_EMP DATE
                                                    LOCALIDAD VARCHAR) IS

UPDATECOUNT NUMBER;

BEGIN
    IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL1.EMPLADO17
        WHERE   COD_EMPLEADO = EID
        AND COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL1.EMPLADO17
            SET NOMBRE = NOMBRE_EMP,
                DIRECCION = DIRECCION_EMP,
                SALARIO = SALARIO_EMP,
        DNI = DNI_EMP,
        TLF = TLF_EMP,
                FECHA_INI = FECHA_INI_EMP
            WHERE   COD_EMPLEADO = EID
            AND COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL1.EMPLADO17
            VALUES (COD_EMPLEADO, COD_HOTEL, NOMBRE_EMP , DIRECCION_EMP, SALARIO_EMP, DNI_EMP, TLF_EMP, FECHA_INI_EMP);
        ENDIF;
    
    ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL2.EMPLEADO36
        WHERE   COD_EMPLEADO = EID
        AND COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL2.EMPLEADO36
            SET NOMBRE = NOMBRE_EMP,
                DIRECCION = DIRECCION_EMP,
                SALARIO = SALARIO_EMP,
        DNI = DNI_EMP,
        TLF = TLF_EMP,
                FECHA_INI = FECHA_INI_EMP
            WHERE   COD_EMPLEADO = EID
            AND COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL2.EMPLEADO36
            VALUES (COD_EMPLEADO, COD_HOTEL, NOMBRE_EMP , DIRECCION_EMP, SALARIO_EMP, DNI_EMP, TLF_EMP, FECHA_INI_EMP);
        ENDIF;
    
    ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL3.EMPLEADO25
        WHERE   COD_EMPLEADO = EID
        AND COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL3.EMPLEADO25
            SET NOMBRE = NOMBRE_EMP,
                DIRECCION = DIRECCION_EMP,
                SALARIO = SALARIO_EMP,
        DNI = DNI_EMP,
        TLF = TLF_EMP,
                FECHA_INI = FECHA_INI_EMP
            WHERE   COD_EMPLEADO = EID
            AND COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL3.EMPLEADO25
            VALUES (COD_EMPLEADO, COD_HOTEL, NOMBRE_EMP , DIRECCION_EMP, SALARIO_EMP, DNI_EMP, TLF_EMP, FECHA_INI_EMP);
        ENDIF;
    
    ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL4.EMPLEADO48
        WHERE   COD_EMPLEADO = EID
        AND COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL4.EMPLEADO48
            SET NOMBRE = NOMBRE_EMP,
                DIRECCION = DIRECCION_EMP,
                SALARIO = SALARIO_EMP,
        DNI = DNI_EMP,
        TLF = TLF_EMP,
                FECHA_INI = FECHA_INI_EMP
            WHERE   COD_EMPLEADO = EID
            AND COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL4.EMPLEADO48
            VALUES (COD_EMPLEADO, COD_HOTEL, NOMBRE_EMP , DIRECCION_EMP, SALARIO_EMP, DNI_EMP, TLF_EMP, FECHA_INI_EMP);
        ENDIF;

    ELSE
        raise_application_error(20004,'LOCALIDAD NO VÁLIDA');
    ENDIF;
END;

-- Insertar/actualizar tabla Articulo
CREATE OR REPLACE PROCEDURE INSERT_UPDATE_ARTICULO( COD_PROVEEDOR NUMBER,
                                                    COD_ARTICULO NUMBER,
                                                    NOMBRE_ARTICULO VARCHAR,
                                                    TIPO_ARTICULO VARCHAR) IS

ARTCOUNT NUMBER;

BEGIN
    SELECT COUNT (*)
    INTO ARTCOUNT
    FROM PAPEL1.ARTICULO
    WHERE   COD_PROVEEDOR = PID
            AND COD_ARTICULO = AID;

    IF(ARTCOUNT > 0) THEN
        UPDATE PAPEL1.ARTICULO
        SET NOMBRE = NOMBRE_ARTICULO,
            TIPO = TIPO_ARTICULO
        WHERE   COD_PROVEEDOR = PID
                AND COD_ARTICULO = AID;

        UPDATE PAPEL2.ARTICULO
        SET NOMBRE = NOMBRE_ARTICULO,
            TIPO = TIPO_ARTICULO
        WHERE   COD_PROVEEDOR = PID
                AND COD_ARTICULO = AID;

        UPDATE PAPEL3.ARTICULO
        SET NOMBRE = NOMBRE_ARTICULO,
            TIPO = TIPO_ARTICULO
        WHERE   COD_PROVEEDOR = PID
                AND COD_ARTICULO = AID;

        UPDATE PAPEL4.ARTICULO
        SET NOMBRE = NOMBRE_ARTICULO,
            TIPO = TIPO_ARTICULO
        WHERE   COD_PROVEEDOR = PID
                AND COD_ARTICULO = AID;
        
    ELSE
        INSERT INTO PAPEL1.ARTICULO
        VALUES (COD_PROVEEDOR, COD_ARTICULO, NOMBRE_ARTICULO, TIPO_ARTICULO);

        INSERT INTO PAPEL2.ARTICULO
        VALUES (COD_PROVEEDOR, COD_ARTICULO, NOMBRE_ARTICULO, TIPO_ARTICULO);

        INSERT INTO PAPEL3.ARTICULO
        VALUES (COD_PROVEEDOR, COD_ARTICULO, NOMBRE_ARTICULO, TIPO_ARTICULO);

        INSERT INTO PAPEL4.ARTICULO
        VALUES (COD_PROVEEDOR, COD_ARTICULO, NOMBRE_ARTICULO, TIPO_ARTICULO);
    ENDIF;
END;


-- Insertar/actualizar tabla Entrega
CREATE OR REPLACE PROCEDURE INSERT_UPDATE_ENTREGA(  COD_HOTEL NUMBER,
                                                    FECHA_EN DATE,
                                                    PRECIO_EN NUMBER,
							                        CANTIDAD_EN NUMBER,
                                                    LOCALIDAD VARCHAR) IS

UPDATECOUNT NUMBER;

BEGIN
    IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL1.ENTREGA17
        WHERE   COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL1.ENTREGA17
            SET FECHA = FECHA_EN,
                PRECIO = PRECIO_EN,
                CANTIDAD = CANTIDAD_EN
            WHERE   COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL1.ENTREGA17
            VALUES (COD_HOTEL, FECHA_EN , PRECIO_EN, CANTIDAD_EN);
        ENDIF;
    
    ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL2.ENTREGA36
        WHERE   COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL2.ENTREGA36
            SET FECHA = FECHA_EN,
                PRECIO = PRECIO_EN,
                CANTIDAD = CANTIDAD_EN
            WHERE   COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL2.ENTREGA36
            VALUES (COD_HOTEL, FECHA_EN , PRECIO_EN, CANTIDAD_EN);
        ENDIF;
    
    ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL3.ENTREGA25
        WHERE   COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL3.ENTREGA25
            SET FECHA = FECHA_EN,
                PRECIO = PRECIO_EN,
                CANTIDAD = CANTIDAD_EN
            WHERE   COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL3.ENTREGA25
            VALUES (COD_HOTEL, FECHA_EN , PRECIO_EN, CANTIDAD_EN);
        ENDIF;
    
    ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL4.ENTREGA48
        WHERE   COD_HOTEL = HID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL4.ENTREGA48
            SET FECHA = FECHA_EN,
                PRECIO = PRECIO_EN,
                CANTIDAD = CANTIDAD_EN
            WHERE   COD_HOTEL = HID;
        ELSE
            INSERT INTO PAPEL4.ENTREGA48
            VALUES (COD_HOTEL, FECHA_EN , PRECIO_EN, CANTIDAD_EN);
        ENDIF;

    ELSE
        raise_application_error(20004,'LOCALIDAD NO VÁLIDA');
    ENDIF;
END;

-- Insertar/actualizar tabla Proveedor
CREATE OR REPLACE PROCEDURE INSERT_UPDATE_PROVEEDOR(    COD_PROVEEDOR NUMBER,
                                                        NOMBRE_PRO VARCHAR,
                                                        PROVINCIA_PRO VARCHAR,
                                                        LOCALIDAD VARCHAR) IS

UPDATECOUNT NUMBER;

BEGIN
    IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén' OR LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL1.PROVEEDOR1
        WHERE   COD_PROVEEDOR = PID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL1.PROVEEDOR1
            SET NOMBRE = NOMBRE_PRO,
                PROVINCIA = PROVINCIA_PRO,
            WHERE   COD_PROVEEDOR = PID;

            UPDATE PAPEL4.PROVEEDOR1
            SET NOMBRE = NOMBRE_PRO,
                PROVINCIA = PROVINCIA_PRO,
            WHERE   COD_PROVEEDOR = PID;
        ELSE
            INSERT INTO PAPEL1.PROVEEDOR1
            VALUES (COD_PROVEEDOR, NOMVRE_PRO , PROVINCIA_PRO);

            INSERT INTO PAPEL4.PROVEEDOR1
            VALUES (COD_PROVEEDOR, NOMVRE_PRO , PROVINCIA_PRO);
        ENDIF;
    
    ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba' OR LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM PAPEL3.PROVEEDOR2
        WHERE   COD_PROVEEDOR = PID;
        
        IF(UPDATECOUNT > 0) THEN
            UPDATE PAPEL3.PROVEEDOR2
            SET NOMBRE = NOMBRE_PRO,
                PROVINCIA = PROVINCIA_PRO,
            WHERE   COD_PROVEEDOR = PID;

            UPDATE PAPEL2.PROVEEDOR2
            SET NOMBRE = NOMBRE_PRO,
                PROVINCIA = PROVINCIA_PRO,
            WHERE   COD_PROVEEDOR = PID;
        ELSE
            INSERT INTO PAPEL3.PROVEEDOR2
            VALUES (COD_PROVEEDOR, NOMVRE_PRO , PROVINCIA_PRO);

            INSERT INTO PAPEL2.PROVEEDOR2
            VALUES (COD_PROVEEDOR, NOMVRE_PRO , PROVINCIA_PRO);
        ENDIF;
    
    ELSE
        raise_application_error(20004,'LOCALIDAD NO VÁLIDA');
    ENDIF;
END;