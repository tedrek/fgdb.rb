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

