-- Insertar tabla Hotel
CREATE OR REPLACE PROCEDURE INSERT_HOTEL(   COD_HOTEL NUMBER,
                                            COD_DIRECTOR NUMBER,
                                            NOMBRE_HOTEL VARCHAR,
                                            CIUDAD_HOTEL VARCHAR,
                                            PROVINCIA_HOTEL VARCHAR,
                                            NU_HAB NUMBER,
                                            NU_HAB2 NUMBER) IS

HCOUNT NUMBER;

BEGIN
    IF (PROVINCIA_HOTEL = 'Granada' OR PROVINCIA_HOTEL = 'Jaén') THEN
        INSERT INTO PAPEL1.HOTEL17
        VALUES (COD_HOTEL, COD_DIRECTOR, NOMBRE_HOTEL, CIUDAD_HOTEL, PROVINCIA_HOTEL, NU_HAB, NU_HAB2);
        
    ELSIF (PROVINCIA_HOTEL = 'Cádiz' OR PROVINCIA_HOTEL = 'Huelva') THEN
        INSERT INTO PAPEL2.HOTEL36
        VALUES (COD_HOTEL, COD_DIRECTOR, NOMBRE_HOTEL, CIUDAD_HOTEL, PROVINCIA_HOTEL, NU_HAB, NU_HAB2);
        
    ELSIF (PROVINCIA_HOTEL = 'Sevilla' OR PROVINCIA_HOTEL = 'Córdoba') THEN
        INSERT INTO PAPEL3.HOTEL25
        VALUES (COD_HOTEL, COD_DIRECTOR, NOMBRE_HOTEL, CIUDAD_HOTEL, PROVINCIA_HOTEL, NU_HAB, NU_HAB2);
        
    ELSIF (PROVINCIA_HOTEL = 'Málaga' OR PROVINCIA_HOTEL = 'Almería') THEN
        INSERT INTO PAPEL4.HOTEL48
        VALUES (COD_HOTEL, COD_DIRECTOR, NOMBRE_HOTEL, CIUDAD_HOTEL, PROVINCIA_HOTEL, NU_HAB, NU_HAB2);

    ELSE
        RAISE_APPLICATION_ERROR(-20021,'LOCALIDAD NO VÁLIDA');
    END IF;
END;
/

--6. Cambiar el director de un hotel. Esta operación debe servir también para nombrar
--director inicial de un hotel. Argumentos: Código de sucursal y código del nuevo (o
--del primer) director.
-- 8. Un empleado, al mismo tiempo, sólo puede ser director de un hotel.
CREATE OR REPLACE PROCEDURE UPDATE_DIRECTOR(    COD_HOTEL NUMBER,
                                                COD_NUEVODIR NUMBER
                                            ) IS
HIDCOUNT NUMBER;
DCOUNT NUMBER;
LOCALIDAD VARCHAR(20);

BEGIN
	SELECT COUNT (*)
	INTO HIDCOUNT
    FROM HOTEL
    WHERE COD_HOTEL = HID;

    SELECT COUNT (*)
    INTO DCOUNT
    FROM HOTEL
    WHERE EID = COD_NUEVODIR;

    IF(HIDCOUNT > 0) THEN
        IF(DCOUNT = 0) THEN
            SELECT PROVINCIA
            INTO LOCALIDAD
            FROM HOTEL
            WHERE COD_HOTEL = HID;

            IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
                UPDATE PAPEL1.HOTEL17
                    SET EID = COD_NUEVODIR
                    WHERE COD_HOTEL = HID;

            ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
                UPDATE PAPEL2.HOTEL36
                    SET EID = COD_NUEVODIR
                    WHERE COD_HOTEL = HID;

            ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
                UPDATE PAPEL3.HOTEL25
                    SET EID = COD_NUEVODIR
                    WHERE COD_HOTEL = HID;

            ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
                UPDATE PAPEL4.HOTEL48
                    SET EID = COD_NUEVODIR
                    WHERE COD_HOTEL = HID;
            ELSE
                RAISE_APPLICATION_ERROR(-20022,'Localidad no válida.');
            END IF;
        ELSE
	        RAISE_APPLICATION_ERROR(-20023,'Este empleado ya dirige un hotel.');
        END IF;
    ELSE
	    RAISE_APPLICATION_ERROR(-20024,'Hotel no existe.');
    END IF;
END;
/

-- Insertar en tabla Empleado
CREATE OR REPLACE PROCEDURE INSERT_EMPLEADO(        COD_EMPLEADO NUMBER,
                                                    COD_HOTEL NUMBER,
                                                    NOMBRE_EMP VARCHAR,
                                                    DIRECCION_EMP VARCHAR,
							                        SALARIO_EMP NUMBER,
                                                    DNI_EMP NUMBER,
							                        TLF_EMP NUMBER,
                                                    FECHA_CONT_EMP DATE,
						                            FECHA_INI_EMP DATE) IS

LOCALIDAD VARCHAR(20);
ECOUNT NUMBER;

BEGIN
    SELECT COUNT(*)
    INTO ECOUNT
    FROM EMPLEADO
    WHERE EID = COD_EMPLEADO;

    IF(ECOUNT = 0) THEN
        SELECT PROVINCIA
        INTO LOCALIDAD
        FROM HOTEL
        WHERE HID = COD_HOTEL;

        IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
            INSERT INTO PAPEL1.EMPLEADO17
            VALUES (COD_EMPLEADO, COD_HOTEL, NOMBRE_EMP , DIRECCION_EMP, SALARIO_EMP, DNI_EMP, TLF_EMP, FECHA_CONT_EMP, FECHA_INI_EMP);

        
        ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
            INSERT INTO PAPEL2.EMPLEADO36
            VALUES (COD_EMPLEADO, COD_HOTEL, NOMBRE_EMP , DIRECCION_EMP, SALARIO_EMP, DNI_EMP, TLF_EMP, FECHA_CONT_EMP, FECHA_INI_EMP);
        
        ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
            INSERT INTO PAPEL3.EMPLEADO25
            VALUES (COD_EMPLEADO, COD_HOTEL, NOMBRE_EMP , DIRECCION_EMP, SALARIO_EMP, DNI_EMP, TLF_EMP, FECHA_CONT_EMP, FECHA_INI_EMP);

        
        ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
            INSERT INTO PAPEL4.EMPLEADO48
            VALUES (COD_EMPLEADO, COD_HOTEL, NOMBRE_EMP , DIRECCION_EMP, SALARIO_EMP, DNI_EMP, TLF_EMP, FECHA_CONT_EMP, FECHA_INI_EMP);
        ELSE
            RAISE_APPLICATION_ERROR(-20007,'LOCALIDAD NO VÁLIDA');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20008,'Empleado ya existe.');
    END IF;
