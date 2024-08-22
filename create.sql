-- Table: public.customer_address

-- DROP TABLE IF EXISTS public.customer_address;

CREATE TABLE IF NOT EXISTS public.customer_address
(
    customer_id integer NOT NULL,
    address character varying(100) COLLATE pg_catalog."default",
    city character varying(30) COLLATE pg_catalog."default",
    zipcode character(5) COLLATE pg_catalog."default",
    CONSTRAINT customer_address_pkey PRIMARY KEY (customer_id),
    CONSTRAINT customer_address_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES public.customers (customer_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT zipcodes_zipcode_fkey FOREIGN KEY (zipcode)
        REFERENCES public.zipcodes (zipcode) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customer_address
    OWNER to postgres;


-- Table: public.customers

-- DROP TABLE IF EXISTS public.customers;

CREATE TABLE IF NOT EXISTS public.customers
(
    customer_id integer NOT NULL,
    name character varying(50) COLLATE pg_catalog."default",
    email character varying(50) COLLATE pg_catalog."default",
    phone_number bigint,
    CONSTRAINT customers_pkey PRIMARY KEY (customer_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customers
    OWNER to postgres;


-- Table: public.engines

-- DROP TABLE IF EXISTS public.engines;

CREATE TABLE IF NOT EXISTS public.engines
(
    engine_type character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fuel_type character varying(30) COLLATE pg_catalog."default",
    CONSTRAINT engines_pkey PRIMARY KEY (engine_type)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.engines
    OWNER to postgres;


-- Table: public.price_history

-- DROP TABLE IF EXISTS public.price_history;

CREATE TABLE IF NOT EXISTS public.price_history
(
    vehicle_id integer NOT NULL,
    price_recorded_date date NOT NULL,
    price numeric(12,2),
    CONSTRAINT price_history_pkey PRIMARY KEY (vehicle_id, price_recorded_date),
    CONSTRAINT price_history_vehicle_id_fkey FOREIGN KEY (vehicle_id)
        REFERENCES public.vehicles (vehicle_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.price_history
    OWNER to postgres;
-- Index: price_history_price_idx

-- DROP INDEX IF EXISTS public.price_history_price_idx;

CREATE INDEX IF NOT EXISTS price_history_price_idx
    ON public.price_history USING btree
    (price ASC NULLS LAST)
    TABLESPACE pg_default;


-- Table: public.sales

-- DROP TABLE IF EXISTS public.sales;

CREATE TABLE IF NOT EXISTS public.sales
(
    sale_id integer NOT NULL,
    vehicle_id integer,
    customer_id integer,
    sale_date date,
    sale_price numeric(12,2),
    CONSTRAINT sales_pkey PRIMARY KEY (sale_id),
    CONSTRAINT sales_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES public.customers (customer_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT sales_vehicle_id_fkey FOREIGN KEY (vehicle_id)
        REFERENCES public.vehicles (vehicle_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.sales
    OWNER to postgres;
-- Index: sales_customer_id_idx

-- DROP INDEX IF EXISTS public.sales_customer_id_idx;

CREATE INDEX IF NOT EXISTS sales_customer_id_idx
    ON public.sales USING btree
    (customer_id ASC NULLS LAST)
    TABLESPACE pg_default;


-- Table: public.vehicle_details

-- DROP TABLE IF EXISTS public.vehicle_details;

CREATE TABLE IF NOT EXISTS public.vehicle_details
(
    vehicle_id integer NOT NULL,
    miles_used integer,
    color character varying(50) COLLATE pg_catalog."default",
    engine_type character varying(50) COLLATE pg_catalog."default",
    transmission_type character varying(80) COLLATE pg_catalog."default",
    number_of_seats integer,
    CONSTRAINT vehicle_details_pkey PRIMARY KEY (vehicle_id),
    CONSTRAINT vehicle_details_engine_type_fkey FOREIGN KEY (engine_type)
        REFERENCES public.engines (engine_type) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT vehicle_details_vehicle_id_fkey FOREIGN KEY (vehicle_id)
        REFERENCES public.vehicles (vehicle_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.vehicle_details
    OWNER to postgres;


-- Table: public.vehicle_models

-- DROP TABLE IF EXISTS public.vehicle_models;

CREATE TABLE IF NOT EXISTS public.vehicle_models
(
    model character varying(255) COLLATE pg_catalog."default" NOT NULL,
    make character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT vehicle_models_pkey PRIMARY KEY (model)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.vehicle_models
    OWNER to postgres;
-- Index: vehicle_models_make_idx

-- DROP INDEX IF EXISTS public.vehicle_models_make_idx;

CREATE INDEX IF NOT EXISTS vehicle_models_make_idx
    ON public.vehicle_models USING btree
    (make COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;


-- Table: public.vehicles

-- DROP TABLE IF EXISTS public.vehicles;

CREATE TABLE IF NOT EXISTS public.vehicles
(
    vehicle_id integer NOT NULL,
    type character varying(10) COLLATE pg_catalog."default",
    model character varying(255) COLLATE pg_catalog."default",
    year integer,
    vin character varying(200) COLLATE pg_catalog."default" NOT NULL,
    availability boolean,
    customer_id integer,
    CONSTRAINT vehicles_pkey PRIMARY KEY (vehicle_id),
    CONSTRAINT vehicles_vin_key UNIQUE (vin),
    CONSTRAINT vehicle_models_model_fkey FOREIGN KEY (model)
        REFERENCES public.vehicle_models (model) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT vehicles_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES public.customers (customer_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT vehicles_type_check CHECK (type::text = ANY (ARRAY['new'::character varying::text, 'used'::character varying::text]))
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.vehicles
    OWNER to postgres;
-- Index: vehicles_availability_idx

-- DROP INDEX IF EXISTS public.vehicles_availability_idx;

CREATE INDEX IF NOT EXISTS vehicles_availability_idx
    ON public.vehicles USING btree
    (availability ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: vehicles_model_idx

-- DROP INDEX IF EXISTS public.vehicles_model_idx;

CREATE INDEX IF NOT EXISTS vehicles_model_idx
    ON public.vehicles USING btree
    (model COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: vehicles_type_idx

-- DROP INDEX IF EXISTS public.vehicles_type_idx;

CREATE INDEX IF NOT EXISTS vehicles_type_idx
    ON public.vehicles USING btree
    (type COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;


-- Table: public.zipcodes

-- DROP TABLE IF EXISTS public.zipcodes;

CREATE TABLE IF NOT EXISTS public.zipcodes
(
    zipcode character(5) COLLATE pg_catalog."default" NOT NULL,
    state character varying(30) COLLATE pg_catalog."default",
    CONSTRAINT zipcodes_pkey PRIMARY KEY (zipcode)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.zipcodes
    OWNER to postgres;
