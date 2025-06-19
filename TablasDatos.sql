CREATE TABLE tipos_documentos (
    id_tipo_documento INT PRIMARY KEY,
    descrip_documento TEXT NOT NULL
);

CREATE TABLE tipos_comprobantes (
    id_tipo_comprobante INT PRIMARY KEY,
    descrip_comprobante TEXT NOT NULL
);

CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    apellido_nombre TEXT NOT NULL,
    id_tipo_documento INT NOT NULL,
    nro_documento VARCHAR(20) NOT NULL,
    acumulado_compras NUMERIC(12,2) DEFAULT 0,
    FOREIGN KEY (id_tipo_documento) REFERENCES tipos_documentos(id_tipo_documento)
);

CREATE TABLE comprobantes (
    nro_comprobante SERIAL PRIMARY KEY,
    fecha DATE NOT NULL,
    id_tipo_comprobante INT NOT NULL,
    id_cliente INTEGER NOT NULL,
    importe NUMERIC(12,2) NOT NULL,
    FOREIGN KEY (id_tipo_comprobante) REFERENCES tipos_comprobantes(id_tipo_comprobante),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);


INSERT INTO tipos_documentos (id_tipo_documento, descrip_documento) VALUES
(0, 'Ningun Documento'),
(1, 'D.N.I.'),
(2, 'C.U.I.L.'),
(3, 'C.U.I.T.'),
(4, 'Cedula de Identificacion'),
(5, 'Pasaporte'),
(6, 'Libreta Civica'),
(7, 'Libreta de Enrolamiento');


INSERT INTO tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) VALUES
(1, 'Factura A'),
(2, 'Nota Debito A'),
(3, 'Nota Credito A'),
(4, 'Recibos A'),
(5, 'Nota Venta Contado A'),
(6, 'Factura B'),
(7, 'Nota Debito B'),
(8, 'Nota Credito B'),
(9, 'Recibo B'),
(10, 'Nota Venta Contado B'),
(11, 'Facturas C'),
(12, 'Nota Debito C'),
(13, 'Nota Credito C'),
(15, 'Recibo C'),
(16, 'Nota Venta Contado C'),
(81, 'Tique Factura A'),
(82, 'Tique Factura B'),
(83, 'Tique'),
(111, 'Tique Factura C'),
(112, 'Tique Nota Credito A'),
(113, 'Tique Nota Credito B'),
(114, 'Tique Nota Credito C');


INSERT INTO clientes (apellido_nombre, id_tipo_documento, nro_documento) VALUES
('Luke Skywalker', 1, '10000001'),
('Darth Vader', 3, '20000001'),
('Obi-Wan Kenobi', 1, '10000003'),
('Han Solo', 1, '10000004'),
('Padmé Amidala', 1, '10000005'),
('Anakin Skywalker', 1, '10000006'),
('Leia Organa', 1, '10000002'),
('Homero Simpson', 1, '30000001'),
('Montgomery Burns', 3, '40000001'),
('Jill Valentine', 1, '50000001'),
('Leon S. Kennedy', 1, '50000002'),
('Albert Wesker', 3, '50000003'),
('Geralt of Rivia', 5, '60000001'),      
('Ellie Williams', 1, '70000001'),        
('Mario Bros', 0, '00000001');           


INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2025-06-18', 1, 1, 15000.00),
('2025-06-19', 3, 1, -3000.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2025-06-18', 2, 2, 10000.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2025-06-20', 1, 4, 7200.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2020-06-20', 6, 5, 9500.00),
('2022-06-21', 13, 5, -1200.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2018-06-18', 83, 6, 8700.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2029-09-22', 4, 7, 1800.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2001-01-08', 6, 8, 4500.50),
('2022-01-09', 12, 8, -800.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2025-07-19', 5, 9, 10000.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2010-07-22', 11, 11, 8400.00),
('2025-03-30', 13, 11, -500.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2025-06-24', 3, 12, -2200.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2025-06-18', 82, 13, 1200.00);

INSERT INTO comprobantes (fecha, id_tipo_comprobante, id_cliente, importe) VALUES
('2025-06-18', 1, 15, 5000.00);