END;
/

-- Cambiar Sucursal de empleado
CREATE OR REPLACE PROCEDURE CAMBIAR_SUCURSAL_EMPLEADO(  COD_EMPLEADO NUMBER,
                                                        COD_HOTEL NUMBER,
                                                        FECHA_CONTRATO_FINAL DATE,
                                                        FECHA_INI_EMP DATE) IS

FECHA_CONTRATO_ANTIGUA DATE;
HOTEL_ANTIGUO NUMBER;
LOCALIDAD VARCHAR(20);
ECOUNT NUMBER;

BEGIN
    SELECT HID
    INTO HOTEL_ANTIGUO
    FROM EMPLEADO
    WHERE EID = COD_EMPLEADO;

    IF(HOTEL_ANTIGUO != COD_HOTEL) THEN
        SELECT COUNT(*)
        INTO ECOUNT
        FROM EMPLEADO
        WHERE EID = COD_EMPLEADO;

        IF(ECOUNT > 0) THEN
            SELECT PROVINCIA
            INTO LOCALIDAD
            FROM HOTEL
            WHERE HID = COD_HOTEL;

            IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
                SELECT FECHA_CONTRATO
                INTO FECHA_CONTRATO_ANTIGUA
                FROM PAPEL1.EMPLEADO17
                WHERE COD_EMPLEADO = EID;

                UPDATE PAPEL1.EMPLEADO17
                SET HID = COD_HOTEL,
                    FECHA_CONTRATO = FECHA_INI_EMP,
                    FECHA_INI = FECHA_INI_EMP
                WHERE   COD_EMPLEADO = EID;

                INSERT INTO PAPEL3.HISTORICO
                VALUES (COD_EMPLEADO, HOTEL_ANTIGUO, FECHA_CONTRATO_ANTIGUA, FECHA_CONTRATO_FINAL);
            
            ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
                SELECT FECHA_CONTRATO
                INTO FECHA_CONTRATO_ANTIGUA
                FROM PAPEL2.EMPLEADO36
                WHERE COD_EMPLEADO = EID;

                UPDATE PAPEL2.EMPLEADO36
                SET HID = COD_HOTEL,
                    FECHA_CONTRATO = FECHA_INI_EMP,
                    FECHA_INI = FECHA_INI_EMP
                WHERE   COD_EMPLEADO = EID;

                INSERT INTO PAPEL3.HISTORICO
                VALUES (COD_EMPLEADO, HOTEL_ANTIGUO, FECHA_CONTRATO_ANTIGUA, FECHA_CONTRATO_FINAL);
            
            ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
                SELECT FECHA_CONTRATO
                INTO FECHA_CONTRATO_ANTIGUA
                FROM PAPEL3.EMPLEADO25
                WHERE COD_EMPLEADO = EID;

                UPDATE PAPEL3.EMPLEADO25
                SET HID = COD_HOTEL,
                    FECHA_CONTRATO = FECHA_INI_EMP,
                    FECHA_INI = FECHA_INI_EMP
                WHERE   COD_EMPLEADO = EID;

                INSERT INTO PAPEL3.HISTORICO
                VALUES (COD_EMPLEADO, HOTEL_ANTIGUO, FECHA_CONTRATO_ANTIGUA, FECHA_CONTRATO_FINAL);
            
            ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
                SELECT FECHA_CONTRATO
                INTO FECHA_CONTRATO_ANTIGUA
                FROM PAPEL4.EMPLEADO48
                WHERE COD_EMPLEADO = EID;

                UPDATE PAPEL4.EMPLEADO48
                SET HID = COD_HOTEL,
                    FECHA_CONTRATO = FECHA_INI_EMP,
                    FECHA_INI = FECHA_INI_EMP
                WHERE   COD_EMPLEADO = EID;

                INSERT INTO PAPEL3.HISTORICO
                VALUES (COD_EMPLEADO, HOTEL_ANTIGUO, FECHA_CONTRATO_ANTIGUA, FECHA_CONTRATO_FINAL);
            ELSE
                RAISE_APPLICATION_ERROR(-20009,'LOCALIDAD NO VÁLIDA');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20010,'Empleado no existe.');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20011,'Es el mismo hotel.');
    END IF;
END;
/

-- Cambiar salario de un empleado
CREATE OR REPLACE PROCEDURE SALARIO_EMPLEADO(   COD_EMPLEADO NUMBER,
                                                SALARIO_EMP NUMBER) IS

LOCALIDAD VARCHAR(20);
HOTEL_EMP NUMBER;
ECOUNT NUMBER;

