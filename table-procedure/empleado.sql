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