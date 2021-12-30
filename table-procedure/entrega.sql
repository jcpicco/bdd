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