BEGIN
    SELECT COUNT(*)
    INTO ECOUNT
    FROM EMPLEADO
    WHERE EID = COD_EMPLEADO;

    IF(ECOUNT > 0) THEN
        SELECT HID
        INTO HOTEL_EMP
        FROM EMPLEADO
        WHERE EID = COD_EMPLEADO;

        SELECT PROVINCIA
        INTO LOCALIDAD
        FROM HOTEL
        WHERE HID = HOTEL_EMP;

        IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
            UPDATE PAPEL1.EMPLEADO17
            SET SALARIO = SALARIO_EMP
            WHERE   COD_EMPLEADO = EID;
        
        ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
            UPDATE PAPEL2.EMPLEADO36
            SET SALARIO = SALARIO_EMP
            WHERE   COD_EMPLEADO = EID;

        ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
            UPDATE PAPEL3.EMPLEADO25
            SET SALARIO = SALARIO_EMP
            WHERE   COD_EMPLEADO = EID;

        ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
            UPDATE PAPEL4.EMPLEADO48
            SET SALARIO = SALARIO_EMP
            WHERE   COD_EMPLEADO = EID;
        ELSE
            RAISE_APPLICATION_ERROR(-20012,'LOCALIDAD NO VÁLIDA');
        END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20013,'Empleado no existe.');
    END IF;
END;
/

--2. Dar de baja a un empleado. Argumentos: Código de empleado y fecha de baja. Esta
--operación requiere, antes de proceder a la eliminación del empleado, crear el
--registro histórico correspondiente.
CREATE OR REPLACE PROCEDURE DELETE_EMPLEADO( COD_EMPLEADO NUMBER,
                                                    FECHA_FIN DATE
                                                    ) IS
EMPCOUNT NUMBER;
HOT NUMBER;
LOCALIDAD VARCHAR(20);
FECHA_I DATE;

BEGIN
    SELECT COUNT (*)
    INTO EMPCOUNT
    FROM EMPLEADO
    WHERE COD_EMPLEADO = EID;

    IF(EMPCOUNT = 0) THEN
        RAISE_APPLICATION_ERROR(-20014,'Este codigo de empleado no se encuentra registrado.');
    END IF;

    SELECT HID
    INTO HOT
    FROM EMPLEADO
    WHERE COD_EMPLEADO = EID;
	
    SELECT FECHA_INI
    INTO FECHA_I
    FROM PAPEL1.EMPLEADO17
    WHERE COD_EMPLEADO = EID;

    SELECT PROVINCIA
    INTO LOCALIDAD
    FROM HOTEL
    WHERE HOT = HID;

    IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
        INSERT INTO PAPEL3.HISTORICO
        VALUES(COD_EMPLEADO, HOT, FECHA_I, FECHA_FIN);

        DELETE FROM PAPEL1.EMPLEADO17 WHERE COD_EMPLEADO = EID;

    ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
        INSERT INTO PAPEL3.HISTORICO
        VALUES(COD_EMPLEADO, HOT, FECHA_I, FECHA_FIN);
    
        DELETE FROM PAPEL2.EMPLEADO36 WHERE COD_EMPLEADO = EID;

    ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
        INSERT INTO PAPEL3.HISTORICO
        VALUES(COD_EMPLEADO, HOT, FECHA_I, FECHA_FIN);
    
        DELETE FROM PAPEL3.EMPLEADO25 WHERE COD_EMPLEADO = EID;

    ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
        INSERT INTO PAPEL3.HISTORICO
        VALUES(COD_EMPLEADO, HOT, FECHA_I, FECHA_FIN);
    
        DELETE FROM PAPEL4.EMPLEADO48 WHERE COD_EMPLEADO = EID;
    ELSE
        RAISE_APPLICATION_ERROR(-20015,'LOCALIDAD NO VÁLIDA');
    END IF;
END;
/

-- Insertar/actualizar tabla Cliente
CREATE OR REPLACE PROCEDURE INSERT_CLIENTE( COD_CLIENTE NUMBER,
                                            NOMBRE_CLIENTE VARCHAR,
                                            DNI_CLIENTE NUMBER,
                                            TLF_CLIENTE NUMBER) IS

CLIENTCOUNT NUMBER;

BEGIN
    SELECT COUNT (*)
    INTO CLIENTCOUNT
    FROM PAPEL1.CLIENTE
    WHERE   COD_CLIENTE = CID;

    IF(CLIENTCOUNT > 0) THEN
        RAISE_APPLICATION_ERROR(-20006,'El cliente ya existe.');
    ELSE
        INSERT INTO PAPEL1.CLIENTE
        VALUES (COD_CLIENTE, NOMBRE_CLIENTE, DNI_CLIENTE, TLF_CLIENTE);

        INSERT INTO PAPEL2.CLIENTE
        VALUES (COD_CLIENTE, NOMBRE_CLIENTE, DNI_CLIENTE, TLF_CLIENTE);

        INSERT INTO PAPEL3.CLIENTE
        VALUES (COD_CLIENTE, NOMBRE_CLIENTE, DNI_CLIENTE, TLF_CLIENTE);

        INSERT INTO PAPEL4.CLIENTE
        VALUES (COD_CLIENTE, NOMBRE_CLIENTE, DNI_CLIENTE, TLF_CLIENTE);
    END IF;
END;
/

-- Insertar/actualizar tabla Reserva
-- 6. Un cliente nunca podrá tener más de una reserva en hoteles distintos para las mismas fechas.
-- ARREGLAR ERROR FECHAS INVALIDAS
CREATE OR REPLACE PROCEDURE INSERT_UPDATE_RESERVA( COD_CLIENTE NUMBER,
                                            COD_HOTEL NUMBER,
                                            FECHA_INICIO DATE,
                                            FECHA_FINAL DATE,
					                        NUEVO_INICIO DATE,
                                            NUEVO_FINAL DATE,
                                            TIPO_HABITACION VARCHAR,
                                            PRECIO_RESERVA FLOAT) IS

UPDATECOUNT NUMBER;
RESERVAS NUMBER;
NHABITACIONES NUMBER;
RESERVASHOTEL NUMBER;
LOCALIDAD VARCHAR(20);
HABITACION_ANTERIOR VARCHAR(20);

