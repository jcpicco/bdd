DROP VIEW EMPLEADO;

DROP VIEW ENTREGA;

DROP VIEW HOTEL;

DROP VIEW PROVEEDOR;

DROP VIEW RESERVA;

DROP VIEW HISTORIAL;

-- EMPLEADO
CREATE OR REPLACE VIEW EMPLEADO AS
SELECT * FROM PAPEL1.EMPLEADO17
UNION
SELECT * FROM PAPEL2.EMPLEADO36
UNION
SELECT * FROM PAPEL3.EMPLEADO25
UNION
SELECT * FROM PAPEL4.EMPLEADO48;

-- RESERVA
CREATE OR REPLACE VIEW RESERVA AS
SELECT * FROM PAPEL1.RESERVA17
UNION
SELECT * FROM PAPEL2.RESERVA36
UNION
SELECT * FROM PAPEL3.RESERVA25
UNION
SELECT * FROM PAPEL4.RESERVA48;

-- HOTEL
CREATE OR REPLACE VIEW HOTEL AS
SELECT * FROM PAPEL1.HOTEL17
UNION
SELECT * FROM PAPEL2.HOTEL36
UNION
SELECT * FROM PAPEL3.HOTEL25
UNION
SELECT * FROM PAPEL4.HOTEL48;

-- ENTREGA
CREATE OR REPLACE VIEW ENTREGA AS
SELECT * FROM PAPEL1.ENTREGA17
UNION
SELECT * FROM PAPEL2.ENTREGA36
UNION
SELECT * FROM PAPEL3.ENTREGA25
UNION
SELECT * FROM PAPEL4.ENTREGA48;

-- PROVEEDOR
CREATE OR REPLACE VIEW PROVEEDOR AS
SELECT * FROM PAPEL1.PROVEEDOR1
UNION
SELECT * FROM PAPEL3.PROVEEDOR2;

-- HISTORIAL
CREATE OR REPLACE VIEW HISTORIAL AS
SELECT * FROM PAPEL3.HISTORICO;