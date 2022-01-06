-- 7. El director de un hotel es un empleado de la multinacional.
CREATE OR REPLACE TRIGGER DIRECTOR_HOTEL
BEFORE INSERT OR UPDATE ON PAPEL3.HOTEL25 FOR EACH ROW
DECLARE
    ECOUNT NUMBER;
BEGIN
    IF(:OLD.EID != :NEW.EID) THEN
        -- Comprobamos que el director es un empleado.
        SELECT COUNT (*)
        INTO ECOUNT
        FROM PAPEL3.EMPLEADO25
        WHERE EID = :NEW.EID;

        IF (ECOUNT = 0) THEN
            RAISE_APPLICATION_ERROR(-20076,'Este empleado no existe');
        END IF;
    END IF;
END;
/

-- Comprobamos que el hotel no exista.
-- 8. Un empleado, al mismo tiempo, sólo puede ser director de un hotel.
CREATE OR REPLACE TRIGGER UN_SOLO_HOTEL
BEFORE INSERT ON PAPEL3.HOTEL25 FOR EACH ROW
DECLARE
    HCOUNT NUMBER;
    ECOUNT NUMBER;
BEGIN
    -- Comprobamos que el hotel no exista.
    SELECT COUNT(*)
    INTO HCOUNT
    FROM HOTEL
    WHERE HID = :NEW.HID;

    IF (HCOUNT > 0) THEN
        RAISE_APPLICATION_ERROR(-20077,'El hotel ya existe');
    END IF;

    -- Comprobamos que el empleado no dirija otros hoteles
    SELECT COUNT (*)
    INTO ECOUNT
    FROM HOTEL
    WHERE EID = :NEW.EID;

    IF (ECOUNT > 0) THEN
        RAISE_APPLICATION_ERROR(-20078,'Este empleado ya dirige un hotel.');
    END IF;
END;
/

-- 11. La fecha de inicio de un empleado en un hotel será siempre igual o posterior a la
-- fecha de inicio de su contrato con la multinacional.
CREATE OR REPLACE TRIGGER INSERTAR_EMPLEADO
BEFORE INSERT ON PAPEL3.EMPLEADO25 FOR EACH ROW
BEGIN
    IF(:NEW.FECHA_CONTRATO > :NEW.FECHA_INI) THEN
        RAISE_APPLICATION_ERROR(-20079,'Fecha de contrato mayor a la de inicio');
    END IF;
END;
/

-- 10. El salario de un empleado nunca podrá disminuir.
CREATE OR REPLACE TRIGGER SALARIO_MAYOR
BEFORE UPDATE ON PAPEL3.EMPLEADO25 FOR EACH ROW
BEGIN
    IF(:NEW.SALARIO < :OLD.SALARIO) THEN
        RAISE_APPLICATION_ERROR(-20080,'El salario no puede disminuir.');
    END IF;
END;
/

-- 12. La fecha de inicio de un empleado en un hotel será siempre igual o posterior a la
-- fecha de fin en el hotel al que estaba asignado anteriormente.
CREATE OR REPLACE TRIGGER INSERTAR_HISTORICO
BEFORE INSERT ON PAPEL3.HISTORICO FOR EACH ROW
DECLARE
BEGIN
    IF(:NEW.FECHA_INI > :NEW.FECHA_FIN) THEN
        RAISE_APPLICATION_ERROR(-20081,'La fecha de contrato nueva no puede ser antes que la final.');
    END IF;
END;
/

-- 5. La fecha de entrada de un cliente en un hotel nunca podrá ser posterior a la de salida.
CREATE OR REPLACE TRIGGER ESPACIO_RESERVA
BEFORE INSERT OR UPDATE ON PAPEL3.RESERVA25 FOR EACH ROW
DECLARE
    NUM_HABS NUMBER;
BEGIN
    IF :NEW.FECHA_FIN < :NEW.FECHA_INI THEN
        RAISE_APPLICATION_ERROR(-20082,'Fecha de salida no puede ser menor a la de entrada');
    END IF;
END;
/