BEGIN
    IF(NUEVO_INICIO IS NULL OR NUEVO_FINAL IS NULL) THEN
        SELECT PROVINCIA
        INTO LOCALIDAD
        FROM HOTEL
        WHERE HID = COD_HOTEL;

        IF LOCALIDAD='Granada' OR LOCALIDAD='Jaén' THEN
            INSERT INTO PAPEL1.RESERVA17
            VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FINAL, FECHA_INICIO, TIPO_HABITACION, PRECIO_RESERVA);
        
        ELSIF (LOCALIDAD='Cádiz' OR LOCALIDAD='Huelva') THEN
            INSERT INTO PAPEL2.RESERVA36
            VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FINAL, FECHA_INICIO, TIPO_HABITACION, PRECIO_RESERVA);
        
        ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
            INSERT INTO PAPEL3.RESERVA25
            VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FINAL, FECHA_INICIO, TIPO_HABITACION, PRECIO_RESERVA);

        ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
            INSERT INTO PAPEL4.RESERVA48
            VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FINAL, FECHA_INICIO, TIPO_HABITACION, PRECIO_RESERVA);

        ELSE
            RAISE_APPLICATION_ERROR(-20028,'LOCALIDAD NO VÁLIDA');
        END IF;
    ELSIF (NUEVO_INICIO IS NOT NULL AND NUEVO_FINAL IS NOT NULL) THEN
        SELECT COUNT (*)
        INTO UPDATECOUNT
        FROM RESERVA
        WHERE   CID = COD_CLIENTE
                AND COD_HOTEL = HID
                AND FECHA_INICIO = FECHA_INI
                AND FECHA_FINAL = FECHA_FIN;
    
        IF UPDATECOUNT > 0 THEN
            SELECT COUNT(*)
            INTO RESERVAS
            FROM RESERVA
            WHERE   (FECHA_INI<=NUEVO_INICIO OR FECHA_INI<=NUEVO_FINAL)
                    AND (FECHA_FIN>=NUEVO_INICIO OR FECHA_FIN>=NUEVO_FINAL);

            SELECT TIPO_HAB
            INTO HABITACION_ANTERIOR
            FROM RESERVA
            WHERE   CID = COD_CLIENTE
                    AND COD_HOTEL = HID
                    AND FECHA_INI = FECHA_INICIO
                    AND FECHA_FIN = FECHA_FINAL;

            IF (TIPO_HABITACION = 'Sencilla') THEN
                SELECT N_HAB
                INTO NHABITACIONES
                FROM HOTEL
                WHERE HID = COD_HOTEL;

            ELSIF (TIPO_HABITACION = 'Doble') THEN
                SELECT N_HAB2
                INTO NHABITACIONES
                FROM HOTEL
                WHERE HID = COD_HOTEL;
            END IF;

            IF(RESERVAS <= 1) THEN
                SELECT PROVINCIA
                INTO LOCALIDAD
                FROM HOTEL
                WHERE HID = COD_HOTEL;

                IF LOCALIDAD='Granada' OR LOCALIDAD='Jaén' THEN
                    IF(HABITACION_ANTERIOR != TIPO_HABITACION) THEN
                        IF (TIPO_HABITACION = 'Sencilla') THEN
                            SELECT COUNT(*)
                            INTO RESERVASHOTEL
                            FROM PAPEL1.RESERVA17
                            WHERE   (FECHA_INI<=NUEVO_INICIO OR FECHA_INI<=NUEVO_FINAL)
                                    AND (FECHA_FIN>=NUEVO_INICIO OR FECHA_FIN>=NUEVO_FINAL)
                                    AND TIPO_HAB = 'Sencilla';
                            
                            IF(RESERVASHOTEL < NHABITACIONES) THEN
                                UPDATE PAPEL1.RESERVA17
                                SET FECHA_FIN = NUEVO_FINAL,
                                    FECHA_INI = NUEVO_INICIO,
                                    TIPO_HAB = TIPO_HABITACION,
                                    PRECIO = PRECIO_RESERVA
                                WHERE   COD_CLIENTE = CID
                                        AND COD_HOTEL = HID;
                            ELSE
                                RAISE_APPLICATION_ERROR(-20029,'No queda espacio en el hotel en esas fechas.');
                            END IF;
                        ELSIF (TIPO_HABITACION = 'Doble') THEN
                            SELECT COUNT(*)
                            INTO RESERVASHOTEL
                            FROM PAPEL1.RESERVA17
                            WHERE   (FECHA_INI<=NUEVO_INICIO OR FECHA_INI<=NUEVO_FINAL)
                                    AND (FECHA_FIN>=NUEVO_INICIO OR FECHA_FIN>=NUEVO_FINAL)
                                    AND TIPO_HAB = 'Doble';
                            
                            IF(RESERVASHOTEL < NHABITACIONES) THEN
                                UPDATE PAPEL1.RESERVA17
                                SET FECHA_FIN = NUEVO_FINAL,
                                    FECHA_INI = NUEVO_INICIO,
                                    TIPO_HAB = TIPO_HABITACION,
                                    PRECIO = PRECIO_RESERVA
                                WHERE   COD_CLIENTE = CID
                                        AND COD_HOTEL = HID;
                            ELSE
                                RAISE_APPLICATION_ERROR(-20030,'No queda espacio en el hotel en esas fechas.');
                            END IF;
                        END IF;
                    ELSE
                        UPDATE PAPEL1.RESERVA17
                        SET FECHA_FIN = NUEVO_FINAL,
                            FECHA_INI = NUEVO_INICIO,
                            TIPO_HAB = TIPO_HABITACION,
                            PRECIO = PRECIO_RESERVA
                        WHERE   COD_CLIENTE = CID
                                AND COD_HOTEL = HID;
                    END IF;
                
                ELSIF (LOCALIDAD='Cádiz' OR LOCALIDAD='Huelva') THEN
                    IF(HABITACION_ANTERIOR != TIPO_HABITACION) THEN
                        IF (TIPO_HABITACION = 'Sencilla') THEN
                            SELECT COUNT(*)
                            INTO RESERVASHOTEL
                            FROM PAPEL2.RESERVA36
                            WHERE   (FECHA_INI<=NUEVO_INICIO OR FECHA_INI<=NUEVO_FINAL)
                                    AND (FECHA_FIN>=NUEVO_INICIO OR FECHA_FIN>=NUEVO_FINAL)
                                    AND TIPO_HAB = 'Sencilla';
                            
                            IF(RESERVASHOTEL < NHABITACIONES) THEN
                                UPDATE PAPEL2.RESERVA36
                                SET FECHA_FIN = NUEVO_FINAL,
                                    FECHA_INI = NUEVO_INICIO,
                                    TIPO_HAB = TIPO_HABITACION,
                                    PRECIO = PRECIO_RESERVA
                                WHERE   COD_CLIENTE = CID
                                        AND COD_HOTEL = HID;
                            ELSE
                                RAISE_APPLICATION_ERROR(-20031,'No queda espacio en el hotel en esas fechas.');
                            END IF;
                        ELSIF (TIPO_HABITACION = 'Doble') THEN
                            SELECT COUNT(*)
                            INTO RESERVASHOTEL
                            FROM PAPEL2.RESERVA36
                            WHERE   (FECHA_INI<=NUEVO_INICIO OR FECHA_INI<=NUEVO_FINAL)
                                    AND (FECHA_FIN>=NUEVO_INICIO OR FECHA_FIN>=NUEVO_FINAL)
                                    AND TIPO_HAB = 'Doble';
                            
                            IF(RESERVASHOTEL < NHABITACIONES) THEN
                                UPDATE PAPEL2.RESERVA36
                                SET FECHA_FIN = NUEVO_FINAL,
                                    FECHA_INI = NUEVO_INICIO,
                                    TIPO_HAB = TIPO_HABITACION,
                                    PRECIO = PRECIO_RESERVA
                                WHERE   COD_CLIENTE = CID
                                        AND COD_HOTEL = HID;
                            ELSE
                                RAISE_APPLICATION_ERROR(-20032,'No queda espacio en el hotel en esas fechas.');
                            END IF;
                        END IF;
                    ELSE
                        UPDATE PAPEL2.RESERVA36
                        SET FECHA_FIN = NUEVO_FINAL,
                            FECHA_INI = NUEVO_INICIO,
                            TIPO_HAB = TIPO_HABITACION,
                            PRECIO = PRECIO_RESERVA
                        WHERE   COD_CLIENTE = CID
                                AND COD_HOTEL = HID;
                    END IF;
    
                ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
                    IF(HABITACION_ANTERIOR != TIPO_HABITACION) THEN
                        IF (TIPO_HABITACION = 'Sencilla') THEN
                            SELECT COUNT(*)
                            INTO RESERVASHOTEL
                            FROM PAPEL3.RESERVA25
                            WHERE   (FECHA_INI<=NUEVO_INICIO OR FECHA_INI<=NUEVO_FINAL)
                                    AND (FECHA_FIN>=NUEVO_INICIO OR FECHA_FIN>=NUEVO_FINAL)
                                    AND TIPO_HAB = 'Sencilla';
                            
                            IF(RESERVASHOTEL < NHABITACIONES) THEN
                                UPDATE PAPEL3.RESERVA25
                                SET FECHA_FIN = NUEVO_FINAL,
                                    FECHA_INI = NUEVO_INICIO,
                                    TIPO_HAB = TIPO_HABITACION,
                                    PRECIO = PRECIO_RESERVA
                                WHERE   COD_CLIENTE = CID
                                        AND COD_HOTEL = HID;
                            ELSE
                                RAISE_APPLICATION_ERROR(-20033,'No queda espacio en el hotel en esas fechas.');
                            END IF;
                        ELSIF (TIPO_HABITACION = 'Doble') THEN
                            SELECT COUNT(*)
                            INTO RESERVASHOTEL
                            FROM PAPEL3.RESERVA25
                            WHERE   (FECHA_INI<=NUEVO_INICIO OR FECHA_INI<=NUEVO_FINAL)
                                    AND (FECHA_FIN>=NUEVO_INICIO OR FECHA_FIN>=NUEVO_FINAL)
                                    AND TIPO_HAB = 'Doble';
                            
                            IF(RESERVASHOTEL < NHABITACIONES) THEN
                                UPDATE PAPEL3.RESERVA25
                                SET FECHA_FIN = NUEVO_FINAL,
                                    FECHA_INI = NUEVO_INICIO,
                                    TIPO_HAB = TIPO_HABITACION,
                                    PRECIO = PRECIO_RESERVA
                                WHERE   COD_CLIENTE = CID
                                        AND COD_HOTEL = HID;
                            ELSE
                                RAISE_APPLICATION_ERROR(-20034,'No queda espacio en el hotel en esas fechas.');
                            END IF;
                        END IF;
                    ELSE
                        UPDATE PAPEL3.RESERVA25
                        SET FECHA_FIN = NUEVO_FINAL,
                            FECHA_INI = NUEVO_INICIO,
                            TIPO_HAB = TIPO_HABITACION,
                            PRECIO = PRECIO_RESERVA
                        WHERE   COD_CLIENTE = CID
                                AND COD_HOTEL = HID;
                    END IF;
    
                ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
                    IF(HABITACION_ANTERIOR != TIPO_HABITACION) THEN
                        IF (TIPO_HABITACION = 'Sencilla') THEN
                            SELECT COUNT(*)
                            INTO RESERVASHOTEL
                            FROM PAPEL4.RESERVA48
                            WHERE   (FECHA_INI<=NUEVO_INICIO OR FECHA_INI<=NUEVO_FINAL)
                                    AND (FECHA_FIN>=NUEVO_INICIO OR FECHA_FIN>=NUEVO_FINAL)
                                    AND TIPO_HAB = 'Sencilla';
                            
                            IF(RESERVASHOTEL < NHABITACIONES) THEN
                                UPDATE PAPEL4.RESERVA48
                                SET FECHA_FIN = NUEVO_FINAL,
                                    FECHA_INI = NUEVO_INICIO,
                                    TIPO_HAB = TIPO_HABITACION,
                                    PRECIO = PRECIO_RESERVA
                                WHERE   COD_CLIENTE = CID
                                        AND COD_HOTEL = HID;
                            ELSE
                                RAISE_APPLICATION_ERROR(-20035,'No queda espacio en el hotel en esas fechas.');
                            END IF;
                        ELSIF (TIPO_HABITACION = 'Doble') THEN
                            SELECT COUNT(*)
                            INTO RESERVASHOTEL
                            FROM PAPEL4.RESERVA48
                            WHERE   (FECHA_INI<=NUEVO_INICIO OR FECHA_INI<=NUEVO_FINAL)
                                    AND (FECHA_FIN>=NUEVO_INICIO OR FECHA_FIN>=NUEVO_FINAL)
                                    AND TIPO_HAB = 'Doble';
                            
                            IF(RESERVASHOTEL < NHABITACIONES) THEN
                                UPDATE PAPEL4.RESERVA48
                                SET FECHA_FIN = NUEVO_FINAL,
                                    FECHA_INI = NUEVO_INICIO,
                                    TIPO_HAB = TIPO_HABITACION,
                                    PRECIO = PRECIO_RESERVA
                                WHERE   COD_CLIENTE = CID
                                        AND COD_HOTEL = HID;
                            ELSE
                                RAISE_APPLICATION_ERROR(-20036,'No queda espacio en el hotel en esas fechas.');
                            END IF;
                        END IF;
                    ELSE
                        UPDATE PAPEL4.RESERVA48
                        SET FECHA_FIN = NUEVO_FINAL,
                            FECHA_INI = NUEVO_INICIO,
                            TIPO_HAB = TIPO_HABITACION,
                            PRECIO = PRECIO_RESERVA
                        WHERE   COD_CLIENTE = CID
                                AND COD_HOTEL = HID;
                    END IF;
                ELSE
                    RAISE_APPLICATION_ERROR(-20037,'LOCALIDAD NO VÁLIDA');
                END IF;
            ELSE
                RAISE_APPLICATION_ERROR(-20038,'El cliente ya tiene una reserva en esas fechas.');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20039,'No existe ninguna reserva en esas fechas.');
        END IF;
    END IF;
