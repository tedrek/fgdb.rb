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
-- Name: contacts; Type: TABLE; Schema: public; Owner: fgdbdev; Tablespace: 
--

CREATE TABLE contacts (
    id serial NOT NULL
    ,first_name   varchar(30)
);


--
-- PostgreSQL database dump complete
--

