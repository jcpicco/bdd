create or replace PROCEDURE insertaractualizarReserva(  COD_CLIENTE NUMBER,
                                                        COD_HOTEL NUMBER,
                                                        FECHA_INICIO DATE,
                                                        FECHA_FIN DATE,
                                                        TIPO_HABITACION VARCHAR,
                                                        PRECIO_RESERVA FLOAT,
                                                        LOCALIDAD VARCHAR) IS

BEGIN
    IF (FECHA_INICIO < FECHA_FIN) THEN
        IF (LOCALIDAD = 'Granada' OR LOCALIDAD = 'Jaén') THEN
            INSERT INTO PAPEL1.RESERVA17 VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FIN, FECHA_INI, TIPO_HABITACION, PRECIO_RESERVA);
        ELSIF (LOCALIDAD = 'Cádiz' OR LOCALIDAD = 'Huelva') THEN
            INSERT INTO PAPEL2.RESERVA36 VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FIN, FECHA_INI, TIPO_HABITACION, PRECIO_RESERVA);
        ELSIF (LOCALIDAD = 'Sevilla' OR LOCALIDAD = 'Córdoba') THEN
            INSERT INTO PAPEL3.RESERVA25 VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FIN, FECHA_INI, TIPO_HABITACION, PRECIO_RESERVA);
        ELSIF (LOCALIDAD = 'Málaga' OR LOCALIDAD = 'Almería') THEN
            INSERT INTO PAPEL4.RESERVA48 VALUES (COD_CLIENTE, COD_HOTEL, FECHA_FIN, FECHA_INI, TIPO_HABITACION, PRECIO_RESERVA);
        ELSE
            raise_application_error(20004,'LOCALIDAD NO VÁLIDA');
        ENDIF