END;
/

--9. Anular una reserva. Argumentos: Código de cliente, código de hotel, fecha de
--entrada y fecha de salida.
CREATE OR REPLACE PROCEDURE DELETE_RESERVA( COD_CLIENTE NUMBER,
                                            COD_HOTEL NUMBER,
                                            FECHA_ENTRADA DATE,
                                            FECHA_SALIDA DATE) IS
                                            
RESCOUNT NUMBER;
LOCALIDAD VARCHAR(20);

BEGIN
	SELECT COUNT (*)
	INTO RESCOUNT
    FROM RESERVA
    WHERE COD_CLIENTE = CID AND COD_HOTEL = HID AND FECHA_ENTRADA = FECHA_INI AND FECHA_SALIDA = FECHA_FIN;

    IF(RESCOUNT = 0) THEN
        RAISE_APPLICATION_ERROR(-20040,'Esta reserva no se encuentra registrada.');
    END IF;

	SELECT PROVINCIA
	INTO LOCALIDAD
    FROM HOTEL
    WHERE COD_HOTEL = HID;

	IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
		DELETE FROM PAPEL1.RESERVA17 WHERE COD_CLIENTE = CID AND COD_HOTEL = HID AND FECHA_ENTRADA = FECHA_INI AND FECHA_SALIDA = FECHA_FIN;

	ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
		DELETE FROM PAPEL2.RESERVA36 WHERE COD_CLIENTE = CID AND COD_HOTEL = HID AND FECHA_ENTRADA = FECHA_INI AND FECHA_SALIDA = FECHA_FIN;

	ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
		DELETE FROM PAPEL3.RESERVA25 WHERE COD_CLIENTE = CID AND COD_HOTEL = HID AND FECHA_ENTRADA = FECHA_INI AND FECHA_SALIDA = FECHA_FIN;

	ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
		DELETE FROM PAPEL4.RESERVA48 WHERE COD_CLIENTE = CID AND COD_HOTEL = HID AND FECHA_ENTRADA = FECHA_INI AND FECHA_SALIDA = FECHA_FIN;
	ELSE
        RAISE_APPLICATION_ERROR(-20041,'LOCALIDAD NO VÁLIDA');
    END IF;
