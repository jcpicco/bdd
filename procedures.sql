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
