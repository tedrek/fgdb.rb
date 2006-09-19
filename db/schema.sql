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
-- TOC entry 7 (OID 6189649)
-- Name: contact_method_types; Type: TABLE; Schema: public; Owner: rfs
--

CREATE TABLE contact_method_types (
    id serial NOT NULL,
    description character varying(100),
    parent_id integer,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint NOT NULL default 1,
    updated_by bigint NOT NULL default 1
);


--
-- TOC entry 9 (OID 6189657)
-- Name: contact_methods; Type: TABLE; Schema: public; Owner: rfs
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
    created_by bigint NOT NULL default 1,
    updated_by bigint NOT NULL default 1
);


--
-- TOC entry 11 (OID 6189665)
-- Name: contact_types; Type: TABLE; Schema: public; Owner: rfs
--

CREATE TABLE contact_types (
    id serial NOT NULL,
    description character varying(100),
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint NOT NULL default 1,
    updated_by bigint NOT NULL default 1
);


--
-- TOC entry 13 (OID 6189671)
-- Name: contact_types_contacts; Type: TABLE; Schema: public; Owner: rfs
--

CREATE TABLE contact_types_contacts (
    contact_id integer DEFAULT 0 NOT NULL,
    contact_type_id integer DEFAULT 0 NOT NULL
);


--
-- TOC entry 14 (OID 6189677)
-- Name: contacts; Type: TABLE; Schema: public; Owner: rfs
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
    created_by bigint NOT NULL default 1,
    updated_by bigint NOT NULL default 1,
    user_id bigint
);

--
-- TOC entry 47 (OID 6189822)
-- Name: relationship_types; Type: TABLE; Schema: public; Owner: rfs
--

CREATE TABLE relationship_types (
    id serial NOT NULL,
    description character varying(100),
    direction_matters boolean,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint NOT NULL default 1,
    updated_by bigint NOT NULL default 1
);


--
-- TOC entry 49 (OID 6189830)
-- Name: relationships; Type: TABLE; Schema: public; Owner: rfs
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
    created_by bigint NOT NULL default 1,
    updated_by bigint NOT NULL default 1
);

--
-- TOC entry 69 (OID 6189901)
-- Name: contact_types_contacts_contact_id_key; Type: CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY contact_types_contacts
    ADD CONSTRAINT contact_types_contacts_contact_id_key UNIQUE (contact_id, contact_type_id);

--
-- TOC entry 66 (OID 6189907)
-- Name: pk_contact_method_types; Type: CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY contact_method_types
    ADD CONSTRAINT pk_contact_method_types PRIMARY KEY (id);


--
-- TOC entry 67 (OID 6189909)
-- Name: pk_contact_methods; Type: CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY contact_methods
    ADD CONSTRAINT pk_contact_methods PRIMARY KEY (id);


--
-- TOC entry 68 (OID 6189911)
-- Name: pk_contact_types; Type: CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY contact_types
    ADD CONSTRAINT pk_contact_types PRIMARY KEY (id);


--
-- TOC entry 70 (OID 6189913)
-- Name: pk_contacts; Type: CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY contacts
    ADD CONSTRAINT pk_contacts PRIMARY KEY (id);


--
-- TOC entry 86 (OID 6189943)
-- Name: pk_relationship_types; Type: CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY relationship_types
    ADD CONSTRAINT pk_relationship_types PRIMARY KEY (id);


--
-- TOC entry 87 (OID 6189945)
-- Name: pk_relationships; Type: CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT pk_relationships PRIMARY KEY (id);


--
-- TOC entry 119 (OID 6189981)
-- Name: contact_methods_fk_contact_id; Type: FK CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY contact_methods
    ADD CONSTRAINT contact_methods_fk_contact_id FOREIGN KEY (contact_id) REFERENCES contacts(id) ON DELETE SET NULL;


--
-- TOC entry 120 (OID 6189985)
-- Name: contact_methods_fk_contact_method_type; Type: FK CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY contact_methods
    ADD CONSTRAINT contact_methods_fk_contact_method_type FOREIGN KEY (contact_method_type_id) REFERENCES contact_method_types(id) ON DELETE SET NULL;


--
-- TOC entry 178 (OID 6190061)
-- Name: relationships_fk_relationship_type; Type: FK CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT relationships_fk_relationship_type FOREIGN KEY (relationship_type_id) REFERENCES relationship_types(id) ON DELETE SET NULL;


--
-- TOC entry 179 (OID 6190065)
-- Name: relationships_fk_sink_id; Type: FK CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT relationships_fk_sink_id FOREIGN KEY (sink_id) REFERENCES contacts(id) ON DELETE SET NULL;


--
-- TOC entry 180 (OID 6190069)
-- Name: relationships_fk_source_id; Type: FK CONSTRAINT; Schema: public; Owner: rfs
--

ALTER TABLE ONLY relationships
    ADD CONSTRAINT relationships_fk_source_id FOREIGN KEY (source_id) REFERENCES contacts(id) ON DELETE SET NULL;



--
-- TOC entry 8 (OID 6189649)
-- Name: TABLE contact_method_types; Type: COMMENT; Schema: public; Owner: rfs
--

COMMENT ON TABLE contact_method_types IS 'types of ways we can contact someone, i.e. phone, email website, online chat name -- not physical address';


--
-- TOC entry 10 (OID 6189657)
-- Name: TABLE contact_methods; Type: COMMENT; Schema: public; Owner: rfs
--

COMMENT ON TABLE contact_methods IS 'actual ways a specific contact can be contacted (i.e. phone, email, etc.) note: not physical address';


--
-- TOC entry 12 (OID 6189665)
-- Name: TABLE contact_types; Type: COMMENT; Schema: public; Owner: rfs
--

COMMENT ON TABLE contact_types IS 'types of contacts we track, for instance media contact, member, organization';


--
-- TOC entry 48 (OID 6189822)
-- Name: TABLE relationship_types; Type: COMMENT; Schema: public; Owner: rfs
--

COMMENT ON TABLE relationship_types IS 'abstract type of relationships that can exist between contacts, i.e. sibling, parent-child, spouse, employer-employee';


--
-- TOC entry 50 (OID 6189830)
-- Name: TABLE relationships; Type: COMMENT; Schema: public; Owner: rfs
--

COMMENT ON TABLE relationships IS 'actual relationship between two contacts';



--
-- PostgreSQL database dump complete
--