END;
/

-- Insertar/actualizar tabla Proveedor
-- 16. Ningún proveedor será de otra ciudad distinta a Granada o a Sevilla.
CREATE OR REPLACE PROCEDURE INSERT_PROVEEDOR(   COD_PROVEEDOR NUMBER,
                                                NOMBRE_PRO VARCHAR,
                                                LOCALIDAD VARCHAR) IS

PCOUNT NUMBER;

BEGIN
    IF (LOCALIDAD = 'Granada') THEN
        INSERT INTO PAPEL1.PROVEEDOR1
        VALUES (COD_PROVEEDOR, NOMBRE_PRO , LOCALIDAD);

        INSERT INTO PAPEL4.PROVEEDOR1
        VALUES (COD_PROVEEDOR, NOMBRE_PRO , LOCALIDAD);
    
    ELSIF (LOCALIDAD = 'Sevilla') THEN
        INSERT INTO PAPEL3.PROVEEDOR2
        VALUES (COD_PROVEEDOR, NOMBRE_PRO , LOCALIDAD);

        INSERT INTO PAPEL2.PROVEEDOR2
        VALUES (COD_PROVEEDOR, NOMBRE_PRO , LOCALIDAD);
    ELSE
        RAISE_APPLICATION_ERROR(-20025,'LOCALIDAD NO VÁLIDA');
    END IF;
