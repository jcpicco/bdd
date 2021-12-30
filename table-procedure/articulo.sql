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