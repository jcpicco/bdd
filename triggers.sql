-- 4. El número de reservas de un hotel, nunca podrá exceder su capacidad, es decir,
-- nunca se podrá exceder el número de habitaciones sencillas, el número de habitaciones
-- dobles y el número total de habitaciones.
CREATE OR REPLACE TRIGGER CAPACIDAD_RESERVAS_HOTEL
BEFORE INSERT OR UPDATE ON RESERVA17
DECLARE
    NUM_HABS NUMBER;
BEGIN
    IF INSERTING THEN
        IF :NEW.TIPO_HAB = 'Sencilla' THEN
            SELECT N_HAB
            INTO NUM_HABS
            FROM HOTEL17
            WHERE HID = :NEW.HID;

        ELSIF :NEW.TIPO_HAB = 'Doble' THEN
            SELECT N_HAB2
            INTO NUM_HABS
            FROM HOTEL17
            WHERE HID = :NEW.HID;

        ELSE
            RAISE_APPLICATION_ERROR(-20010,'Tipo de habitación no válida');
        ENDIF;
    ENDIF;

    IF (NUM_HABS = 0)
            RAISE_APPLICATION_ERROR(-20011,'No quedan habitaciones de este tipo');
    ENDIF;
END

-- 7. El director de un hotel es un empleado de la multinacional.
-- 8. Un empleado, al mismo tiempo, sólo puede ser director de un hotel.
CREATE OR REPLACE TRIGGER DIRECTOR_HOTEL
BEFORE INSERT OR UPDATE ON HOTEL17
DECLARE
    ECOUNT NUMBER;
BEGIN
    IF INSERTING OR UPDATING THEN
        -- Comprobamos que el director es un empleado.
        SELECT COUNT (*)
        INTO ECOUNT
        FROM EMPLEADO17
        WHERE EID = :NEW.EID;

        IF (ECOUNT = 0)
            RAISE_APPLICATION_ERROR(-20012,'Este empleado no existe');
        ENDIF;

        -- Comprobamos que un empleado sea director de varios hoteles.
        SELECT COUNT (*)
        INTO ECOUNT
        FROM HOTEL17
        WHERE EID = :NEW.EID;

        IF (ECOUNT > 0)
            RAISE_APPLICATION_ERROR(-20013,'Este empleado ya es director de un hotel');
        ENDIF;
    ENDIF;
END

-- 13. El tipo de un artículo será ‘A’, ‘B’, ‘C’ o ‘D’.
CREATE OR REPLACE TRIGGER TIPOS_ARTICULOS
BEFORE INSERT ON articulos FOR EACH ROW 
BEGIN
IF INSERTING THEN
	IF(:NEW.TIPO != "A" OR :NEW.TIPO != "B" OR :NEW.TIPO != "C" OR :NEW.TIPO != "D")
		RAISE_APPLICATION_ERROR(-20009,'El tipo de articulo introducido no se admite en la base de datos');
        ENDIF;
    ENDIF;
END

10 11 12 14 15