END;
/

--11. Dar de baja a un proveedor. Argumento: Código de proveedor.
CREATE OR REPLACE PROCEDURE DELETE_PROVEEDOR(COD_PRO NUMBER) IS
PROCOUNT NUMBER;
LOCALIDAD VARCHAR(20);

BEGIN
	SELECT COUNT (*)
	INTO PROCOUNT
	FROM PROVEEDOR
	WHERE COD_PRO = PID;

    IF(PROCOUNT = 0) THEN
        RAISE_APPLICATION_ERROR(-20026,'Este codigo de proveedor no se encuentra registrado.');
    END IF;

	SELECT PROVINCIA
	INTO LOCALIDAD
    FROM PROVEEDOR
    WHERE COD_PRO = PID;

	IF(LOCALIDAD = 'Granada') THEN
		DELETE FROM PAPEL1.PROVEEDOR1 WHERE COD_PRO = PID;
		DELETE FROM PAPEL4.PROVEEDOR1 WHERE COD_PRO = PID;

	ELSIF (LOCALIDAD = 'Sevilla') THEN
		DELETE FROM PAPEL2.PROVEEDOR2 WHERE COD_PRO = PID;
		DELETE FROM PAPEL3.PROVEEDOR2 WHERE COD_PRO = PID;
    ELSE
        RAISE_APPLICATION_ERROR(-20027,'LOCALIDAD NO VÁLIDA');
    END IF;
END;
/

-- Insertar/actualizar tabla Articulo
CREATE OR REPLACE PROCEDURE INSERT_ARTICULO(    COD_PROVEEDOR NUMBER,
                                                COD_ARTICULO NUMBER,
                                                NOMBRE_ARTICULO VARCHAR,
                                                TIPO_ARTICULO VARCHAR) IS

ARTCOUNT NUMBER;

BEGIN
    INSERT INTO PAPEL1.ARTICULO
    VALUES (COD_PROVEEDOR, COD_ARTICULO, NOMBRE_ARTICULO, TIPO_ARTICULO);

    INSERT INTO PAPEL2.ARTICULO
    VALUES (COD_PROVEEDOR, COD_ARTICULO, NOMBRE_ARTICULO, TIPO_ARTICULO);

    INSERT INTO PAPEL3.ARTICULO
    VALUES (COD_PROVEEDOR, COD_ARTICULO, NOMBRE_ARTICULO, TIPO_ARTICULO);

    INSERT INTO PAPEL4.ARTICULO
    VALUES (COD_PROVEEDOR, COD_ARTICULO, NOMBRE_ARTICULO, TIPO_ARTICULO);
END;
/

--15. Dar de baja un artículo. Argumentos: Código de artículo. Si es posible dar de baja
--el artículo, esta operación dará de baja también todos los suministros en los que
--aparezca dicho artículo.
CREATE OR REPLACE PROCEDURE DELETE_ARTICULO( COD_ART NUMBER                                      
                                                    ) IS
ARTCOUNT NUMBER;

BEGIN
	SELECT COUNT (*)
	INTO ARTCOUNT
    	FROM ARTICULO		
    	WHERE COD_ART = AID;

	IF(ARTCOUNT > 0) THEN	
		DELETE FROM PAPEL1.ENTREGA17 WHERE COD_ART = AID;

		DELETE FROM PAPEL4.ENTREGA48 WHERE COD_ART = AID;

		DELETE FROM PAPEL2.ENTREGA36 WHERE COD_ART = AID;

		DELETE FROM PAPEL3.ENTREGA25 WHERE COD_ART = AID;

		DELETE FROM PAPEL1.ARTICULO WHERE COD_ART = AID;

		DELETE FROM PAPEL2.ARTICULO WHERE COD_ART = AID;

		DELETE FROM PAPEL3.ARTICULO WHERE COD_ART = AID;
        
		DELETE FROM PAPEL4.ARTICULO WHERE COD_ART = AID;
    ELSE
		RAISE_APPLICATION_ERROR(-20005,'Este codigo de articulo no se encuentra registrado.');
    END IF;
END;
/

-- 12. Dar de alta o actualizar un suministro. Argumentos: Código de artículo, código
-- de proveedor, código del hotel que solicita el suministro, fecha de suministro,
-- cantidad a suministrar (puede ser negativa, lo cual significa que se devuelve el
-- suministro) , y precio por unidad. Si existiera una solicitud de suministro del mismo
-- hotel y del mismo artículo al mismo proveedor y en la misma fecha, se modificará, en
-- la forma adecuada, la cantidad a suministrar.
-- 14. El precio por unidad de un artículo para un suministro determinado a un hotel
-- determinado, nunca podrá ser menor que el de ese mismo artículo en suministros
-- anteriores a ese mismo hotel.
CREATE OR REPLACE PROCEDURE INSERT_UPDATE_ENTREGA(  COD_PROVEEDOR NUMBER,
                                                    COD_ARTICULO NUMBER,
                                                    COD_HOTEL NUMBER,
                                                    FECHA_EN DATE,
                                                    PRECIO_EN NUMBER,
							                        CANTIDAD_EN NUMBER) IS

