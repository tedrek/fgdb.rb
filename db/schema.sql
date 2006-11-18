--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pgsql
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: contact_method_types; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE contact_method_types (
    id serial NOT NULL,
    description character varying(100),
    parent_id integer,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: TABLE contact_method_types; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE contact_method_types IS 'types of ways we can contact someone, i.e. phone, email website, online chat name -- not physical address';


--
-- Name: contact_methods; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE contact_methods (
    id serial NOT NULL,
    contact_method_type_id integer,
    description character varying(100),
    ok boolean,
    contact_id integer,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: TABLE contact_methods; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE contact_methods IS 'actual ways a specific contact can be contacted (i.e. phone, email, etc.) note: not physical address';


--
-- Name: contact_types; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE contact_types (
    id serial NOT NULL,
    description character varying(100),
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: TABLE contact_types; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE contact_types IS 'types of contacts we track, for instance media contact, member, organization';


--
-- Name: contact_types_contacts; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE contact_types_contacts (
    contact_id integer DEFAULT 0 NOT NULL,
    contact_type_id integer DEFAULT 0 NOT NULL
);


--
-- Name: contacts; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE contacts (
    id serial NOT NULL,
    is_organization boolean DEFAULT false,
    sort_name character varying(25),
    first_name character varying(25),
    middle_name character varying(25),
    surname character varying(50),
    organization character varying(100),
    extra_address character varying(52),
    address character varying(52),
    city character varying(30),
    state_or_province character varying(15),
    postal_code character varying(25),
    country character varying(100),
    notes text,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: discount_schedules; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE discount_schedules (
    id serial NOT NULL,
    short_name character varying(25),
    donated_item_rate numeric(10,2) DEFAULT 0,
    resale_item_rate numeric(10,2) DEFAULT 0,
    description character varying(100),
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: TABLE discount_schedules; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE discount_schedules IS 'discount schedules and their discount percents';


--
-- Name: donations; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE donations (
    id serial NOT NULL,
    contact_id integer,
    payment_method_id integer,
    money_tendered numeric(10,2) DEFAULT 0.0,
    postal_code character varying(25),
    reported_required_fee numeric(10,2) DEFAULT 0.0,
    reported_suggested_fee numeric(10,2) DEFAULT 0.0,
    txn_complete boolean DEFAULT true,
    txn_completed_at timestamp with time zone DEFAULT now(),
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: forsale_items; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE forsale_items (
    id serial NOT NULL,
    source_type_id integer,
    description character varying(100) NOT NULL,
    price numeric(10,2) DEFAULT 9.99,
    onhand_qty integer,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: TABLE forsale_items; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE forsale_items IS 'items for sale; not intended as inventory';


--
-- Name: gizmo_attrs; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE gizmo_attrs (
    id serial NOT NULL,
    name character varying(100),
    datatype character varying(10),
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: gizmo_contexts; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE gizmo_contexts (
    id serial NOT NULL,
    name character varying(100),
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: gizmo_contexts_gizmo_typeattrs; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE gizmo_contexts_gizmo_typeattrs (
    gizmo_context_id integer NOT NULL,
    gizmo_typeattr_id integer NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: gizmo_contexts_gizmo_types; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE gizmo_contexts_gizmo_types (
    gizmo_context_id integer NOT NULL,
    gizmo_type_id integer NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: gizmo_events; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE gizmo_events (
    id serial NOT NULL,
    donation_id integer,
    sale_txn_id integer,
    grant_id integer,
    recycling_id integer,
    gizmo_type_id integer NOT NULL,
    gizmo_context_id integer NOT NULL,
    gizmo_count integer NOT NULL,
    comments character varying(100),
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: gizmo_events_gizmo_typeattrs; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE gizmo_events_gizmo_typeattrs (
    id serial NOT NULL,
    gizmo_event_id integer NOT NULL,
    gizmo_typeattr_id integer NOT NULL,
    attr_val_text text,
    attr_val_boolean boolean,
    attr_val_integer integer,
    attr_val_monetary numeric(10,2),
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: gizmo_typeattrs; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE gizmo_typeattrs (
    id serial NOT NULL,
    gizmo_type_id integer NOT NULL,
    gizmo_attr_id integer NOT NULL,
    is_required boolean DEFAULT true NOT NULL,
    validation_callback text,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: gizmo_types; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE gizmo_types (
    id serial NOT NULL,
    description character varying(100),
    parent_id integer,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL,
    required_fee numeric(10,2) DEFAULT 0.0,
    suggested_fee numeric(10,2) DEFAULT 0.0,
    discounts_apply boolean DEFAULT true NOT NULL
);


--
-- Name: gps; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE gps (
    money_tendered numeric(10,2),
    updated_at timestamp with time zone,
    reported_required_fee numeric(10,2),
    reported_suggested_fee numeric(10,2),
    txn_complete boolean,
    txn_completed_at timestamp with time zone,
    id integer DEFAULT nextval('public.gps_id_seq'::text) NOT NULL
);


--
-- Name: TABLE gps; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE gps IS 'development temp table, delete before production use';


--
-- Name: payment_methods; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE payment_methods (
    id serial NOT NULL,
    description character varying(100),
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: relationship_types; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE relationship_types (
    id serial NOT NULL,
    description character varying(100),
    direction_matters boolean,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: TABLE relationship_types; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE relationship_types IS 'abstract type of relationships that can exist between contacts, i.e. sibling, parent-child, spouse, employer-employee';


--
-- Name: relationships; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE relationships (
    id serial NOT NULL,
    source_id integer,
    sink_id integer,
    flow integer,
    relationship_type_id integer,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: TABLE relationships; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE relationships IS 'actual relationship between two contacts';


--
-- Name: sale_txns; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE sale_txns (
    id serial NOT NULL,
    contact_id integer NOT NULL,
    payment_method_id integer NOT NULL,
    gross_amount numeric(10,2) DEFAULT 0.0 NOT NULL,
    discount_schedule_id integer DEFAULT 1 NOT NULL,
    discount_amount numeric(10,2) DEFAULT 0.0,
    amount_due numeric(10,2) DEFAULT 0.0 NOT NULL,
    comments character varying(100) NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: TABLE sale_txns; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE sale_txns IS 'each record represents one sales transaction';


--
-- Name: source_types; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE source_types (
    id serial NOT NULL,
    description character varying(100),
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: TABLE source_types; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE source_types IS 'sources of items for sale: store, other';


--
-- Name: till_handlers; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE till_handlers (
    id serial NOT NULL,
    description character varying(100) NOT NULL,
    contact_id integer,
    can_alter_price boolean DEFAULT false NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: TABLE till_handlers; Type: COMMENT; Schema: public; Owner: fgdbdev
--

COMMENT ON TABLE till_handlers IS 'identifies those who operate the till';


--
-- Name: volunteer_task_types; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE volunteer_task_types (
    id serial NOT NULL,
    description character varying(100),
    parent_id integer,
    hours_multiplier integer DEFAULT 1 NOT NULL,
    instantiable boolean DEFAULT true NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL,
    required boolean DEFAULT true NOT NULL
);


--
-- Name: volunteer_task_types_volunteer_tasks; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE volunteer_task_types_volunteer_tasks (
    volunteer_task_id integer NOT NULL,
    volunteer_task_type_id integer NOT NULL
);


--
-- Name: volunteer_tasks; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE volunteer_tasks (
    id serial NOT NULL,
    contact_id integer,
    date_performed date DEFAULT now(),
    duration numeric(5,2) DEFAULT 0.00 NOT NULL,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);


--
-- Name: contact_types_contacts_contact_id_key; Type: CONSTRAINT; Schema: public; Owner: fgdbdev; Tablespace: 
--

ALTER TABLE ONLY contact_types_contacts
    ADD CONSTRAINT contact_types_contacts_contact_id_key UNIQUE (contact_id, contact_type_id);


--
-- Name: pk_contact_method_types; Type: CONSTRAINT; Schema: public; Owner: fgdbdev; Tablespace: 
--

ALTER TABLE ONLY contact_method_types
    ADD CONSTRAINT pk_contact_method_types PRIMARY KEY (id);


--
-- Name: pk_contact_methods; Type: CONSTRAINT; Schema: public; Owner: fgdbdev; Tablespace: 
--

ALTER TABLE ONLY contact_methods
    ADD CONSTRAINT pk_contact_methods PRIMARY KEY (id);


--
-- Name: pk_contact_types; Type: CONSTRAINT; Schema: public; Owner: fgdbdev; Tablespace: 
--

ALTER TABLE ONLY contact_types
    ADD CONSTRAINT pk_contact_types PRIMARY KEY (id);


--
-- Name: pk_contacts; Type: CONSTRAINT; Schema: public; Owner: fgdbdev; Tablespace: 
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT pk_contacts PRIMARY KEY (id);


--
-- Name: pk_relationship_types; Type: CONSTRAINT; Schema: public; Owner: fgdbdev; Tablespace: 
--

ALTER TABLE ONLY relationship_types
    ADD CONSTRAINT pk_relationship_types PRIMARY KEY (id);


--
-- Name: pk_relationships; Type: CONSTRAINT; Schema: public; Owner: fgdbdev; Tablespace: 
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT pk_relationships PRIMARY KEY (id);


--
-- Name: contact_methods_fk_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: fgdbdev
--

ALTER TABLE ONLY contact_methods
    ADD CONSTRAINT contact_methods_fk_contact_id FOREIGN KEY (contact_id) REFERENCES contacts(id) ON DELETE SET NULL;


--
-- Name: contact_methods_fk_contact_method_type; Type: FK CONSTRAINT; Schema: public; Owner: fgdbdev
--

ALTER TABLE ONLY contact_methods
    ADD CONSTRAINT contact_methods_fk_contact_method_type FOREIGN KEY (contact_method_type_id) REFERENCES contact_method_types(id) ON DELETE SET NULL;


--
-- Name: relationships_fk_relationship_type; Type: FK CONSTRAINT; Schema: public; Owner: fgdbdev
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT relationships_fk_relationship_type FOREIGN KEY (relationship_type_id) REFERENCES relationship_types(id) ON DELETE SET NULL;


--
-- Name: relationships_fk_sink_id; Type: FK CONSTRAINT; Schema: public; Owner: fgdbdev
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT relationships_fk_sink_id FOREIGN KEY (sink_id) REFERENCES contacts(id) ON DELETE SET NULL;


--
-- Name: relationships_fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: fgdbdev
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT relationships_fk_source_id FOREIGN KEY (source_id) REFERENCES contacts(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