-- 6. Un cliente nunca podrá tener más de una reserva en hoteles distintos para las mismas fechas.
-- 4. El número de reservas de un hotel, nunca podrá exceder su capacidad, es decir,
-- nunca se podrá exceder el número de habitaciones sencillas, el número de
-- habitaciones dobles y el número total de habitaciones.
CREATE OR REPLACE TRIGGER RESERVA_DISPONIBLE
BEFORE INSERT ON PAPEL3.RESERVA25 FOR EACH ROW
DECLARE
    NHABITACIONES NUMBER;
    RESERVAS NUMBER;
    RESERVASHOTEL NUMBER;
BEGIN
    -- Comprobamos que no haya reservas en esas fechas por el mismo cliente.
    SELECT COUNT(*)
    INTO RESERVAS
    FROM RESERVA
    WHERE   CID=:NEW.CID
                AND (FECHA_INI<=:NEW.FECHA_INI OR FECHA_INI<=:NEW.FECHA_FIN)
                AND (FECHA_FIN>=:NEW.FECHA_INI OR FECHA_FIN>=:NEW.FECHA_FIN);

    IF(RESERVAS > 0) THEN
        RAISE_APPLICATION_ERROR(-20083,'El cliente ya tiene una reserva en esas fechas.');
    END IF;
    
    IF (:NEW.TIPO_HAB = 'Sencilla') THEN
        SELECT N_HAB
        INTO NHABITACIONES
        FROM PAPEL3.HOTEL25
        WHERE HID = :NEW.HID;

    ELSIF (:NEW.TIPO_HAB = 'Doble') THEN
        SELECT N_HAB2
        INTO NHABITACIONES
        FROM PAPEL3.HOTEL25
        WHERE HID = :NEW.HID;
    ELSE
        RAISE_APPLICATION_ERROR(-20084,'Tipo de habitación no válida.');
    END IF;

    -- Comprobamos que hayan habitaciones libres.
    SELECT COUNT(*)
    INTO RESERVASHOTEL
    FROM PAPEL3.RESERVA25
    WHERE   HID=:NEW.HID
            AND (FECHA_INI<=:NEW.FECHA_INI OR FECHA_INI<=:NEW.FECHA_FIN)
            AND (FECHA_FIN>=:NEW.FECHA_INI OR FECHA_FIN>=:NEW.FECHA_FIN);

    IF(RESERVASHOTEL = NHABITACIONES) THEN
        RAISE_APPLICATION_ERROR(-20085,'No queda espacio en el hotel en esas fechas.');
    END IF;
END;
/

-- Comprobar que existe el proveedor
CREATE OR REPLACE TRIGGER EXISTE_PROVEEDOR
BEFORE INSERT ON PAPEL3.PROVEEDOR2 FOR EACH ROW
DECLARE
AUXCOUNT NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO AUXCOUNT
    FROM PROVEEDOR
    WHERE PID = :NEW.PID;

    IF(AUXCOUNT = 1) THEN
        SELECT COUNT(*)
        INTO AUXCOUNT
        FROM PAPEL2.PROVEEDOR2
        WHERE PID = :NEW.PID;
        
        IF(AUXCOUNT = 0) THEN
            RAISE_APPLICATION_ERROR(-20068,'Proveedor existente.');
        END IF;
    END IF;
END;
/

--19. Los datos referentes a un proveedor solamente podrán eliminarse de la base de
--datos si, para cada artículo que suministre, la cantidad total suministrada es 0, o
--no existe ningún suministro.
CREATE OR REPLACE TRIGGER BORRAR_PROVEEDOR
BEFORE DELETE ON PAPEL3.PROVEEDOR2 FOR EACH ROW 
DECLARE
	PROVEEDOR_ACTIVO NUMBER;
BEGIN
	SELECT COUNT(*)
    INTO PROVEEDOR_ACTIVO 
	FROM ENTREGA
	WHERE PID = :OLD.PID;

	IF(PROVEEDOR_ACTIVO > 0) THEN
		RAISE_APPLICATION_ERROR(-20087,'Este proveedor no puede eliminarse, sigue activo');
    END IF;
END;
/

-- 13. El tipo de un artículo será ‘A’, ‘B’, ‘C’ o ‘D’.
CREATE OR REPLACE TRIGGER TIPO_ARTICULO
BEFORE INSERT ON PAPEL3.ARTICULO FOR EACH ROW 
BEGIN
	IF(:NEW.TIPO != 'A' AND :NEW.TIPO != 'B' AND :NEW.TIPO != 'C' AND :NEW.TIPO != 'D') THEN
		RAISE_APPLICATION_ERROR(-20088,'El tipo de articulo introducido no se admite en la base de datos.');
    END IF;
