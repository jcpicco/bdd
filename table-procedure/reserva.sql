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