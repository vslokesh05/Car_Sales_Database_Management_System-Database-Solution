--
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.1
-- Dumped by pg_dump version 16.1

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

DROP DATABASE "DMQL Updated";
--
-- Name: DMQL Updated; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "DMQL Updated" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE "DMQL Updated" OWNER TO postgres;

\connect -reuse-previous=on "dbname='DMQL Updated'"

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: customer_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_address (
    customer_id integer NOT NULL,
    address character varying(100),
    city character varying(30),
    zipcode character(5)
);


ALTER TABLE public.customer_address OWNER TO postgres;

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id integer NOT NULL,
    name character varying(50),
    email character varying(50),
    phone_number bigint
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- Name: engines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.engines (
    engine_type character varying(50) NOT NULL,
    fuel_type character varying(30)
);


ALTER TABLE public.engines OWNER TO postgres;

--
-- Name: price_history; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.price_history (
    vehicle_id integer NOT NULL,
    price_recorded_date date NOT NULL,
    price numeric(12,2)
);


ALTER TABLE public.price_history OWNER TO postgres;

--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sales (
    sale_id integer NOT NULL,
    vehicle_id integer,
    customer_id integer,
    sale_date date,
    sale_price numeric(12,2)
);


ALTER TABLE public.sales OWNER TO postgres;

--
-- Name: vehicle_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle_details (
    vehicle_id integer NOT NULL,
    miles_used integer,
    color character varying(50),
    engine_type character varying(50),
    transmission_type character varying(80),
    number_of_seats integer
);


ALTER TABLE public.vehicle_details OWNER TO postgres;

--
-- Name: vehicle_models; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicle_models (
    model character varying(255) NOT NULL,
    make character varying(255)
);


ALTER TABLE public.vehicle_models OWNER TO postgres;

--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicles (
    vehicle_id integer NOT NULL,
    type character varying(10),
    model character varying(255),
    year integer,
    vin character varying(200) NOT NULL,
    availability boolean,
    customer_id integer,
    CONSTRAINT vehicles_type_check CHECK (((type)::text = ANY (ARRAY[('new'::character varying)::text, ('used'::character varying)::text])))
);


ALTER TABLE public.vehicles OWNER TO postgres;

--
-- Name: zipcodes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.zipcodes (
    zipcode character(5) NOT NULL,
    state character varying(30)
);


ALTER TABLE public.zipcodes OWNER TO postgres;

--
-- Data for Name: customer_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_address (customer_id, address, city, zipcode) FROM stdin;
\.
COPY public.customer_address (customer_id, address, city, zipcode) FROM '$$PATH$$/4899.dat';

--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, name, email, phone_number) FROM stdin;
\.
COPY public.customers (customer_id, name, email, phone_number) FROM '$$PATH$$/4898.dat';

--
-- Data for Name: engines; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.engines (engine_type, fuel_type) FROM stdin;
\.
COPY public.engines (engine_type, fuel_type) FROM '$$PATH$$/4903.dat';

--
-- Data for Name: price_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.price_history (vehicle_id, price_recorded_date, price) FROM stdin;
\.
COPY public.price_history (vehicle_id, price_recorded_date, price) FROM '$$PATH$$/4906.dat';

--
-- Data for Name: sales; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sales (sale_id, vehicle_id, customer_id, sale_date, sale_price) FROM stdin;
\.
COPY public.sales (sale_id, vehicle_id, customer_id, sale_date, sale_price) FROM '$$PATH$$/4905.dat';

--
-- Data for Name: vehicle_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_details (vehicle_id, miles_used, color, engine_type, transmission_type, number_of_seats) FROM stdin;
\.
COPY public.vehicle_details (vehicle_id, miles_used, color, engine_type, transmission_type, number_of_seats) FROM '$$PATH$$/4904.dat';

--
-- Data for Name: vehicle_models; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicle_models (model, make) FROM stdin;
\.
COPY public.vehicle_models (model, make) FROM '$$PATH$$/4901.dat';

--
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicles (vehicle_id, type, model, year, vin, availability, customer_id) FROM stdin;
\.
COPY public.vehicles (vehicle_id, type, model, year, vin, availability, customer_id) FROM '$$PATH$$/4902.dat';

--
-- Data for Name: zipcodes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.zipcodes (zipcode, state) FROM stdin;
\.
COPY public.zipcodes (zipcode, state) FROM '$$PATH$$/4900.dat';

--
-- Name: customer_address customer_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_pkey PRIMARY KEY (customer_id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- Name: engines engines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.engines
    ADD CONSTRAINT engines_pkey PRIMARY KEY (engine_type);


--
-- Name: price_history price_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT price_history_pkey PRIMARY KEY (vehicle_id, price_recorded_date);


--
-- Name: sales sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (sale_id);


--
-- Name: vehicle_details vehicle_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_details
    ADD CONSTRAINT vehicle_details_pkey PRIMARY KEY (vehicle_id);


--
-- Name: vehicle_models vehicle_models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_models
    ADD CONSTRAINT vehicle_models_pkey PRIMARY KEY (model);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (vehicle_id);


--
-- Name: vehicles vehicles_vin_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_vin_key UNIQUE (vin);


--
-- Name: zipcodes zipcodes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.zipcodes
    ADD CONSTRAINT zipcodes_pkey PRIMARY KEY (zipcode);


--
-- Name: price_history_price_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX price_history_price_idx ON public.price_history USING btree (price);


--
-- Name: sales_customer_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX sales_customer_id_idx ON public.sales USING btree (customer_id);


--
-- Name: vehicle_models_make_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vehicle_models_make_idx ON public.vehicle_models USING btree (make);


--
-- Name: vehicles_availability_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vehicles_availability_idx ON public.vehicles USING btree (availability);


--
-- Name: vehicles_model_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vehicles_model_idx ON public.vehicles USING btree (model);


--
-- Name: vehicles_type_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX vehicles_type_idx ON public.vehicles USING btree (type);


--
-- Name: customer_address customer_address_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT customer_address_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: price_history price_history_vehicle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT price_history_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(vehicle_id);


--
-- Name: sales sales_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: sales sales_vehicle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sales
    ADD CONSTRAINT sales_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(vehicle_id);


--
-- Name: vehicle_details vehicle_details_engine_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_details
    ADD CONSTRAINT vehicle_details_engine_type_fkey FOREIGN KEY (engine_type) REFERENCES public.engines(engine_type) NOT VALID;


--
-- Name: vehicle_details vehicle_details_vehicle_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicle_details
    ADD CONSTRAINT vehicle_details_vehicle_id_fkey FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(vehicle_id);


--
-- Name: vehicles vehicle_models_model_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicle_models_model_fkey FOREIGN KEY (model) REFERENCES public.vehicle_models(model);


--
-- Name: vehicles vehicles_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- Name: customer_address zipcodes_zipcode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_address
    ADD CONSTRAINT zipcodes_zipcode_fkey FOREIGN KEY (zipcode) REFERENCES public.zipcodes(zipcode) NOT VALID;


--
-- PostgreSQL database dump complete
--

