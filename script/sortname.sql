-- Name: get_sort_name(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: rfs
--

CREATE FUNCTION get_sort_name(character varying, character varying, character varying, character varying, character varying) RETURNS character varying
    AS '
DECLARE
    CONTACT_TYPE ALIAS FOR $1 ;
    FIRST_NAME ALIAS FOR $2 ;
    MIDDLE_NAME ALIAS FOR $3 ;
    LAST_NAME ALIAS FOR $4 ;
    ORG_NAME ALIAS FOR $5 ;

BEGIN
    IF CONTACT_TYPE = ''P'' THEN
       RETURN
         SUBSTR( TRIM( UPPER( 
           COALESCE(TRIM(LAST_NAME), '''') || 
           COALESCE('' '' || TRIM(FIRST_NAME), '''') || 
           COALESCE('' '' || TRIM(MIDDLE_NAME), '''')
         )), 0, 25 );
    ELSE
       IF TRIM(ORG_NAME) ILIKE ''THE %'' THEN 
           -- maybe take into account A and AN as first words
           -- like this as well
           RETURN UPPER(SUBSTR(TRIM(ORG_NAME), 5, 25));
       ELSE
           RETURN SUBSTR( UPPER(TRIM(ORG_NAME)), 0, 25 );
       END IF;
    END IF;
    RETURN '''';
END;
'
    LANGUAGE plpgsql;


--
-- TOC entry 306 (OID 2319022)
-- Name: get_sort_name(character varying, character varying, character varying, character varying, character varying); Type: ACL; Schema: public; Owner: rfs
--

REVOKE ALL ON FUNCTION get_sort_name(character varying, character varying, character varying, character varying, character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION get_sort_name(character varying, character varying, character varying, character varying, character varying) FROM rfs;
GRANT ALL ON FUNCTION get_sort_name(character varying, character varying, character varying, character varying, character varying) TO PUBLIC;

