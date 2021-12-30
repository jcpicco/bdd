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