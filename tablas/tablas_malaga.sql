CREATE TABLE HOTEL48(
	HID NUMBER NOT NULL,
	EID NUMBER NOT NULL,
	NOMBRE VARCHAR(50) NOT NULL,
	CIUDAD VARCHAR(20) NOT NULL,
	PROVINCIA VARCHAR(10) NOT NULL,
	N_HAB NUMBER NOT NULL,
	N_HAB2 NUMBER NOT NULL,
	PRIMARY KEY(HID)
);

CREATE TABLE PROVEEDOR1(
	PID NUMBER NOT NULL,
	NOMBRE VARCHAR(50) NOT NULL,
	PROVINCIA VARCHAR(10) NOT NULL,
	PRIMARY KEY(PID)
);

CREATE TABLE EMPLEADO48(
	EID NUMBER NOT NULL,
	HID NUMBER NOT NULL REFERENCES HOTEL48(HID),
	NOMBRE VARCHAR(50) NOT NULL,
	DIRECCION VARCHAR(70) NOT NULL,
	SALARIO NUMBER NOT NULL,
	DNI NUMBER NOT NULL,
	TLF NUMBER NOT NULL,
	FECHA_INI DATE NOT NULL,
	PRIMARY KEY(EID)
);

CREATE TABLE ENTREGA48(
	HID NUMBER NOT NULL REFERENCES HOTEL48(HID),
	FECHA DATE NOT NULL,
	PRECIO NUMBER NOT NULL,
CANTIDAD NUMBER NOT NULL,
	PRIMARY KEY(HID, FECHA)
);

CREATE TABLE CLIENTE(
	CID NUMBER NOT NULL,
	NOMBRE VARCHAR(50) NOT NULL,
	DNI NUMBER NOT NULL,
	TLF NUMBER NOT NULL,
	PRIMARY KEY(CID)
);

CREATE TABLE RESERVA48(
	CID NUMBER NOT NULL REFERENCES CLIENTE(CID),
	HID NUMBER NOT NULL REFERENCES HOTEL48(HID),
	FECHA_FIN DATE NOT NULL,
	FECHA_INI DATE NOT NULL,
	TIPO_HAB NUMBER NOT NULL,
	PRECIO NUMBER NOT NULL,
	PRIMARY KEY(CID, HID, FECHA_FIN, FECHA_INI)
);

CREATE TABLE ARTICULO(
	PID NUMBER NOT NULL REFERENCES PROVEEDOR1(PID),
	AID NUMBER NOT NULL,
	NOMBRE VARCHAR(50) NOT NULL,
	TIPO VARCHAR(50) NOT NULL,
	PRIMARY KEY(PID, AID)
);