UPDATECOUNT NUMBER;
LOCALIDAD VARCHAR(20);
PRECIO_AUX NUMBER;
BEGIN
    SELECT COUNT (*)
    INTO UPDATECOUNT
    FROM ENTREGA
    WHERE COD_HOTEL = HID
          AND COD_ARTICULO = AID
          AND COD_PROVEEDOR = PID
          AND FECHA_EN = FECHA;

    SELECT PROVINCIA
    INTO LOCALIDAD
    FROM HOTEL
    WHERE COD_HOTEL = HID;

    IF(UPDATECOUNT = 0) THEN
        IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
            INSERT INTO PAPEL1.ENTREGA17
            VALUES (COD_PROVEEDOR, COD_ARTICULO, COD_HOTEL, FECHA_EN , PRECIO_EN, CANTIDAD_EN);

        ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
            INSERT INTO PAPEL2.ENTREGA36
            VALUES (COD_PROVEEDOR, COD_ARTICULO, COD_HOTEL, FECHA_EN , PRECIO_EN, CANTIDAD_EN);

        ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
            INSERT INTO PAPEL3.ENTREGA25
            VALUES (COD_PROVEEDOR, COD_ARTICULO, COD_HOTEL, FECHA_EN , PRECIO_EN, CANTIDAD_EN);

        ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
            INSERT INTO PAPEL4.ENTREGA48
            VALUES (COD_PROVEEDOR, COD_ARTICULO, COD_HOTEL, FECHA_EN , PRECIO_EN, CANTIDAD_EN);

        ELSE
            RAISE_APPLICATION_ERROR(-20016,'LOCALIDAD NO VÁLIDA');
        END IF;
    ELSE
        SELECT PRECIO
        INTO PRECIO_AUX
        FROM ENTREGA
        WHERE   COD_HOTEL = HID
                AND COD_ARTICULO = AID
                AND COD_PROVEEDOR = PID
        ORDER BY FECHA ASC;

        IF(PRECIO_AUX <= PRECIO_EN) THEN
            IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
                UPDATE PAPEL1.ENTREGA17
                SET PRECIO = PRECIO_EN,
                    CANTIDAD = (CANTIDAD+CANTIDAD_EN)
                WHERE   COD_HOTEL = HID
                        AND COD_ARTICULO = AID
                        AND COD_PROVEEDOR = PID
                        AND FECHA_EN = FECHA;
            ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
                UPDATE PAPEL2.ENTREGA36
                SET PRECIO = PRECIO_EN,
                    CANTIDAD = (CANTIDAD+CANTIDAD_EN)
                WHERE   COD_HOTEL = HID
                        AND COD_ARTICULO = AID
                        AND COD_PROVEEDOR = PID
                        AND FECHA_EN = FECHA;

            ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
                UPDATE PAPEL3.ENTREGA25
                SET PRECIO = PRECIO_EN,
                    CANTIDAD = (CANTIDAD+CANTIDAD_EN)
                WHERE   COD_HOTEL = HID
                        AND COD_ARTICULO = AID
                        AND COD_PROVEEDOR = PID
                        AND FECHA_EN = FECHA;

            ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
                UPDATE PAPEL4.ENTREGA48
                SET PRECIO = PRECIO_EN,
                    CANTIDAD = (CANTIDAD+CANTIDAD_EN)
                WHERE   COD_HOTEL = HID
                        AND COD_ARTICULO = AID
                        AND COD_PROVEEDOR = PID
                        AND FECHA_EN = FECHA;
            ELSE
                RAISE_APPLICATION_ERROR(-20017,'LOCALIDAD NO VÁLIDA');
            END IF;
        ELSE
            RAISE_APPLICATION_ERROR(-20018,'El precio no puede reducirse.');
        END IF;
    END IF;
END;
/

--13. Dar de baja suministros. Argumentos: Código del hotel que solicitó el suministro,
--código del artículo y, opcionalmente, fecha del suministro. Si no se indica la fecha
--de suministro, se darán de baja todos los suministros solicitados por el hotel de
--ese artículo al proveedor.
CREATE OR REPLACE PROCEDURE DELETE_ENTREGA( COD_ARTICULO NUMBER,
                                            COD_HOTEL NUMBER,
						                    FECHA_SUM DATE) IS
ENTCOUNT NUMBER;
LOCALIDAD VARCHAR(20);

BEGIN
	SELECT COUNT (*)
	INTO ENTCOUNT
    	FROM ENTREGA
    	WHERE COD_HOTEL = HID AND COD_ARTICULO = AID;

    	IF(ENTCOUNT = 0) THEN
		RAISE_APPLICATION_ERROR(-20019,'Esta entrega no se encuentra registrada.');
    END IF;

	SELECT PROVINCIA
    	INTO LOCALIDAD
    	FROM HOTEL
    	WHERE COD_HOTEL = HID;

	IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
		IF (FECHA_SUM IS NULL) THEN
			DELETE FROM PAPEL1.ENTREGA17 WHERE COD_HOTEL = HID AND COD_ARTICULO = AID;
		ELSE
			DELETE FROM PAPEL1.ENTREGA17 WHERE COD_HOTEL = HID AND COD_ARTICULO = AID AND FECHA = FECHA_SUM;
		END IF;

    ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
		IF (FECHA_SUM IS NULL) THEN
			DELETE FROM PAPEL2.ENTREGA36 WHERE COD_HOTEL = HID AND COD_ARTICULO = AID;
		ELSE
			DELETE FROM PAPEL2.ENTREGA36 WHERE COD_HOTEL = HID AND COD_ARTICULO = AID AND FECHA = FECHA_SUM;
		END IF;

    ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
		IF (FECHA_SUM IS NULL) THEN
			DELETE FROM PAPEL3.ENTREGA25 WHERE COD_HOTEL = HID AND COD_ARTICULO = AID;
		ELSE
			DELETE FROM PAPEL3.ENTREGA25 WHERE COD_HOTEL = HID AND COD_ARTICULO = AID AND FECHA = FECHA_SUM;
		END IF;

    ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
		IF (FECHA_SUM IS NULL) THEN
			DELETE FROM PAPEL4.ENTREGA48 WHERE COD_HOTEL = HID AND COD_ARTICULO = AID;
		ELSE
			DELETE FROM PAPEL4.ENTREGA48 WHERE COD_HOTEL = HID AND COD_ARTICULO = AID AND FECHA = FECHA_SUM;
		END IF;
    ELSE
        RAISE_APPLICATION_ERROR(-20020,'LOCALIDAD NO VÁLIDA');
    END IF;
END;
/