-- 1. "Listar los hoteles (nombre y ciudad) de las provincias de Granada, Huelva o Almería,
-- y los proveedores (nombre y ciudad), a los que se le ha suministrado "Queso" o "Mantequilla"
-- entre el 12 de mayo de 2021 y el 28 de mayo de 2021".
SELECT  HOTEL.NOMBRE AS NOMBRE_HOTEL,
        HOTEL.CIUDAD AS CIUDAD_HOTEL,
        ARTICULO.NOMBRE AS ARTICULO
FROM    HOTEL,
        PROVEEDOR,
        ARTICULO,
        ENTREGA       
WHERE   (HOTEL.PROVINCIA = 'Granada' OR HOTEL.PROVINCIA = 'Huelva' OR HOTEL.PROVINCIA = 'Almería')
        AND ENTREGA.HID = HOTEL.HID
        AND ENTREGA.PID = PROVEEDOR.PID
        AND ENTREGA.AID = ARTICULO.AID
        AND ARTICULO.PID = PROVEEDOR.PID
        AND (ARTICULO.NOMBRE = 'Queso' OR ARTICULO.NOMBRE = 'Mantequilla')
        AND ENTREGA.FECHA >= TO_DATE('12052021','DDMMYYYY')
        AND ENTREGA.FECHA <= TO_DATE('28052021','DDMMYYYY');

-- 2. Dado por teclado el código de un proveedor, "Listar los productos (nombre), los hoteles
-- (nombre y ciudad) y la cantidad total de cada producto, suministrados por dicho proveedor a
-- hoteles de las provincias de Jaén o Almería".
ACCEPT COD_PROVEEDOR CHAR PROMPT 'Introduzca el PID deseado: ';
SELECT  ARTICULO.NOMBRE AS NOMBRE_ART,
        HOTEL.NOMBRE AS NOMBRE_HOTEL,
        HOTEL.CIUDAD AS CIUDAD_HOTEL,
        SUM(ENTREGA.CANTIDAD) AS CANTIDAD
FROM    HOTEL,
        PROVEEDOR,
        ARTICULO,
        ENTREGA
WHERE   PROVEEDOR.PID = &COD_PROVEEDOR
        AND (HOTEL.PROVINCIA = 'Jaén' OR HOTEL.PROVINCIA = 'Almería')
        AND ENTREGA.HID = HOTEL.HID
        AND ENTREGA.PID = PROVEEDOR.PID
        AND ENTREGA.AID = ARTICULO.AID
        AND ARTICULO.PID = PROVEEDOR.PID
GROUP BY ARTICULO.NOMBRE,HOTEL.NOMBRE,HOTEL.CIUDAD;


-- 3. Dado por teclado el código de un hotel, "Listar los clientes (nombre y teléfono), que
-- tengan registrada más de una reserva en dicho hotel".
ACCEPT COD_HOTEL CHAR PROMPT 'Introduzca el HID deseado: ';
SELECT  CLIENTE.NOMBRE AS NOMBRE_CLIENTE,
        CLIENTE.TLF AS TLF_CLIENTE
FROM    RESERVA,
        CLIENTE
WHERE   RESERVA.CID = CLIENTE.CID
        AND RESERVA.HID = &COD_HOTEL
GROUP BY    CLIENTE.NOMBRE,
            CLIENTE.TLF
HAVING  COUNT(RESERVA.HID) > 1;