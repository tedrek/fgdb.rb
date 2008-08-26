CREATE FUNCTION get_sort_name(character varying, character varying, character varying, character varying, character varying) RETURNS character varying
    AS '
DECLARE
    IS_ORG ALIAS FOR $1 ;
    FIRST_NAME ALIAS FOR $2 ;
    MIDDLE_NAME ALIAS FOR $3 ;
    LAST_NAME ALIAS FOR $4 ;
    ORG_NAME ALIAS FOR $5 ;

BEGIN
    IF IS_ORG = f THEN
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


CREATE FUNCTION contact_trigger() RETURNS "trigger"
    AS '
BEGIN
    NEW.sortname := get_sort_name(NEW.is_organization, NEW.first_name, NEW.middle_name, NEW.last_name, NEW.organization);
    RETURN NEW;
END;
'
    LANGUAGE plpgsql;


CREATE TRIGGER contact_addr_insert_trigger
    BEFORE INSERT OR UPDATE ON contact
    FOR EACH ROW
    EXECUTE PROCEDURE contact_trigger();

