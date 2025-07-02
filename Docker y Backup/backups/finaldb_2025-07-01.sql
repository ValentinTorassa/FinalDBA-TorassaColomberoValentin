--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Debian 15.13-1.pgdg120+1)
-- Dumped by pg_dump version 15.13 (Debian 15.13-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: actualizar_acumulado(); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.actualizar_acumulado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE clientes
SET acumulado_compras = acumulado_compras + NEW.importe
WHERE id_cliente = NEW.id_cliente;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_acumulado() OWNER TO admin;

--
-- Name: calcular_base_imponible(integer); Type: FUNCTION; Schema: public; Owner: admin
--

CREATE FUNCTION public.calcular_base_imponible(nro integer) RETURNS TABLE(nro_comprobante integer, fecha date, cliente text, tipo_comprobante text, importe numeric, base_imponible numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
RETURN QUERY
SELECT
c.nro_comprobante,
c.fecha,
cl.apellido_nombre,
tc.descrip_comprobante,
c.importe,
ROUND(c.importe / 1.21, 2) AS base_imponible
FROM comprobantes c
JOIN clientes cl ON c.id_cliente = cl.id_cliente
JOIN tipos_comprobantes tc ON c.id_tipo_comprobante =
tc.id_tipo_comprobante
WHERE c.nro_comprobante = nro;
END;
$$;


ALTER FUNCTION public.calcular_base_imponible(nro integer) OWNER TO admin;

--
-- Name: total_facturado_rango(date, date); Type: PROCEDURE; Schema: public; Owner: admin
--

CREATE PROCEDURE public.total_facturado_rango(IN fecha_inicio date, IN fecha_fin date)
    LANGUAGE plpgsql
    AS $$
BEGIN
RAISE NOTICE 'Total facturado del % al %: %',
fecha_inicio,
fecha_fin,
COALESCE((
SELECT SUM(importe)
FROM comprobantes
WHERE fecha BETWEEN fecha_inicio AND fecha_fin
), 0);
END;
$$;


ALTER PROCEDURE public.total_facturado_rango(IN fecha_inicio date, IN fecha_fin date) OWNER TO admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: clientes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.clientes (
    id_cliente integer NOT NULL,
    apellido_nombre text NOT NULL,
    id_tipo_documento integer NOT NULL,
    nro_documento character varying(20) NOT NULL,
    acumulado_compras numeric(12,2) DEFAULT 0
);


ALTER TABLE public.clientes OWNER TO admin;

--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.clientes_id_cliente_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clientes_id_cliente_seq OWNER TO admin;

--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.clientes_id_cliente_seq OWNED BY public.clientes.id_cliente;


--
-- Name: comprobantes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.comprobantes (
    nro_comprobante integer NOT NULL,
    fecha date NOT NULL,
    id_tipo_comprobante integer NOT NULL,
    id_cliente integer NOT NULL,
    importe numeric(12,2) NOT NULL
);


ALTER TABLE public.comprobantes OWNER TO admin;

--
-- Name: comprobantes_nro_comprobante_seq; Type: SEQUENCE; Schema: public; Owner: admin
--

CREATE SEQUENCE public.comprobantes_nro_comprobante_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.comprobantes_nro_comprobante_seq OWNER TO admin;

--
-- Name: comprobantes_nro_comprobante_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: admin
--

ALTER SEQUENCE public.comprobantes_nro_comprobante_seq OWNED BY public.comprobantes.nro_comprobante;


--
-- Name: tipos_comprobantes; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.tipos_comprobantes (
    id_tipo_comprobante integer NOT NULL,
    descrip_comprobante text NOT NULL
);


ALTER TABLE public.tipos_comprobantes OWNER TO admin;

--
-- Name: tipos_documentos; Type: TABLE; Schema: public; Owner: admin
--

CREATE TABLE public.tipos_documentos (
    id_tipo_documento integer NOT NULL,
    descrip_documento text NOT NULL
);


ALTER TABLE public.tipos_documentos OWNER TO admin;

--
-- Name: vista_comprobantes_detallada; Type: VIEW; Schema: public; Owner: admin
--

CREATE VIEW public.vista_comprobantes_detallada AS
 SELECT c.nro_comprobante,
    c.fecha,
    cl.apellido_nombre AS cliente,
    cl.nro_documento,
    tc.descrip_comprobante,
    c.importe
   FROM ((public.comprobantes c
     JOIN public.clientes cl ON ((c.id_cliente = cl.id_cliente)))
     JOIN public.tipos_comprobantes tc ON ((c.id_tipo_comprobante = tc.id_tipo_comprobante)));


ALTER TABLE public.vista_comprobantes_detallada OWNER TO admin;

--
-- Name: vista_totales_por_cliente; Type: VIEW; Schema: public; Owner: admin
--

CREATE VIEW public.vista_totales_por_cliente AS
 SELECT cl.id_cliente,
    cl.apellido_nombre,
    sum(c.importe) AS total_facturado
   FROM (public.comprobantes c
     JOIN public.clientes cl ON ((c.id_cliente = cl.id_cliente)))
  GROUP BY cl.id_cliente, cl.apellido_nombre
  ORDER BY (sum(c.importe)) DESC;


ALTER TABLE public.vista_totales_por_cliente OWNER TO admin;

--
-- Name: clientes id_cliente; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id_cliente SET DEFAULT nextval('public.clientes_id_cliente_seq'::regclass);


--
-- Name: comprobantes nro_comprobante; Type: DEFAULT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.comprobantes ALTER COLUMN nro_comprobante SET DEFAULT nextval('public.comprobantes_nro_comprobante_seq'::regclass);


--
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.clientes (id_cliente, apellido_nombre, id_tipo_documento, nro_documento, acumulado_compras) FROM stdin;
1	Luke Skywalker	1	10000001	0.00
2	Darth Vader	3	20000001	0.00
3	Obi-Wan Kenobi	1	10000003	0.00
4	Han Solo	1	10000004	0.00
5	Padmé Amidala	1	10000005	0.00
6	Anakin Skywalker	1	10000006	0.00
7	Leia Organa	1	10000002	0.00
8	Homero Simpson	1	30000001	0.00
9	Montgomery Burns	3	40000001	0.00
10	Jill Valentine	1	50000001	0.00
11	Leon S. Kennedy	1	50000002	0.00
12	Albert Wesker	3	50000003	0.00
13	Geralt of Rivia	5	60000001	0.00
14	Ellie Williams	1	70000001	0.00
15	Mario Bros	0	00000001	0.00
\.


--
-- Data for Name: comprobantes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.comprobantes (nro_comprobante, fecha, id_tipo_comprobante, id_cliente, importe) FROM stdin;
1	2025-06-18	1	1	15000.00
2	2025-06-19	3	1	-3000.00
3	2025-06-18	2	2	10000.00
4	2025-06-20	1	4	7200.00
5	2020-06-20	6	5	9500.00
6	2022-06-21	13	5	-1200.00
7	2018-06-18	83	6	8700.00
8	2029-09-22	4	7	1800.00
9	2001-01-08	6	8	4500.50
10	2022-01-09	12	8	-800.00
11	2025-07-19	5	9	10000.00
12	2010-07-22	11	11	8400.00
13	2025-03-30	13	11	-500.00
14	2025-06-24	3	12	-2200.00
15	2025-06-18	82	13	1200.00
16	2025-06-18	1	15	5000.00
\.


--
-- Data for Name: tipos_comprobantes; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.tipos_comprobantes (id_tipo_comprobante, descrip_comprobante) FROM stdin;
1	Factura A
2	Nota Debito A
3	Nota Credito A
4	Recibos A
5	Nota Venta Contado A
6	Factura B
7	Nota Debito B
8	Nota Credito B
9	Recibo B
10	Nota Venta Contado B
11	Facturas C
12	Nota Debito C
13	Nota Credito C
15	Recibo C
16	Nota Venta Contado C
81	Tique Factura A
82	Tique Factura B
83	Tique
111	Tique Factura C
112	Tique Nota Credito A
113	Tique Nota Credito B
114	Tique Nota Credito C
\.


--
-- Data for Name: tipos_documentos; Type: TABLE DATA; Schema: public; Owner: admin
--

COPY public.tipos_documentos (id_tipo_documento, descrip_documento) FROM stdin;
0	Ningun Documento
1	D.N.I.
2	C.U.I.L.
3	C.U.I.T.
4	Cedula de Identificacion
5	Pasaporte
6	Libreta Civica
7	Libreta de Enrolamiento
\.


--
-- Name: clientes_id_cliente_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.clientes_id_cliente_seq', 15, true);


--
-- Name: comprobantes_nro_comprobante_seq; Type: SEQUENCE SET; Schema: public; Owner: admin
--

SELECT pg_catalog.setval('public.comprobantes_nro_comprobante_seq', 16, true);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente);


--
-- Name: comprobantes comprobantes_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.comprobantes
    ADD CONSTRAINT comprobantes_pkey PRIMARY KEY (nro_comprobante);


--
-- Name: tipos_comprobantes tipos_comprobantes_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tipos_comprobantes
    ADD CONSTRAINT tipos_comprobantes_pkey PRIMARY KEY (id_tipo_comprobante);


--
-- Name: tipos_documentos tipos_documentos_pkey; Type: CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.tipos_documentos
    ADD CONSTRAINT tipos_documentos_pkey PRIMARY KEY (id_tipo_documento);


--
-- Name: comprobantes trg_actualizar_acumulado; Type: TRIGGER; Schema: public; Owner: admin
--

CREATE TRIGGER trg_actualizar_acumulado AFTER INSERT ON public.comprobantes FOR EACH ROW EXECUTE FUNCTION public.actualizar_acumulado();


--
-- Name: clientes clientes_id_tipo_documento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_id_tipo_documento_fkey FOREIGN KEY (id_tipo_documento) REFERENCES public.tipos_documentos(id_tipo_documento);


--
-- Name: comprobantes comprobantes_id_cliente_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.comprobantes
    ADD CONSTRAINT comprobantes_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente);


--
-- Name: comprobantes comprobantes_id_tipo_comprobante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: admin
--

ALTER TABLE ONLY public.comprobantes
    ADD CONSTRAINT comprobantes_id_tipo_comprobante_fkey FOREIGN KEY (id_tipo_comprobante) REFERENCES public.tipos_comprobantes(id_tipo_comprobante);


--
-- PostgreSQL database dump complete
--