END;
/

-- 15. Un artículo sólo puede ser suministrado, como mucho, por dos proveedores, uno de
-- Granada y otro de Sevilla.
CREATE OR REPLACE TRIGGER UNICO_ARTICULO
BEFORE INSERT ON PAPEL3.ARTICULO FOR EACH ROW
DECLARE
    ACOUNT NUMBER;
    PROVID NUMBER;
    LOCALIDAD VARCHAR(20);
    LOCALIDADNUEVO VARCHAR(20);
BEGIN
    SELECT COUNT (*)
    INTO ACOUNT
    FROM ARTICULO
    WHERE AID = :NEW.AID;

    IF (ACOUNT = 1) THEN
        SELECT PID
        INTO PROVID
        FROM ARTICULO
        WHERE AID = :NEW.AID;

        SELECT PROVINCIA
        INTO LOCALIDAD
        FROM PROVEEDOR
        WHERE PID = PROVID;

        SELECT PROVINCIA
        INTO LOCALIDADNUEVO
        FROM PROVEEDOR
        WHERE PID = :NEW.PID;

        IF(LOCALIDAD = LOCALIDADNUEVO) THEN
            RAISE_APPLICATION_ERROR(-20089,'Los artículos los suministra un solo proveedor por provincia.');
        END IF;
    ELSIF(ACOUNT > 1) THEN
        RAISE_APPLICATION_ERROR(-20090,'Ya hay un proveedor por provincia que suministra el artículo.');
    END IF;
END;
/

--20. Los datos referentes a un artículo, sólo podrán eliminarse de la base de datos, si la
--cantidad total suministrada de ese artículo es 0, o no existe ningún suministro.
CREATE OR REPLACE TRIGGER BORRAR_ARTICULO
BEFORE DELETE ON PAPEL3.ARTICULO FOR EACH ROW 
DECLARE
	ARTICULO_ACTIVO NUMBER;
BEGIN
	SELECT COUNT(*) INTO ARTICULO_ACTIVO
	FROM ENTREGA
	WHERE AID=:OLD.AID AND CANTIDAD != 0;

	IF(ARTICULO_ACTIVO != 0) THEN
		RAISE_APPLICATION_ERROR(-20091,'Este articulo no puede eliminarse, sigue activo');
    END IF;
END;
/

-- 14. El precio por unidad de un artículo para un suministro determinado a un hotel
-- determinado, nunca podrá ser menor que el de ese mismo artículo en suministros
-- anteriores a ese mismo hotel.
CREATE OR REPLACE TRIGGER PRECIO_ENTREGA 
BEFORE INSERT ON PAPEL3.ENTREGA25 FOR EACH ROW
DECLARE
    PRECIO_AUX NUMBER;
BEGIN
    BEGIN
        SELECT PRECIO
        INTO PRECIO_AUX
        FROM ENTREGA
        WHERE   AID = :NEW.AID
                AND HID = :NEW.HID
                AND PID = :NEW.PID
        ORDER BY FECHA ASC;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            PRECIO_AUX := 0;
    END;

    IF(:NEW.PRECIO < PRECIO_AUX) THEN
        RAISE_APPLICATION_ERROR(-20092,'El precio del artículo del suministro no puede ser inferior.');
    END IF;
END;
/

--18. Ningún hotel de las provincias de Córdoba, Sevilla, Cádiz o Huelva podrán
--solicitar artículos a proveedores de Granada.
CREATE OR REPLACE TRIGGER PRODUCTOS_2
BEFORE INSERT ON PAPEL3.ENTREGA25 FOR EACH ROW 
DECLARE
	PROVEEDOR_GRANADA NUMBER;
BEGIN
	SELECT COUNT(*) INTO PROVEEDOR_GRANADA 
	FROM PAPEL1.PROVEEDOR1
	WHERE PID=:NEW.PID;

	IF(PROVEEDOR_GRANADA != 0) THEN
		RAISE_APPLICATION_ERROR(-20093,'Córdoba, Sevilla, Cádiz Y Huelva, no pueden solicitar este proveedor');
    END IF;
END;
/