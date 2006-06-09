--
-- PostgreSQL database dump
--

SET client_encoding = 'SQL_ASCII';
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'Standard public schema';


SET search_path = public, pg_catalog;

--
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler
    AS '$libdir/plpgsql', 'plpgsql_call_handler'
    LANGUAGE c;


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: public; Owner: 
--

CREATE TRUSTED PROCEDURAL LANGUAGE plpgsql HANDLER plpgsql_call_handler;


--
-- Name: contact_addr_trigger(); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION contact_addr_trigger() RETURNS "trigger"
    AS $$
DECLARE
    TEMPVAR varchar(50);

BEGIN
    IF 
    (NEW.address2 IS NULL OR TRIM(NEW.address2) = '' ) AND
    NEW.address IS NOT NULL
    THEN
        TEMPVAR := NEW.address2;
        NEW.address2 := NEW.address;
        NEW.address := TEMPVAR;
    END IF;
    
    IF NEW.certified = 'C' AND (
      upper(trim(OLD.address2)) <> upper(trim(NEW.address2))
      OR upper(trim(OLD.city)) <> upper(trim(NEW.city))
      OR upper(trim(OLD.state)) <> upper(trim(NEW.state))
      OR trim(OLD.zip) <> trim(NEW.zip))
     THEN
        NEW.certified := null;
    END IF;

    NEW.sortname := get_sort_name(NEW.contacttype, NEW.firstname, NEW.middlename, NEW.lastname, NEW.organization);

    NEW.phone := format_phone(NEW.phone);
    NEW.fax := format_phone(NEW.fax);

    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: contact_addr_trigger2(); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION contact_addr_trigger2() RETURNS "trigger"
    AS $$
DECLARE
    TEMPVAR varchar(50);

BEGIN
    IF 
    (NEW.address2 IS NULL OR TRIM(NEW.address2) = '' ) AND
    NEW.address IS NOT NULL
    THEN
        TEMPVAR := NEW.address2;
        NEW.address2 := NEW.address;
        NEW.address := TEMPVAR;
    END IF;
    
    NEW.sortname := get_sort_name(NEW.contacttype, NEW.firstname, NEW.middlename, NEW.lastname, NEW.organization);

    NEW.phone := format_phone(NEW.phone);
    NEW.fax := format_phone(NEW.fax);

    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: created_trigger(); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION created_trigger() RETURNS "trigger"
    AS $$
BEGIN
    NEW.created := 'now';
    NEW.modified := 'now';
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: d_connect(character varying); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION d_connect(character varying) RETURNS integer
    AS $_$ 
DECLARE
    DUPEKEY ALIAS FOR $1 ;
    PARENT_ID INTEGER ;
    CHILDREC RECORD;

BEGIN

SELECT nextval('contact_id_seq') INTO PARENT_ID;

SELECT * FROM donation 
    WHERE dupe_key = DUPEKEY 
    ORDER BY created DESC LIMIT 1
    INTO CHILDREC;

INSERT INTO contact 
    (id, 
    contacttype, 
    firstname, 
    middlename, 
    lastname, 
    organization, 
    address, 
    address2, 
    city, 
    state, 
    zip, 
    phone, 
    email, 
    emailok, 
    mailok, 
    phoneok, 
    modified, 
    created, 
    sortname, 
    bar_chr, 
    dupe_key)
VALUES
    (PARENT_ID, 
    CHILDREC.contacttype, 
    CHILDREC.firstname, 
    CHILDREC.middlename, 
    CHILDREC.lastname, 
    CHILDREC.organization, 
    CHILDREC.address, 
    CHILDREC.address2, 
    CHILDREC.city, 
    CHILDREC.state, 
    CHILDREC.zip, 
    CHILDREC.phone, 
    CHILDREC.email, 
    CHILDREC.emailok, 
    CHILDREC.mailok, 
    CHILDREC.phoneok, 
    CHILDREC.modified, 
    CHILDREC.created, 
    CHILDREC.sortname, 
    CHILDREC.bar_chr, 
    CHILDREC.dupe_key);

UPDATE donation SET contact_id = PARENT_ID WHERE dupe_key = DUPEKEY;

RETURN 0 ;
END ;
$_$
    LANGUAGE plpgsql;


--
-- Name: format_phone(character varying); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION format_phone(character varying) RETURNS character varying
    AS $_$
DECLARE
    INPUT_PHONE ALIAS FOR $1 ;
    JUST_NUMS varchar(20);

BEGIN
    JUST_NUMS := TRANSLATE( 
        INPUT_PHONE, 
        TRANSLATE( INPUT_PHONE, '0123456789', '' ), 
        '' );
    IF LENGTH( JUST_NUMS ) > 10 THEN
        RETURN 
            SUBSTR(
                SUBSTR( JUST_NUMS, 0, 4 ) || '.' || 
                SUBSTR( JUST_NUMS, 4, 3 ) || '.' || 
                SUBSTR( JUST_NUMS, 7, 4 )  || ' x ' || 
                SUBSTR( JUST_NUMS, 11 ),
            0, 20 )
            ;
    END IF;
    
    IF LENGTH( JUST_NUMS ) = 10 THEN
        RETURN 
            SUBSTR(
                SUBSTR( JUST_NUMS, 0, 4 ) || '.' || 
                SUBSTR( JUST_NUMS, 4, 3 ) || '.' || 
                SUBSTR( JUST_NUMS, 7, 4 ),
            0, 20 )
            ;
    END IF;
    
    IF LENGTH( JUST_NUMS ) = 7 THEN
        RETURN 
            SUBSTR(
                '503.' ||
                SUBSTR( JUST_NUMS, 0, 4 ) || '.' || 
                SUBSTR( JUST_NUMS, 4 ),
            0, 20 )
            ;
    END IF;

    RETURN SUBSTR(JUST_NUMS, 0, 20);
END;
$_$
    LANGUAGE plpgsql;


--
-- Name: get_sort_name(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION get_sort_name(character varying, character varying, character varying, character varying, character varying) RETURNS character varying
    AS $_$
DECLARE
    CONTACT_TYPE ALIAS FOR $1 ;
    FIRST_NAME ALIAS FOR $2 ;
    MIDDLE_NAME ALIAS FOR $3 ;
    LAST_NAME ALIAS FOR $4 ;
    ORG_NAME ALIAS FOR $5 ;

BEGIN
    IF CONTACT_TYPE = 'P' THEN
       RETURN
         SUBSTR( TRIM( UPPER( 
           COALESCE(TRIM(LAST_NAME), '') || 
           COALESCE(' ' || TRIM(FIRST_NAME), '') || 
           COALESCE(' ' || TRIM(MIDDLE_NAME), '')
         )), 0, 25 );
    ELSE
       IF TRIM(ORG_NAME) ILIKE 'THE %' THEN 
           -- maybe take into account A and AN as first words
           -- like this as well
           RETURN UPPER(SUBSTR(TRIM(ORG_NAME), 5, 25));
       ELSE
           RETURN SUBSTR( UPPER(TRIM(ORG_NAME)), 0, 25 );
       END IF;
    END IF;
    RETURN '';
END;
$_$
    LANGUAGE plpgsql;


--
-- Name: gizmos_status_changed(); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION gizmos_status_changed() RETURNS "trigger"
    AS $$
  BEGIN
    IF NEW.newstatus <> OLD.newstatus THEN
      INSERT INTO gizmostatuschanges (id, oldStatus, newStatus) VALUES (OLD.id, OLD.newstatus, NEW.newstatus);
      -- this is redundant oldstatus is in the history table, so
      -- it does not really need to be in gizmos as well
      NEW.oldstatus := OLD.newstatus;
    END IF;
    RETURN NEW;
  END;
$$
    LANGUAGE plpgsql;


--
-- Name: gizmos_status_insert(); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION gizmos_status_insert() RETURNS "trigger"
    AS $$
  BEGIN
    INSERT INTO gizmostatuschanges (id, oldStatus, newStatus) VALUES (NEW.id, 'none', NEW.newstatus);
    -- this is redundant oldstatus is in the history table, so
    -- it does not really need to be in gizmos as well
    NEW.oldstatus := 'none';
    RETURN NEW;
  END;
$$
    LANGUAGE plpgsql;


--
-- Name: merge(integer, integer); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION merge(integer, integer) RETURNS integer
    AS $_$ 
DECLARE
    KEEP_ID ALIAS FOR $1 ;
    TOSS_ID ALIAS FOR $2 ;




BEGIN



UPDATE sales        SET contact_id = KEEP_ID WHERE contact_id = TOSS_ID;
UPDATE donation     SET contact_id = KEEP_ID WHERE contact_id = TOSS_ID;
UPDATE income       SET contact_id = KEEP_ID WHERE contact_id = TOSS_ID;
UPDATE pickups      SET vendor_id  = KEEP_ID WHERE vendor_id  = TOSS_ID;

UPDATE workersqualifyforjobs 
                    SET contact_id = KEEP_ID WHERE contact_id = TOSS_ID;
UPDATE daysoff      SET contact_id = KEEP_ID WHERE contact_id = TOSS_ID;
UPDATE workmonths   SET contact_id = KEEP_ID WHERE contact_id = TOSS_ID;
UPDATE weeklyshifts SET contact_id = KEEP_ID WHERE contact_id = TOSS_ID;
UPDATE workers      SET id =        KEEP_ID WHERE id        = TOSS_ID
    AND NOT EXISTS (SELECT * FROM workers WHERE id = KEEP_ID);

UPDATE memberhour   SET member_id  = KEEP_ID WHERE member_id  = TOSS_ID;
UPDATE member       SET id        = KEEP_ID WHERE id        = TOSS_ID
    AND NOT EXISTS (SELECT * FROM member WHERE id = KEEP_ID);

UPDATE contactlist  SET contact_id = KEEP_ID WHERE contact_id = TOSS_ID;
UPDATE borrow       SET contact_id = KEEP_ID WHERE contact_id = TOSS_ID;
UPDATE gizmos        SET inspector_id = 
                                    KEEP_ID WHERE inspector_id = 
                                                             TOSS_ID;
UPDATE gizmos        SET adopter_id = KEEP_ID WHERE adopter_id = TOSS_ID;
UPDATE gizmos        SET builder_id = KEEP_ID WHERE builder_id = TOSS_ID;
UPDATE scratchpad   SET contact_id = KEEP_ID WHERE contact_id = TOSS_ID;






UPDATE contact SET 
    adopter =
        CASE WHEN toss.adopter = 'Y'
        THEN 'Y' ELSE contact.adopter END,
    build =
        CASE WHEN toss.build = 'Y'
        THEN 'Y' ELSE contact.build END,
    buyer = 
        CASE WHEN toss.buyer = 'Y' 
        THEN 'Y' ELSE contact.buyer END,
    comp4kids =
        CASE WHEN toss.comp4kids = 'Y'
        THEN 'Y' ELSE contact.comp4kids END,
    donor = 
        CASE WHEN toss.donor = 'Y' 
        THEN 'Y' ELSE contact.donor END,
    emailok = 
        CASE WHEN toss.emailok = 'Y' 
        THEN 'Y' ELSE contact.emailok END,
    faxok = 
        CASE WHEN toss.faxok = 'Y' 
        THEN 'Y' ELSE contact.faxok END,
    grantor =
        CASE WHEN toss.grantor = 'Y'
        THEN 'Y' ELSE contact.grantor END,
    mailok = 
        CASE WHEN toss.mailok = 'Y' 
        THEN 'Y' ELSE contact.member END,
    member = 
        CASE WHEN toss.member = 'Y' 
        THEN 'Y' ELSE contact.member END,
    phoneok = 
        CASE WHEN toss.phoneok = 'Y' 
        THEN 'Y' ELSE contact.phoneok END,
    preferemail =
        CASE WHEN toss.preferemail = 'Y'
        THEN 'Y' ELSE contact.preferemail END,
    recycler =
        CASE WHEN toss.recycler = 'Y'
        THEN 'Y' ELSE contact.recycler END,
    volunteer = 
        CASE WHEN toss.volunteer = 'Y' 
        THEN 'Y' ELSE contact.volunteer END,
    waiting = 
        CASE WHEN toss.waiting = 'Y' 
        THEN 'Y' ELSE contact.waiting END
        ,
    contacttype = COALESCE( contact.contacttype, toss.contacttype ),
    firstname = COALESCE( contact.firstname, toss.firstname ),
    middlename = COALESCE( contact.middlename, toss.middlename ),
    lastname = COALESCE( contact.lastname, toss.lastname ),
    organization = COALESCE( contact.organization, toss.organization ),
    address = COALESCE( contact.address, toss.address ),
    address2 = COALESCE( contact.address2, toss.address2 ),
    city = COALESCE( contact.city, toss.city ),
    state = COALESCE( contact.state, toss.state ),
    zip = COALESCE( contact.zip, toss.zip ),
    phone = COALESCE( contact.phone, toss.phone ),
    fax = COALESCE( contact.fax, toss.fax ),
    email = COALESCE( contact.email, toss.email ),
    notes = COALESCE( contact.notes, toss.notes ),
    modified = COALESCE( contact.modified, toss.modified ),
    created = COALESCE( contact.created, toss.created ),
    dupe_key = COALESCE( contact.dupe_key, toss.dupe_key ),
    bar_chr = COALESCE( contact.bar_chr, toss.bar_chr ),
    err_num = COALESCE( contact.err_num, toss.err_num ),
    err_mess = COALESCE( contact.err_mess, toss.err_mess )
FROM contact AS toss
WHERE contact.id = KEEP_ID
AND toss.id = TOSS_ID ;


DELETE FROM contact WHERE id = TOSS_ID;
DELETE FROM dupe_sets WHERE keep_id = KEEP_ID AND toss_id = TOSS_ID;
RETURN 0 ;
END ;
$_$
    LANGUAGE plpgsql;


--
-- Name: modified_trigger(); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION modified_trigger() RETURNS "trigger"
    AS $$
BEGIN
    NEW.modified := 'now';
    RETURN NEW;
END;
$$
    LANGUAGE plpgsql;


--
-- Name: s_connect(character varying); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION s_connect(character varying) RETURNS integer
    AS $_$ 
DECLARE
    DUPEKEY ALIAS FOR $1 ;
    PARENT_ID INTEGER ;
    CHILDREC RECORD;

BEGIN

SELECT nextval('contact_id_seq') INTO PARENT_ID;

SELECT * FROM sales 
    WHERE dupe_key = DUPEKEY 
    ORDER BY created DESC LIMIT 1
    INTO CHILDREC;

INSERT INTO contact 
    (id, 
    contacttype, 
    firstname, 
    middlename, 
    lastname, 
    organization, 
    address, 
    address2, 
    city, 
    state, 
    zip, 
    phone, 
    email, 
    emailok, 
    mailok, 
    phoneok, 
    modified, 
    created, 
    sortname, 
    bar_chr, 
    dupe_key)
VALUES
    (PARENT_ID, 
    CHILDREC.contacttype, 
    CHILDREC.firstname, 
    CHILDREC.middlename, 
    CHILDREC.lastname, 
    CHILDREC.organization, 
    CHILDREC.address, 
    CHILDREC.address2, 
    CHILDREC.city, 
    CHILDREC.state, 
    CHILDREC.zip, 
    CHILDREC.phone, 
    CHILDREC.email, 
    CHILDREC.emailok, 
    CHILDREC.mailok, 
    CHILDREC.phoneok, 
    CHILDREC.modified, 
    CHILDREC.created, 
    CHILDREC.sortname, 
    CHILDREC.bar_chr, 
    CHILDREC.dupe_key);

UPDATE sales SET contact_id = PARENT_ID WHERE dupe_key = DUPEKEY;

RETURN 0 ;
END ;
$_$
    LANGUAGE plpgsql;


--
-- Name: swap(integer, integer); Type: FUNCTION; Schema: public; Owner: stillflame
--

CREATE FUNCTION swap(integer, integer) RETURNS integer
    AS $_$ 
DECLARE
    KEEP_ID ALIAS FOR $1 ;
    TOSS_ID ALIAS FOR $2 ;

BEGIN

UPDATE dupe_sets SET 
    keep_id = TOSS_ID, toss_id = KEEP_ID 
    WHERE keep_id = KEEP_ID AND toss_id = TOSS_ID;

RETURN 0 ;

END ;
$_$
    LANGUAGE plpgsql;


SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: allowedstatuses; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE allowedstatuses (
    id integer DEFAULT nextval('allowedStatuses_id_seq'::text) NOT NULL,
    oldstatus character varying(15),
    newstatus character varying(15)
);


--
-- Name: allowedstatuses_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE allowedstatuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: anondict_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE anondict_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: borrow; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE borrow (
    id integer DEFAULT nextval('Borrow_id_seq'::text) NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    gizmo_id integer DEFAULT 0 NOT NULL,
    borrowdate date NOT NULL,
    returndate date NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: borrow_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE borrow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: cards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE cards (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    slottype character varying(10)
);


--
-- Name: cddrives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE cddrives (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    interface character varying(10) DEFAULT ''::character varying,
    speed character varying(10) DEFAULT ''::character varying,
    writemode character varying(15) DEFAULT ''::character varying,
    scsi character varying(1) DEFAULT 'N'::character varying,
    spinrate integer,
    CONSTRAINT cddrives_scsi CHECK ((((scsi)::text = ('N'::character varying)::text) OR ((scsi)::text = ('Y'::character varying)::text)))
);


--
-- Name: cellphones; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE cellphones (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100)
);


--
-- Name: classtree; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE classtree (
    id integer DEFAULT nextval('classTree_id_seq'::text) NOT NULL,
    classtree character varying(100),
    tablename character varying(50),
    "level" integer,
    instantiable character varying(1) DEFAULT 'Y'::character varying NOT NULL,
    intakecode character varying(10),
    intakeadd integer,
    description character varying(50),
    CONSTRAINT classtree_instantiable CHECK ((((instantiable)::text = ('N'::character varying)::text) OR ((instantiable)::text = ('Y'::character varying)::text)))
);


--
-- Name: classtree_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE classtree_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: cleanup; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE cleanup (
    id integer,
    waiting character(1),
    member character(1),
    volunteer character(1),
    donor character(1),
    buyer character(1),
    source_id integer,
    contacttype character(1),
    firstname character(25),
    middlename character(25),
    lastname character(50),
    organization character(50),
    address character(50),
    address2 character(50),
    city character(30),
    state character(2),
    zip character(10),
    phone character(20),
    fax character(50),
    email character(50),
    emailok character(1),
    mailok character(1),
    phoneok character(1),
    faxok character(1),
    modified date,
    created date,
    sortname character(25),
    preferemail character(1),
    comp4kids character(1),
    recycler character(1),
    grantor character(1),
    build character(1),
    adopter character(1),
    dupe_key character(50),
    source_table character(50),
    add_final character(64),
    add_left character(50),
    bar_chr character(14),
    cr_final character(4),
    certified character(1),
    city_final character(39),
    comp_final character(40),
    err_num character(20),
    err_mess character(47),
    st_final character(2),
    zip_final character(10),
    lot_seq character(4),
    lot_ad character(1),
    contact_id integer,
    donation_id integer,
    sales_id integer
);


--
-- Name: codedinfo; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE codedinfo (
    id integer DEFAULT nextval('codedInfo_id_seq'::text) NOT NULL,
    codetype character varying(100),
    codelength integer DEFAULT 10,
    code character varying(25),
    description text,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: codedinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE codedinfo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: components; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE components (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    insys_id integer DEFAULT 0 NOT NULL
);


--
-- Name: contact; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE contact (
    id integer DEFAULT nextval('Contact_id_seq'::text) NOT NULL,
    waiting character varying(1) DEFAULT 'N'::character varying,
    member character varying(1) DEFAULT 'N'::character varying,
    volunteer character varying(1) DEFAULT 'N'::character varying,
    donor character varying(1) DEFAULT 'N'::character varying,
    buyer character varying(1) DEFAULT 'N'::character varying,
    contacttype character varying(1) DEFAULT 'P'::character varying NOT NULL,
    firstname character varying(25),
    middlename character varying(25),
    lastname character varying(50),
    organization character varying(50),
    address character varying(50),
    address2 character varying(50),
    city character varying(30) DEFAULT 'Portland'::character varying NOT NULL,
    state character varying(2) DEFAULT 'OR'::character varying,
    zip character varying(10),
    phone character varying(20),
    fax character varying(20),
    email character varying(50),
    emailok character varying(1),
    mailok character varying(1),
    phoneok character varying(1),
    faxok character varying(1),
    notes text,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    sortname character varying(25),
    preferemail character varying(1),
    comp4kids character varying(1),
    recycler character varying(1),
    grantor character varying(1),
    build character varying(1),
    adopter character varying(1),
    dupe_key character varying(50),
    bar_chr character varying(50),
    err_num character varying(50),
    err_mess character varying(50),
    certified character varying(1),
    countycode character varying(3),
    countyname character varying(25),
    add_left character varying(50),
    nametitle character varying(15),
    namesuffix character varying(15),
    CONSTRAINT contact_buyer CHECK ((((buyer)::text = ('N'::character varying)::text) OR ((buyer)::text = ('Y'::character varying)::text))),
    CONSTRAINT contact_contacttype CHECK (((((contacttype)::text = ('O'::character varying)::text) OR ((contacttype)::text = ('N'::character varying)::text)) OR ((contacttype)::text = ('P'::character varying)::text))),
    CONSTRAINT contact_donor CHECK ((((donor)::text = ('N'::character varying)::text) OR ((donor)::text = ('Y'::character varying)::text))),
    CONSTRAINT contact_member CHECK ((((member)::text = ('N'::character varying)::text) OR ((member)::text = ('Y'::character varying)::text))),
    CONSTRAINT contact_volunteer CHECK ((((volunteer)::text = ('N'::character varying)::text) OR ((volunteer)::text = ('Y'::character varying)::text))),
    CONSTRAINT contact_waiting CHECK ((((waiting)::text = ('N'::character varying)::text) OR ((waiting)::text = ('Y'::character varying)::text)))
);


--
-- Name: contact_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: contactlist; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE contactlist (
    id integer DEFAULT nextval('ContactList_id_seq'::text) NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    listname character varying(20),
    putonlist date,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    removedfromlist date,
    active character varying(1) DEFAULT 'Y'::character varying,
    remarks text,
    CONSTRAINT contactlist_active CHECK ((((active)::text = ('Y'::character varying)::text) OR ((active)::text = ('N'::character varying)::text)))
);


--
-- Name: contactlist_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE contactlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: controllercards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE controllercards (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    numserial integer DEFAULT 0 NOT NULL,
    numparallel integer DEFAULT 0 NOT NULL,
    numide integer DEFAULT 0 NOT NULL,
    floppy character varying(1) DEFAULT 'Y'::character varying NOT NULL,
    CONSTRAINT controllercards_floppy CHECK ((((floppy)::text = ('N'::character varying)::text) OR ((floppy)::text = ('Y'::character varying)::text)))
);


--
-- Name: daysoff; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE daysoff (
    id integer DEFAULT nextval('DaysOff_id_seq'::text) NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    dayoff date,
    vacation character varying(1) DEFAULT 'N'::character varying,
    offsitework character varying(1) DEFAULT 'N'::character varying,
    notes text,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT daysoff_offsitework CHECK ((((offsitework)::text = ('N'::character varying)::text) OR ((offsitework)::text = ('Y'::character varying)::text))),
    CONSTRAINT daysoff_vacation CHECK ((((vacation)::text = ('N'::character varying)::text) OR ((vacation)::text = ('Y'::character varying)::text)))
);


--
-- Name: daysoff_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE daysoff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: deduper; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE deduper (
    id integer,
    waiting character varying,
    member character varying,
    volunteer character varying,
    donor character varying,
    buyer character varying,
    source_id integer,
    contacttype character varying(1),
    firstname character varying(25),
    middlename character varying(25),
    lastname character varying(50),
    organization character varying(50),
    address character varying(50),
    address2 character varying(50),
    city character varying(30),
    state character varying(2),
    zip character varying(10),
    phone character varying(20),
    fax character varying,
    email character varying(50),
    emailok character varying(1),
    mailok character varying(1),
    phoneok character varying(1),
    faxok character varying,
    modified timestamp with time zone,
    created timestamp with time zone,
    sortname character varying(25),
    preferemail character varying,
    comp4kids character varying,
    recycler character varying,
    grantor character varying,
    build character varying,
    adopter character varying,
    dupe_key text,
    source_table text
);


--
-- Name: defaultvalues; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE defaultvalues (
    id integer DEFAULT nextval('defaultValues_id_seq'::text) NOT NULL,
    classtree character varying(100),
    fieldname character varying(50),
    defaultvalue character varying(50)
);


--
-- Name: defaultvalues_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE defaultvalues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: donation; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE donation (
    id integer DEFAULT nextval('Donation_id_seq'::text) NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    zip character varying(10),
    cashdonation numeric(8,2) DEFAULT 0.00 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    mbrpayment character varying(1) DEFAULT 'N'::character varying NOT NULL,
    comp4kids character varying(1) DEFAULT 'N'::character varying NOT NULL,
    monitorfee numeric(8,2) DEFAULT 0.00,
    CONSTRAINT donation_comp4kids CHECK ((((comp4kids)::text = ('N'::character varying)::text) OR ((comp4kids)::text = ('Y'::character varying)::text))),
    CONSTRAINT donation_mbrpayment CHECK ((((mbrpayment)::text = ('N'::character varying)::text) OR ((mbrpayment)::text = ('Y'::character varying)::text)))
);


--
-- Name: donation_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE donation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: donationline; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE donationline (
    id integer DEFAULT nextval('DonationLine_id_seq'::text) NOT NULL,
    donation_id integer DEFAULT 0 NOT NULL,
    description text,
    quantity integer DEFAULT 1 NOT NULL,
    crt boolean
);


--
-- Name: donationline_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE donationline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: drives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE drives (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100)
);


--
-- Name: dupe_keys; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE dupe_keys (
    dupe_key character varying(50),
    id integer,
    count bigint
);


--
-- Name: dupe_sets; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE dupe_sets (
    keep_id integer,
    toss_id integer
);


--
-- Name: fieldmap; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE fieldmap (
    id integer DEFAULT nextval('fieldMap_id_seq'::text) NOT NULL,
    tablename character varying(50),
    fieldname character varying(50),
    displayorder integer DEFAULT 0 NOT NULL,
    inputwidget character varying(50),
    inputwidgetparameters character varying(100),
    outputwidget character varying(50),
    outputwidgetparameters character varying(100),
    editable character varying(1) DEFAULT 'Y'::character varying,
    helplink character varying(1) DEFAULT 'N'::character varying,
    description character varying(100),
    CONSTRAINT fieldmap_editable CHECK ((((editable)::text = ('N'::character varying)::text) OR ((editable)::text = ('Y'::character varying)::text))),
    CONSTRAINT fieldmap_helplink CHECK ((((helplink)::text = ('N'::character varying)::text) OR ((helplink)::text = ('Y'::character varying)::text)))
);


--
-- Name: fieldmap_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE fieldmap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: floppydrives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE floppydrives (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    disksize character varying(10),
    capacity character varying(10),
    cylinders integer DEFAULT 0,
    heads integer DEFAULT 0,
    sectors integer DEFAULT 0
);


--
-- Name: gizmoclones; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE gizmoclones (
    id integer DEFAULT nextval('GizmoClones_id_seq'::text) NOT NULL,
    parent_id integer DEFAULT 0 NOT NULL,
    child_id integer DEFAULT 0 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: gizmoclones_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE gizmoclones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gizmos; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE gizmos (
    id integer DEFAULT nextval('Gizmos_id_seq'::text) NOT NULL,
    classtree character varying(100),
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    oldstatus character varying(15),
    newstatus character varying(15) DEFAULT 'Received'::character varying NOT NULL,
    obsolete character varying(1) DEFAULT 'N'::character varying NOT NULL,
    working character varying(1) DEFAULT 'M'::character varying NOT NULL,
    architecture character varying(10) DEFAULT 'PC'::character varying NOT NULL,
    manufacturer character varying(50),
    modelnumber character varying(50),
    "location" character varying(10) DEFAULT 'Free Geek'::character varying NOT NULL,
    notes text,
    testdata character varying(1) DEFAULT 'N'::character varying,
    value numeric(5,1) DEFAULT 0.0 NOT NULL,
    inventoried timestamp with time zone DEFAULT now(),
    builder_id integer DEFAULT 0 NOT NULL,
    inspector_id integer DEFAULT 0 NOT NULL,
    linuxfund character varying(1) DEFAULT 'N'::character varying NOT NULL,
    cashvalue numeric(8,2) DEFAULT 0.00 NOT NULL,
    needsexpert character varying(1) DEFAULT 'N'::character varying,
    gizmotype character varying(10) DEFAULT 'Other'::character varying,
    adopter_id integer DEFAULT 0 NOT NULL,
    CONSTRAINT gizmos_linuxfund CHECK (((((linuxfund)::text = ('N'::character varying)::text) OR ((linuxfund)::text = ('Y'::character varying)::text)) OR ((linuxfund)::text = ('M'::character varying)::text))),
    CONSTRAINT gizmos_needsexpert CHECK ((((needsexpert)::text = ('N'::character varying)::text) OR ((needsexpert)::text = ('Y'::character varying)::text))),
    CONSTRAINT gizmos_obsolete CHECK (((((obsolete)::text = ('N'::character varying)::text) OR ((obsolete)::text = ('Y'::character varying)::text)) OR ((obsolete)::text = ('M'::character varying)::text))),
    CONSTRAINT gizmos_testdata CHECK ((((testdata)::text = ('N'::character varying)::text) OR ((testdata)::text = ('Y'::character varying)::text))),
    CONSTRAINT gizmos_working CHECK (((((working)::text = ('N'::character varying)::text) OR ((working)::text = ('Y'::character varying)::text)) OR ((working)::text = ('M'::character varying)::text)))
);


--
-- Name: gizmos_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE gizmos_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gizmostatuschanges; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE gizmostatuschanges (
    id integer DEFAULT 0 NOT NULL,
    oldstatus character varying(15),
    newstatus character varying(15),
    created timestamp with time zone DEFAULT now(),
    change_id integer DEFAULT nextval('GizmoStatusChanges_change_id_se'::text) NOT NULL
);


--
-- Name: gizmostatuschanges_change_id_se; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE gizmostatuschanges_change_id_se
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: helpscreen_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE helpscreen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: holidays; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE holidays (
    id integer DEFAULT nextval('Holidays_id_seq'::text) NOT NULL,
    name character varying(50),
    holiday date,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: holidays_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE holidays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ideharddrives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE ideharddrives (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    cylinders integer DEFAULT 0 NOT NULL,
    heads integer DEFAULT 0 NOT NULL,
    sectors integer DEFAULT 0 NOT NULL,
    ata character varying(10),
    sizemb integer DEFAULT 0 NOT NULL
);


--
-- Name: income; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE income (
    id integer DEFAULT nextval('Income_id_seq'::text) NOT NULL,
    incometype character varying(10),
    description character varying(50),
    received date,
    amount numeric(8,2) DEFAULT 0.00 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    contact_id integer DEFAULT 0 NOT NULL
);


--
-- Name: income_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE income_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: issuenotes; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE issuenotes (
    id integer DEFAULT 0 NOT NULL,
    issue_id integer DEFAULT 0 NOT NULL,
    techname character varying(25),
    notes text,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: issues; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE issues (
    id integer DEFAULT 0 NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    gizmo_id integer DEFAULT 0 NOT NULL,
    issuename character varying(100),
    issuestatus character varying(10),
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE jobs (
    id integer DEFAULT nextval('Jobs_id_seq'::text) NOT NULL,
    job character varying(50),
    schedulename character varying(15) DEFAULT 'Main'::character varying NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    meeting character varying(1) DEFAULT 'N'::character varying
);


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: keyboards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE keyboards (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    kbtype character varying(10),
    numkeys character varying(10)
);


--
-- Name: laptops; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE laptops (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    ram integer,
    harddrivessizegb numeric(8,2) DEFAULT 0.00,
    chipclass character varying(15),
    chipspeed integer DEFAULT 0 NOT NULL
);


--
-- Name: links; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE links (
    id integer DEFAULT nextval('Links_id_seq'::text) NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    url character varying(250),
    helptext character varying(100),
    linktext character varying(250),
    broken character varying(1) DEFAULT 'N'::character varying,
    howto character varying(1) DEFAULT 'N'::character varying,
    "external" character varying(1) DEFAULT 'N'::character varying,
    CONSTRAINT links_broken CHECK ((((broken)::text = ('N'::character varying)::text) OR ((broken)::text = ('Y'::character varying)::text))),
    CONSTRAINT links_external CHECK (((("external")::text = ('N'::character varying)::text) OR (("external")::text = ('Y'::character varying)::text))),
    CONSTRAINT links_howto CHECK ((((howto)::text = ('N'::character varying)::text) OR ((howto)::text = ('Y'::character varying)::text)))
);


--
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: mailingpieces; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE mailingpieces (
    id integer DEFAULT nextval('"mailingpieces_id_seq"'::text) NOT NULL,
    mailing_id integer DEFAULT 0 NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    container integer,
    containertype character varying(10),
    bundle integer
);


--
-- Name: mailingpieces_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE mailingpieces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: mailings; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE mailings (
    id integer DEFAULT nextval('"mailings_id_seq"'::text) NOT NULL,
    mailingname character varying(50),
    maildate date NOT NULL,
    "class" character varying(15),
    piecesize character varying(10),
    piecethickness double precision,
    pieceweight double precision,
    pieceheight double precision,
    piecewidth double precision,
    whereclause character varying(1000),
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: mailings_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE mailings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE materials (
    id integer DEFAULT nextval('Materials_id_seq'::text) NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    materialname character varying(25),
    ratebase character varying(1) DEFAULT 'W'::character varying,
    defaultunit character varying(20),
    CONSTRAINT materials_ratebase CHECK ((((ratebase)::text = ('W'::character varying)::text) OR ((ratebase)::text = ('P'::character varying)::text)))
);


--
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: member; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE member (
    id integer DEFAULT 0 NOT NULL,
    membertype character varying(1) DEFAULT 'M'::character varying,
    howfoundout text,
    interestcomputer character varying(1) DEFAULT 'N'::character varying NOT NULL,
    interestclasses character varying(1) DEFAULT 'N'::character varying NOT NULL,
    interestaccess character varying(1) DEFAULT 'N'::character varying NOT NULL,
    skillhardware character varying(1) DEFAULT 'N'::character varying NOT NULL,
    texthardware text,
    skillnetwork character varying(1) DEFAULT 'N'::character varying NOT NULL,
    textnetwork text,
    skilllinux character varying(1) DEFAULT 'N'::character varying NOT NULL,
    textlinux text,
    skillsoftware character varying(1) DEFAULT 'N'::character varying NOT NULL,
    textsoftware text,
    skillteaching character varying(1) DEFAULT 'N'::character varying NOT NULL,
    textteaching text,
    skillothercomputer character varying(1) DEFAULT 'N'::character varying NOT NULL,
    textothercomputer text,
    skilladmin character varying(1) DEFAULT 'N'::character varying NOT NULL,
    textadmin text,
    skillconstruction character varying(1) DEFAULT 'N'::character varying NOT NULL,
    textconstruction text,
    skillvolunteercoord character varying(1) DEFAULT 'N'::character varying NOT NULL,
    textvolunteercoord text,
    skillother character varying(1) DEFAULT 'N'::character varying NOT NULL,
    textother text,
    notes text,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT member_interestaccess CHECK ((((interestaccess)::text = ('N'::character varying)::text) OR ((interestaccess)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_interestclasses CHECK ((((interestclasses)::text = ('N'::character varying)::text) OR ((interestclasses)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_interestcomputer CHECK ((((interestcomputer)::text = ('N'::character varying)::text) OR ((interestcomputer)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_membertype CHECK (((((membertype)::text = ('V'::character varying)::text) OR ((membertype)::text = ('M'::character varying)::text)) OR ((membertype)::text = ('N'::character varying)::text))),
    CONSTRAINT member_skilladmin CHECK ((((skilladmin)::text = ('N'::character varying)::text) OR ((skilladmin)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_skillconstruction CHECK ((((skillconstruction)::text = ('N'::character varying)::text) OR ((skillconstruction)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_skillhardware CHECK ((((skillhardware)::text = ('N'::character varying)::text) OR ((skillhardware)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_skilllinux CHECK ((((skilllinux)::text = ('N'::character varying)::text) OR ((skilllinux)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_skillnetwork CHECK ((((skillnetwork)::text = ('N'::character varying)::text) OR ((skillnetwork)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_skillother CHECK ((((skillother)::text = ('N'::character varying)::text) OR ((skillother)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_skillothercomputer CHECK ((((skillothercomputer)::text = ('N'::character varying)::text) OR ((skillothercomputer)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_skillsoftware CHECK ((((skillsoftware)::text = ('N'::character varying)::text) OR ((skillsoftware)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_skillteaching CHECK ((((skillteaching)::text = ('N'::character varying)::text) OR ((skillteaching)::text = ('Y'::character varying)::text))),
    CONSTRAINT member_skillvolunteercoord CHECK ((((skillvolunteercoord)::text = ('N'::character varying)::text) OR ((skillvolunteercoord)::text = ('Y'::character varying)::text)))
);


--
-- Name: memberhour; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE memberhour (
    id integer DEFAULT nextval('MemberHour_id_seq'::text) NOT NULL,
    member_id integer DEFAULT 0 NOT NULL,
    workdate date,
    intime time without time zone,
    outtime time without time zone,
    jobtype character varying(15),
    jobdescription text,
    hours numeric(5,2) DEFAULT 0.00 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    paytype character varying(1) DEFAULT 'V'::character varying NOT NULL,
    CONSTRAINT memberhour_paytype CHECK ((((((paytype)::text = ('V'::character varying)::text) OR ((paytype)::text = ('W'::character varying)::text)) OR ((paytype)::text = ('H'::character varying)::text)) OR ((paytype)::text = ('O'::character varying)::text)))
);


--
-- Name: memberhour_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE memberhour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: misccards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE misccards (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    miscnotes text
);


--
-- Name: misccomponents; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE misccomponents (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    miscnotes text
);


--
-- Name: miscdrives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE miscdrives (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    miscnotes text
);


--
-- Name: miscgizmos; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE miscgizmos (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100)
);


--
-- Name: modems; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE modems (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    speed character varying(15)
);


--
-- Name: modemcards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE modemcards (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    speed character varying(15)
);


--
-- Name: monitors; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE monitors (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    size character varying(10),
    resolution character varying(10)
);


--
-- Name: networkcards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE networkcards (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    speed character varying(10),
    rj45 character varying(1) DEFAULT 'N'::character varying NOT NULL,
    aux character varying(1) DEFAULT 'N'::character varying NOT NULL,
    bnc character varying(1) DEFAULT 'N'::character varying NOT NULL,
    thicknet character varying(1) DEFAULT 'N'::character varying NOT NULL,
    module character varying(50),
    io character varying(10),
    irq character varying(2),
    CONSTRAINT networkcards_aux CHECK ((((aux)::text = ('N'::character varying)::text) OR ((aux)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkcards_bnc CHECK ((((bnc)::text = ('N'::character varying)::text) OR ((bnc)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkcards_rj45 CHECK ((((rj45)::text = ('N'::character varying)::text) OR ((rj45)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkcards_thicknet CHECK ((((thicknet)::text = ('N'::character varying)::text) OR ((thicknet)::text = ('Y'::character varying)::text)))
);


--
-- Name: networkingdevices; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE networkingdevices (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    speed character varying(10),
    rj45 character varying(1) DEFAULT 'N'::character varying NOT NULL,
    aux character varying(1) DEFAULT 'N'::character varying NOT NULL,
    bnc character varying(1) DEFAULT 'N'::character varying NOT NULL,
    thicknet character varying(1) DEFAULT 'N'::character varying NOT NULL,
    CONSTRAINT networkingdevices_aux CHECK ((((aux)::text = ('N'::character varying)::text) OR ((aux)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkingdevices_bnc CHECK ((((bnc)::text = ('N'::character varying)::text) OR ((bnc)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkingdevices_rj45 CHECK ((((rj45)::text = ('N'::character varying)::text) OR ((rj45)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkingdevices_thicknet CHECK ((((thicknet)::text = ('N'::character varying)::text) OR ((thicknet)::text = ('Y'::character varying)::text)))
);


--
-- Name: options_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: organization; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE organization (
    id integer DEFAULT 0 NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    missionstatement text,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: pagelinks; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE pagelinks (
    id integer DEFAULT nextval('PageLinks_id_seq'::text) NOT NULL,
    page_id integer DEFAULT 0 NOT NULL,
    link_id integer DEFAULT 0 NOT NULL,
    break character varying(1) DEFAULT 'N'::character varying,
    displayorder integer DEFAULT 0 NOT NULL,
    helptext character varying(100),
    linktext character varying(250),
    CONSTRAINT pagelinks_break CHECK ((((break)::text = ('N'::character varying)::text) OR ((break)::text = ('Y'::character varying)::text)))
);


--
-- Name: pagelinks_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE pagelinks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE pages (
    id integer DEFAULT nextval('Pages_id_seq'::text) NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    shortname character varying(25),
    longname character varying(100),
    visible character varying(1) DEFAULT 'Y'::character varying,
    link_id integer DEFAULT 0 NOT NULL,
    displayorder integer DEFAULT 0 NOT NULL,
    helptext character varying(100),
    CONSTRAINT pages_visible CHECK ((((visible)::text = ('N'::character varying)::text) OR ((visible)::text = ('Y'::character varying)::text)))
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pickuplines; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE pickuplines (
    id integer DEFAULT nextval('PickupLines_id_seq'::text) NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    pickup_id integer DEFAULT 0 NOT NULL,
    material_id integer DEFAULT 0 NOT NULL,
    pickupunittype character varying(20),
    processedunittype character varying(20),
    pickupunitcount integer DEFAULT 1 NOT NULL,
    processedunitcount integer DEFAULT 1 NOT NULL,
    pickupweight numeric(10,2) DEFAULT 0.00 NOT NULL,
    processedweight numeric(10,2) DEFAULT 0.00 NOT NULL,
    amountcharged numeric(10,2) DEFAULT 0.00 NOT NULL,
    rate numeric(10,4) DEFAULT 0.0000 NOT NULL
);


--
-- Name: pickuplines_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE pickuplines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pickups; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE pickups (
    id integer DEFAULT nextval('Pickups_id_seq'::text) NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    vendor_id integer DEFAULT 0 NOT NULL,
    pickupdate date NOT NULL,
    receiptnumber character varying(20),
    settlementnumber character varying(20)
);


--
-- Name: pickups_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE pickups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pointingdevices; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE pointingdevices (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    connector character varying(10),
    pointertype character varying(10)
);


--
-- Name: powersupplies; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE powersupplies (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    watts integer DEFAULT 0 NOT NULL,
    connection character varying(10)
);


--
-- Name: printers; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE printers (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    speedppm integer DEFAULT 0 NOT NULL,
    printertype character varying(10),
    interface character varying(10) DEFAULT 'Parallel'::character varying
);


--
-- Name: processors; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE processors (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    chipclass character varying(15),
    interface character varying(10),
    speed integer DEFAULT 0 NOT NULL
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: sales; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE sales (
    id integer DEFAULT nextval('Sales_id_seq'::text) NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    zip character varying(10),
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    subtotal numeric(8,2) DEFAULT 0.00 NOT NULL,
    discount numeric(8,2) DEFAULT 0.00 NOT NULL,
    total numeric(8,2) DEFAULT 0.00 NOT NULL,
    bulk boolean
);


--
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: salesline; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE salesline (
    id integer DEFAULT nextval('SalesLine_id_seq'::text) NOT NULL,
    sales_id integer DEFAULT 0 NOT NULL,
    gizmo_id integer DEFAULT 0 NOT NULL,
    description text,
    cashvalue numeric(8,2) DEFAULT 0.00 NOT NULL,
    subtotal numeric(8,2) DEFAULT 0.00 NOT NULL,
    discount numeric(8,2) DEFAULT 0.00 NOT NULL,
    total numeric(8,2) DEFAULT 0.00 NOT NULL
);


--
-- Name: salesline_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE salesline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: scanners; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE scanners (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    interface character varying(10)
);


--
-- Name: scratchpad; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE scratchpad (
    id integer DEFAULT nextval('ScratchPad_id_seq'::text) NOT NULL,
    page_id integer DEFAULT 0 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    contact_id integer DEFAULT 0 NOT NULL,
    name character varying(25),
    note text,
    urgent character varying(1) DEFAULT 'N'::character varying,
    visible character varying(1) DEFAULT 'Y'::character varying,
    CONSTRAINT scratchpad_urgent CHECK ((((urgent)::text = ('N'::character varying)::text) OR ((urgent)::text = ('Y'::character varying)::text))),
    CONSTRAINT scratchpad_visible CHECK ((((visible)::text = ('N'::character varying)::text) OR ((visible)::text = ('Y'::character varying)::text)))
);


--
-- Name: scratchpad_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE scratchpad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: scsicards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE scsicards (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    internalinterface character varying(15),
    externalinterface character varying(15),
    parms text
);


--
-- Name: scsiharddrives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE scsiharddrives (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    sizemb integer DEFAULT 0 NOT NULL,
    scsiversion character varying(10)
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: soundcards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE soundcards (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    soundtype character varying(15)
);


--
-- Name: speakers; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE speakers (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    powered character varying(1) DEFAULT 'N'::character varying NOT NULL,
    subwoofer character varying(1) DEFAULT 'N'::character varying NOT NULL,
    CONSTRAINT speakers_powered CHECK ((((powered)::text = ('N'::character varying)::text) OR ((powered)::text = ('Y'::character varying)::text))),
    CONSTRAINT speakers_subwoofer CHECK ((((subwoofer)::text = ('N'::character varying)::text) OR ((subwoofer)::text = ('Y'::character varying)::text)))
);


--
-- Name: standardshifts_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE standardshifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: stereos; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE stereos (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100)
);


--
-- Name: systems; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE systems (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    systemconfiguration text,
    systemboards text,
    adapterinformation text,
    multiprocessorinformation text,
    displaydetails text,
    displayinformation text,
    scsiinformation text,
    pcmciainformation text,
    modeminformation text,
    multimediainformation text,
    plugnplayinformation text,
    physicaldrivess text,
    ram integer,
    videoram integer,
    sizemb integer,
    scsi character varying(1) DEFAULT 'N'::character varying,
    chipclass character varying(15),
    speed integer DEFAULT 0 NOT NULL,
    CONSTRAINT systems_scsi CHECK ((((scsi)::text = ('N'::character varying)::text) OR ((scsi)::text = ('Y'::character varying)::text)))
);


--
-- Name: systemboards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE systemboards (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    pcislots integer DEFAULT 0 NOT NULL,
    vesaslots integer DEFAULT 0 NOT NULL,
    isaslots integer DEFAULT 0 NOT NULL,
    eisaslots integer DEFAULT 0 NOT NULL,
    agpslot character varying(1) DEFAULT 'N'::character varying,
    ram30pin integer DEFAULT 0 NOT NULL,
    ram72pin integer DEFAULT 0 NOT NULL,
    ram168pin integer DEFAULT 0 NOT NULL,
    dimmspeed character varying(10),
    proc386 integer DEFAULT 0 NOT NULL,
    proc486 integer DEFAULT 0 NOT NULL,
    proc586 integer DEFAULT 0 NOT NULL,
    procmmx integer DEFAULT 0 NOT NULL,
    procpro integer DEFAULT 0 NOT NULL,
    procsocket7 integer DEFAULT 0 NOT NULL,
    procslot1 integer DEFAULT 0 NOT NULL,
    CONSTRAINT systemboards_agpslot CHECK ((((agpslot)::text = ('N'::character varying)::text) OR ((agpslot)::text = ('Y'::character varying)::text)))
);


--
-- Name: systemcases; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE systemcases (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    casetype character varying(10)
);


--
-- Name: tapedrives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE tapedrives (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    interface character varying(15)
);


--
-- Name: unit2material; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE unit2material (
    id integer DEFAULT nextval('Unit2Material_id_seq'::text) NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    material_id integer DEFAULT 0 NOT NULL,
    unittype character varying(20)
);


--
-- Name: unit2material_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE unit2material_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: upses; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE upses (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    rj11 character varying(1) DEFAULT 'N'::character varying NOT NULL,
    rj45 character varying(1) DEFAULT 'N'::character varying NOT NULL,
    usb character varying(1) DEFAULT 'N'::character varying NOT NULL,
    serial character varying(1) DEFAULT 'N'::character varying NOT NULL,
    va character varying(5),
    supported_outlets integer,
    unsupported_outlets integer,
    CONSTRAINT ups_rj11 CHECK ((((rj11)::text = ('N'::character varying)::text) OR ((rj11)::text = ('Y'::character varying)::text))),
    CONSTRAINT ups_rj45 CHECK ((((rj45)::text = ('N'::character varying)::text) OR ((rj45)::text = ('Y'::character varying)::text))),
    CONSTRAINT ups_serial CHECK ((((serial)::text = ('N'::character varying)::text) OR ((serial)::text = ('Y'::character varying)::text))),
    CONSTRAINT ups_usb CHECK ((((usb)::text = ('N'::character varying)::text) OR ((usb)::text = ('Y'::character varying)::text)))
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE users (
    id integer DEFAULT nextval('Users_id_seq'::text) NOT NULL,
    username character varying(50) NOT NULL,
    "password" character varying(50),
    usergroup character varying(50)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: vcrs; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE vcrs (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100)
);


--
-- Name: videocards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE videocards (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    videomemory character varying(10),
    resolutions text
);


--
-- Name: weeklyshifts; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE weeklyshifts (
    id integer DEFAULT nextval('WeeklyShifts_id_seq'::text) NOT NULL,
    schedulename character varying(15) DEFAULT 'Main'::character varying NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    job_id integer DEFAULT 0 NOT NULL,
    weekday integer DEFAULT 0 NOT NULL,
    intime time without time zone,
    outtime time without time zone,
    meeting character varying(1) DEFAULT 'N'::character varying,
    effective date DEFAULT '2004-01-01'::date NOT NULL,
    ineffective date DEFAULT '3004-01-01'::date NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT weeklyshifts_meeting CHECK ((((meeting)::text = ('N'::character varying)::text) OR ((meeting)::text = ('Y'::character varying)::text)))
);


--
-- Name: weeklyshifts_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE weeklyshifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: workers; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE workers (
    id integer DEFAULT 0 NOT NULL,
    sunday numeric(5,2) DEFAULT 0.00 NOT NULL,
    monday numeric(5,2) DEFAULT 0.00 NOT NULL,
    tuesday numeric(5,2) DEFAULT 8.00 NOT NULL,
    wednesday numeric(5,2) DEFAULT 8.00 NOT NULL,
    thursday numeric(5,2) DEFAULT 8.00 NOT NULL,
    friday numeric(5,2) DEFAULT 8.00 NOT NULL,
    saturday numeric(5,2) DEFAULT 8.00 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: workersqualifyforjobs; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE workersqualifyforjobs (
    id integer DEFAULT nextval('WorkersQualifyForJobs_id_seq'::text) NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    job_id integer DEFAULT 0 NOT NULL,
    injobdescription character varying(1) DEFAULT 'N'::character varying,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT workersqualifyf_injobdescriptio CHECK ((((injobdescription)::text = ('N'::character varying)::text) OR ((injobdescription)::text = ('Y'::character varying)::text)))
);


--
-- Name: workersqualifyforjobs_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE workersqualifyforjobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: workmonths; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE workmonths (
    id integer DEFAULT nextval('WorkMonths_id_seq'::text) NOT NULL,
    contact_id integer DEFAULT 0 NOT NULL,
    work_year integer DEFAULT 2004 NOT NULL,
    work_month integer DEFAULT 1 NOT NULL,
    day_01 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_02 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_03 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_04 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_05 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_06 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_07 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_08 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_09 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_10 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_11 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_12 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_13 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_14 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_15 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_16 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_17 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_18 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_19 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_20 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_21 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_22 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_23 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_24 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_25 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_26 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_27 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_28 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_29 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_30 numeric(5,2) DEFAULT 0.00 NOT NULL,
    day_31 numeric(5,2) DEFAULT 0.00 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: workmonths_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE workmonths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: allowedstatuses_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY allowedstatuses
    ADD CONSTRAINT allowedstatuses_pkey PRIMARY KEY (id);


--
-- Name: borrow_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY borrow
    ADD CONSTRAINT borrow_pkey PRIMARY KEY (id);


--
-- Name: cards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: cddrives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY cddrives
    ADD CONSTRAINT cddrives_pkey PRIMARY KEY (id);


--
-- Name: cellphones_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY cellphones
    ADD CONSTRAINT cellphones_pkey PRIMARY KEY (id);


--
-- Name: classtree_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY classtree
    ADD CONSTRAINT classtree_pkey PRIMARY KEY (id);


--
-- Name: codedinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY codedinfo
    ADD CONSTRAINT codedinfo_pkey PRIMARY KEY (id);


--
-- Name: components_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY components
    ADD CONSTRAINT components_pkey PRIMARY KEY (id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: contactlist_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY contactlist
    ADD CONSTRAINT contactlist_pkey PRIMARY KEY (id);


--
-- Name: controllercards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY controllercards
    ADD CONSTRAINT controllercards_pkey PRIMARY KEY (id);


--
-- Name: daysoff_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY daysoff
    ADD CONSTRAINT daysoff_pkey PRIMARY KEY (id);


--
-- Name: defaultvalues_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY defaultvalues
    ADD CONSTRAINT defaultvalues_pkey PRIMARY KEY (id);


--
-- Name: donation_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY donation
    ADD CONSTRAINT donation_pkey PRIMARY KEY (id);


--
-- Name: donationline_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY donationline
    ADD CONSTRAINT donationline_pkey PRIMARY KEY (id);


--
-- Name: drives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY drives
    ADD CONSTRAINT drives_pkey PRIMARY KEY (id);


--
-- Name: fieldmap_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY fieldmap
    ADD CONSTRAINT fieldmap_pkey PRIMARY KEY (id);


--
-- Name: floppydrives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY floppydrives
    ADD CONSTRAINT floppydrives_pkey PRIMARY KEY (id);


--
-- Name: gizmoclones_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY gizmoclones
    ADD CONSTRAINT gizmoclones_pkey PRIMARY KEY (id);


--
-- Name: gizmos_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY gizmos
    ADD CONSTRAINT gizmos_pkey PRIMARY KEY (id);


--
-- Name: gizmostatuschanges_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY gizmostatuschanges
    ADD CONSTRAINT gizmostatuschanges_pkey PRIMARY KEY (change_id);


--
-- Name: holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY holidays
    ADD CONSTRAINT holidays_pkey PRIMARY KEY (id);


--
-- Name: ideharddrives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY ideharddrives
    ADD CONSTRAINT ideharddrives_pkey PRIMARY KEY (id);


--
-- Name: income_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY income
    ADD CONSTRAINT income_pkey PRIMARY KEY (id);


--
-- Name: issuenotes_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY issuenotes
    ADD CONSTRAINT issuenotes_pkey PRIMARY KEY (id);


--
-- Name: issues_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: keyboards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY keyboards
    ADD CONSTRAINT keyboards_pkey PRIMARY KEY (id);


--
-- Name: laptops_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY laptops
    ADD CONSTRAINT laptops_pkey PRIMARY KEY (id);


--
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: materials_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: member_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: memberhour_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY memberhour
    ADD CONSTRAINT memberhour_pkey PRIMARY KEY (id);


--
-- Name: misccards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY misccards
    ADD CONSTRAINT misccards_pkey PRIMARY KEY (id);


--
-- Name: misccomponents_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY misccomponents
    ADD CONSTRAINT misccomponents_pkey PRIMARY KEY (id);


--
-- Name: miscdrives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY miscdrives
    ADD CONSTRAINT miscdrives_pkey PRIMARY KEY (id);


--
-- Name: miscgizmos_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY miscgizmos
    ADD CONSTRAINT miscgizmos_pkey PRIMARY KEY (id);


--
-- Name: modems_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY modems
    ADD CONSTRAINT modems_pkey PRIMARY KEY (id);


--
-- Name: modemcards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY modemcards
    ADD CONSTRAINT modemcards_pkey PRIMARY KEY (id);


--
-- Name: monitors_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY monitors
    ADD CONSTRAINT monitors_pkey PRIMARY KEY (id);


--
-- Name: networkcards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY networkcards
    ADD CONSTRAINT networkcards_pkey PRIMARY KEY (id);


--
-- Name: networkingdevices_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY networkingdevices
    ADD CONSTRAINT networkingdevices_pkey PRIMARY KEY (id);


--
-- Name: organization_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: pagelinks_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY pagelinks
    ADD CONSTRAINT pagelinks_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: pickuplines_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY pickuplines
    ADD CONSTRAINT pickuplines_pkey PRIMARY KEY (id);


--
-- Name: pickups_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY pickups
    ADD CONSTRAINT pickups_pkey PRIMARY KEY (id);


--
-- Name: pointingdevices_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY pointingdevices
    ADD CONSTRAINT pointingdevices_pkey PRIMARY KEY (id);


--
-- Name: powersupplies_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY powersupplies
    ADD CONSTRAINT powersupplies_pkey PRIMARY KEY (id);


--
-- Name: printers_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY printers
    ADD CONSTRAINT printers_pkey PRIMARY KEY (id);


--
-- Name: processors_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY processors
    ADD CONSTRAINT processors_pkey PRIMARY KEY (id);


--
-- Name: sales_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: salesline_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY salesline
    ADD CONSTRAINT salesline_pkey PRIMARY KEY (id);


--
-- Name: scanners_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY scanners
    ADD CONSTRAINT scanners_pkey PRIMARY KEY (id);


--
-- Name: scratchpad_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY scratchpad
    ADD CONSTRAINT scratchpad_pkey PRIMARY KEY (id);


--
-- Name: scsicards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY scsicards
    ADD CONSTRAINT scsicards_pkey PRIMARY KEY (id);


--
-- Name: scsiharddrives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY scsiharddrives
    ADD CONSTRAINT scsiharddrives_pkey PRIMARY KEY (id);


--
-- Name: soundcards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY soundcards
    ADD CONSTRAINT soundcards_pkey PRIMARY KEY (id);


--
-- Name: speakers_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY speakers
    ADD CONSTRAINT speakers_pkey PRIMARY KEY (id);


--
-- Name: stereos_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY stereos
    ADD CONSTRAINT stereos_pkey PRIMARY KEY (id);


--
-- Name: systems_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY systems
    ADD CONSTRAINT systems_pkey PRIMARY KEY (id);


--
-- Name: systemboards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY systemboards
    ADD CONSTRAINT systemboards_pkey PRIMARY KEY (id);


--
-- Name: systemcases_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY systemcases
    ADD CONSTRAINT systemcases_pkey PRIMARY KEY (id);


--
-- Name: tapedrives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY tapedrives
    ADD CONSTRAINT tapedrives_pkey PRIMARY KEY (id);


--
-- Name: unit2material_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY unit2material
    ADD CONSTRAINT unit2material_pkey PRIMARY KEY (id);


--
-- Name: upses_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY upses
    ADD CONSTRAINT upses_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vcrs_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY vcrs
    ADD CONSTRAINT vcrs_pkey PRIMARY KEY (id);


--
-- Name: videocards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY videocards
    ADD CONSTRAINT videocards_pkey PRIMARY KEY (id);


--
-- Name: weeklyshifts_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY weeklyshifts
    ADD CONSTRAINT weeklyshifts_pkey PRIMARY KEY (id);


--
-- Name: workers_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (id);


--
-- Name: workersqualifyforjobs_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY workersqualifyforjobs
    ADD CONSTRAINT workersqualifyforjobs_pkey PRIMARY KEY (id);


--
-- Name: workmonths_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY workmonths
    ADD CONSTRAINT workmonths_pkey PRIMARY KEY (id);


--
-- Name: contact_sortname; Type: INDEX; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE INDEX contact_sortname ON contact USING btree (sortname);


--
-- Name: mailingpieces_id_key; Type: INDEX; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE UNIQUE INDEX mailingpieces_id_key ON mailingpieces USING btree (id);


--
-- Name: mailings_id_key; Type: INDEX; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE UNIQUE INDEX mailings_id_key ON mailings USING btree (id);


--
-- Name: users_username_key; Type: INDEX; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE UNIQUE INDEX users_username_key ON users USING btree (username);


--
-- Name: RI_ConstraintTrigger_54137; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER components_gizmo_fk
    AFTER INSERT OR UPDATE ON components
    FROM gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('components_gizmo_fk', 'components', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54138; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER components_gizmos_fk
    AFTER DELETE ON gizmos
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('components_gizmos_fk', 'components', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54139; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER components_gizmos_fk
    AFTER UPDATE ON gizmos
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('components_gizmos_fk', 'components', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54140; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER cards_components_fk
    AFTER INSERT OR UPDATE ON cards
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('cards_components_fk', 'cards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54141; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER cards_components_fk
    AFTER DELETE ON components
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('cards_components_fk', 'cards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54142; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER cards_components_fk
    AFTER UPDATE ON components
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('cards_components_fk', 'cards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54143; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misccards_cards_fk
    AFTER INSERT OR UPDATE ON misccards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('misccards_cards_fk', 'misccards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54144; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misccards_cards_fk
    AFTER DELETE ON cards
    FROM misccards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('misccards_cards_fk', 'misccards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54145; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misccards_cards_fk
    AFTER UPDATE ON cards
    FROM misccards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('misccards_cards_fk', 'misccards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54146; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modemcards_cards_fk
    AFTER INSERT OR UPDATE ON modemcards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('modemcards_cards_fk', 'modemcards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54147; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modemcards_cards_fk
    AFTER DELETE ON cards
    FROM modemcards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('modemcards_cards_fk', 'modemcards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54148; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modemcards_cards_fk
    AFTER UPDATE ON cards
    FROM modemcards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('modemcards_cards_fk', 'modemcards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54149; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER networkcards_cards_fk
    AFTER INSERT OR UPDATE ON networkcards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('networkcards_cards_fk', 'networkcards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54150; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER networkcards_cards_fk
    AFTER DELETE ON cards
    FROM networkcards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('networkcards_cards_fk', 'networkcards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54151; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER networkcards_cards_fk
    AFTER UPDATE ON cards
    FROM networkcards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('networkcards_cards_fk', 'networkcards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54152; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsicards_cards_fk
    AFTER INSERT OR UPDATE ON scsicards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('scsicards_cards_fk', 'scsicards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54153; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsicards_cards_fk
    AFTER DELETE ON cards
    FROM scsicards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('scsicards_cards_fk', 'scsicards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54154; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsicards_cards_fk
    AFTER UPDATE ON cards
    FROM scsicards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('scsicards_cards_fk', 'scsicards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54155; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER soundcards_cards_fk
    AFTER INSERT OR UPDATE ON soundcards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('soundcards_cards_fk', 'soundcards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54156; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER soundcards_cards_fk
    AFTER DELETE ON cards
    FROM soundcards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('soundcards_cards_fk', 'soundcards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54157; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER soundcards_cards_fk
    AFTER UPDATE ON cards
    FROM soundcards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('soundcards_cards_fk', 'soundcards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54158; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER videocards_cards_fk
    AFTER INSERT OR UPDATE ON videocards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('videocards_cards_fk', 'videocards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54159; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER videocards_cards_fk
    AFTER DELETE ON cards
    FROM videocards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('videocards_cards_fk', 'videocards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54160; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER videocards_cards_fk
    AFTER UPDATE ON cards
    FROM videocards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('videocards_cards_fk', 'videocards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54161; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER controllercards_cards_fk
    AFTER INSERT OR UPDATE ON controllercards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('controllercards_cards_fk', 'controllercards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54162; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER controllercards_cards_fk
    AFTER DELETE ON cards
    FROM controllercards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('controllercards_cards_fk', 'controllercards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54163; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER controllercards_cards_fk
    AFTER UPDATE ON cards
    FROM controllercards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('controllercards_cards_fk', 'controllercards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54164; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER drives_gizmos_fk
    AFTER INSERT OR UPDATE ON drives
    FROM gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('drives_gizmos_fk', 'drives', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54165; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER drives_gizmos_fk
    AFTER DELETE ON gizmos
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('drives_gizmos_fk', 'drives', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54166; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER drives_gizmos_fk
    AFTER UPDATE ON gizmos
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('drives_gizmos_fk', 'drives', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54167; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER floppydrives_drives_fk
    AFTER INSERT OR UPDATE ON floppydrives
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('floppydrives_drives_fk', 'floppydrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54168; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER floppydrives_drives_fk
    AFTER DELETE ON drives
    FROM floppydrives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('floppydrives_drives_fk', 'floppydrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54169; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER floppydrives_drives_fk
    AFTER UPDATE ON drives
    FROM floppydrives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('floppydrives_drives_fk', 'floppydrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54170; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER ideharddrives_drives_fk
    AFTER INSERT OR UPDATE ON ideharddrives
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('ideharddrives_drives_fk', 'ideharddrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54171; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER ideharddrives_drives_fk
    AFTER DELETE ON drives
    FROM ideharddrives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('ideharddrives_drives_fk', 'ideharddrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54172; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER ideharddrives_drives_fk
    AFTER UPDATE ON drives
    FROM ideharddrives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('ideharddrives_drives_fk', 'ideharddrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54173; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER miscdrives_drives_fk
    AFTER INSERT OR UPDATE ON miscdrives
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('miscdrives_drives_fk', 'miscdrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54174; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER miscdrives_drives_fk
    AFTER DELETE ON drives
    FROM miscdrives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('miscdrives_drives_fk', 'miscdrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54175; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER miscdrives_drives_fk
    AFTER UPDATE ON drives
    FROM miscdrives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('miscdrives_drives_fk', 'miscdrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54176; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsiharddrives_drives_fk
    AFTER INSERT OR UPDATE ON scsiharddrives
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('scsiharddrives_drives_fk', 'scsiharddrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54177; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsiharddrives_drives_fk
    AFTER DELETE ON drives
    FROM scsiharddrives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('scsiharddrives_drives_fk', 'scsiharddrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54178; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsiharddrives_drives_fk
    AFTER UPDATE ON drives
    FROM scsiharddrives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('scsiharddrives_drives_fk', 'scsiharddrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54179; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER tapedrives_drives_fk
    AFTER INSERT OR UPDATE ON tapedrives
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('tapedrives_drives_fk', 'tapedrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54180; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER tapedrives_drives_fk
    AFTER DELETE ON drives
    FROM tapedrives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('tapedrives_drives_fk', 'tapedrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54181; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER tapedrives_drives_fk
    AFTER UPDATE ON drives
    FROM tapedrives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('tapedrives_drives_fk', 'tapedrives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54182; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER keyboards_components_fk
    AFTER INSERT OR UPDATE ON keyboards
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('keyboards_components_fk', 'keyboards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54183; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER keyboards_components_fk
    AFTER DELETE ON components
    FROM keyboards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('keyboards_components_fk', 'keyboards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54184; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER keyboards_components_fk
    AFTER UPDATE ON components
    FROM keyboards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('keyboards_components_fk', 'keyboards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54185; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misccomponents_components_fk
    AFTER INSERT OR UPDATE ON misccomponents
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('misccomponents_components_fk', 'misccomponents', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54186; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misccomponents_components_fk
    AFTER DELETE ON components
    FROM misccomponents
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('misccomponents_components_fk', 'misccomponents', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54187; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misccomponents_components_fk
    AFTER UPDATE ON components
    FROM misccomponents
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('misccomponents_components_fk', 'misccomponents', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54188; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modems_components_fk
    AFTER INSERT OR UPDATE ON modems
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('modems_components_fk', 'modems', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54189; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modems_components_fk
    AFTER DELETE ON components
    FROM modems
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('modems_components_fk', 'modems', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54190; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modems_components_fk
    AFTER UPDATE ON components
    FROM modems
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('modems_components_fk', 'modems', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54191; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER monitors_components_fk
    AFTER INSERT OR UPDATE ON monitors
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('monitors_components_fk', 'monitors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54192; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER monitors_components_fk
    AFTER DELETE ON components
    FROM monitors
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('monitors_components_fk', 'monitors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54193; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER monitors_components_fk
    AFTER UPDATE ON components
    FROM monitors
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('monitors_components_fk', 'monitors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54194; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER pointingdevices_components_fk
    AFTER INSERT OR UPDATE ON pointingdevices
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('pointingdevices_components_fk', 'pointingdevices', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54195; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER pointingdevices_components_fk
    AFTER DELETE ON components
    FROM pointingdevices
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('pointingdevices_components_fk', 'pointingdevices', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54196; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER pointingdevices_components_fk
    AFTER UPDATE ON components
    FROM pointingdevices
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('pointingdevices_components_fk', 'pointingdevices', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54197; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER powersupplies_components_fk
    AFTER INSERT OR UPDATE ON powersupplies
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('powersupplies_components_fk', 'powersupplies', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54198; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER powersupplies_components_fk
    AFTER DELETE ON components
    FROM powersupplies
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('powersupplies_components_fk', 'powersupplies', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54199; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER powersupplies_components_fk
    AFTER UPDATE ON components
    FROM powersupplies
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('powersupplies_components_fk', 'powersupplies', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54200; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER printers_components_fk
    AFTER INSERT OR UPDATE ON printers
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('printers_components_fk', 'printers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54201; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER printers_components_fk
    AFTER DELETE ON components
    FROM printers
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('printers_components_fk', 'printers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54202; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER printers_components_fk
    AFTER UPDATE ON components
    FROM printers
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('printers_components_fk', 'printers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54203; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER processors_components_fk
    AFTER INSERT OR UPDATE ON processors
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('processors_components_fk', 'processors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54204; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER processors_components_fk
    AFTER DELETE ON components
    FROM processors
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('processors_components_fk', 'processors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54205; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER processors_components_fk
    AFTER UPDATE ON components
    FROM processors
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('processors_components_fk', 'processors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54206; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scanners_components_fk
    AFTER INSERT OR UPDATE ON scanners
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('scanners_components_fk', 'scanners', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54207; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scanners_components_fk
    AFTER DELETE ON components
    FROM scanners
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('scanners_components_fk', 'scanners', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54208; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scanners_components_fk
    AFTER UPDATE ON components
    FROM scanners
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('scanners_components_fk', 'scanners', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54209; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER speakers_components_fk
    AFTER INSERT OR UPDATE ON speakers
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('speakers_components_fk', 'speakers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54210; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER speakers_components_fk
    AFTER DELETE ON components
    FROM speakers
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('speakers_components_fk', 'speakers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54211; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER speakers_components_fk
    AFTER UPDATE ON components
    FROM speakers
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('speakers_components_fk', 'speakers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54212; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systemboards_components_fk
    AFTER INSERT OR UPDATE ON systemboards
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('systemboards_components_fk', 'systemboards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54213; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systemboards_components_fk
    AFTER DELETE ON components
    FROM systemboards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('systemboards_components_fk', 'systemboards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54214; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systemboards_components_fk
    AFTER UPDATE ON components
    FROM systemboards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('systemboards_components_fk', 'systemboards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54215; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER miscgizmos_gizmos_fk
    AFTER INSERT OR UPDATE ON miscgizmos
    FROM gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('miscgizmos_gizmos_fk', 'miscgizmos', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54216; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER miscgizmos_gizmos_fk
    AFTER DELETE ON gizmos
    FROM miscgizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('miscgizmos_gizmos_fk', 'miscgizmos', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54217; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER miscgizmos_gizmos_fk
    AFTER UPDATE ON gizmos
    FROM miscgizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('miscgizmos_gizmos_fk', 'miscgizmos', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54218; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systems_gizmos_fk
    AFTER INSERT OR UPDATE ON systems
    FROM gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('systems_gizmos_fk', 'systems', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54219; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systems_gizmos_fk
    AFTER DELETE ON gizmos
    FROM systems
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('systems_gizmos_fk', 'systems', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54220; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systems_gizmos_fk
    AFTER UPDATE ON gizmos
    FROM systems
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('systems_gizmos_fk', 'systems', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54221; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systemcases_gizmos_fk
    AFTER INSERT OR UPDATE ON systemcases
    FROM gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('systemcases_gizmos_fk', 'systemcases', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54222; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systemcases_gizmos_fk
    AFTER DELETE ON gizmos
    FROM systemcases
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('systemcases_gizmos_fk', 'systemcases', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_54223; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systemcases_gizmos_fk
    AFTER UPDATE ON gizmos
    FROM systemcases
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('systemcases_gizmos_fk', 'systemcases', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: borrow_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER borrow_created_trigger
    BEFORE INSERT ON borrow
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: borrow_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER borrow_modified_trigger
    BEFORE UPDATE ON borrow
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: codedinfo_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER codedinfo_created_trigger
    BEFORE INSERT ON codedinfo
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: codedinfo_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER codedinfo_modified_trigger
    BEFORE UPDATE ON codedinfo
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: contact_addr_change_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER contact_addr_change_trigger
    BEFORE UPDATE ON contact
    FOR EACH ROW
    EXECUTE PROCEDURE contact_addr_trigger();


--
-- Name: contact_addr_insert_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER contact_addr_insert_trigger
    BEFORE INSERT ON contact
    FOR EACH ROW
    EXECUTE PROCEDURE contact_addr_trigger2();


--
-- Name: contact_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER contact_created_trigger
    BEFORE INSERT ON contact
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: contact_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER contact_modified_trigger
    BEFORE UPDATE ON contact
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: contactlist_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER contactlist_created_trigger
    BEFORE INSERT ON contactlist
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: contactlist_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER contactlist_modified_trigger
    BEFORE UPDATE ON contactlist
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: daysoff_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER daysoff_created_trigger
    BEFORE INSERT ON daysoff
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: daysoff_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER daysoff_modified_trigger
    BEFORE UPDATE ON daysoff
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: donation_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER donation_created_trigger
    BEFORE INSERT ON donation
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: donation_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER donation_modified_trigger
    BEFORE UPDATE ON donation
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: gizmoclones_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER gizmoclones_created_trigger
    BEFORE INSERT ON gizmoclones
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: gizmoclones_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER gizmoclones_modified_trigger
    BEFORE UPDATE ON gizmoclones
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: gizmos_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER gizmos_created_trigger
    BEFORE INSERT ON gizmos
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: gizmos_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER gizmos_modified_trigger
    BEFORE UPDATE ON gizmos
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: gizmos_status_change_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER gizmos_status_change_trigger
    BEFORE UPDATE ON gizmos
    FOR EACH ROW
    EXECUTE PROCEDURE gizmos_status_changed();


--
-- Name: gizmos_status_insert_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER gizmos_status_insert_trigger
    BEFORE INSERT ON gizmos
    FOR EACH ROW
    EXECUTE PROCEDURE gizmos_status_insert();


--
-- Name: holidays_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER holidays_created_trigger
    BEFORE INSERT ON holidays
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: holidays_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER holidays_modified_trigger
    BEFORE UPDATE ON holidays
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: income_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER income_created_trigger
    BEFORE INSERT ON income
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: income_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER income_modified_trigger
    BEFORE UPDATE ON income
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: issuenotes_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER issuenotes_created_trigger
    BEFORE INSERT ON issuenotes
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: issuenotes_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER issuenotes_modified_trigger
    BEFORE UPDATE ON issuenotes
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: issues_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER issues_created_trigger
    BEFORE INSERT ON issues
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: issues_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER issues_modified_trigger
    BEFORE UPDATE ON issues
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: jobs_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER jobs_created_trigger
    BEFORE INSERT ON jobs
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: jobs_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER jobs_modified_trigger
    BEFORE UPDATE ON jobs
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: materials_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER materials_created_trigger
    BEFORE INSERT ON materials
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: materials_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER materials_modified_trigger
    BEFORE UPDATE ON materials
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: member_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER member_created_trigger
    BEFORE INSERT ON member
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: member_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER member_modified_trigger
    BEFORE UPDATE ON member
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: memberhour_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER memberhour_created_trigger
    BEFORE INSERT ON memberhour
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: memberhour_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER memberhour_modified_trigger
    BEFORE UPDATE ON memberhour
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: organization_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER organization_created_trigger
    BEFORE INSERT ON organization
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: organization_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER organization_modified_trigger
    BEFORE UPDATE ON organization
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: pages_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER pages_created_trigger
    BEFORE INSERT ON pages
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: pages_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER pages_modified_trigger
    BEFORE UPDATE ON pages
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: pickuplines_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER pickuplines_created_trigger
    BEFORE INSERT ON pickuplines
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: pickuplines_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER pickuplines_modified_trigger
    BEFORE UPDATE ON pickuplines
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: pickups_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER pickups_created_trigger
    BEFORE INSERT ON pickups
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: pickups_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER pickups_modified_trigger
    BEFORE UPDATE ON pickups
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: sales_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER sales_created_trigger
    BEFORE INSERT ON sales
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: sales_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER sales_modified_trigger
    BEFORE UPDATE ON sales
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: scratchpad_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER scratchpad_created_trigger
    BEFORE INSERT ON scratchpad
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: scratchpad_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER scratchpad_modified_trigger
    BEFORE UPDATE ON scratchpad
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: unit2material_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER unit2material_created_trigger
    BEFORE INSERT ON unit2material
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: unit2material_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER unit2material_modified_trigger
    BEFORE UPDATE ON unit2material
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: weeklyshifts_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER weeklyshifts_created_trigger
    BEFORE INSERT ON weeklyshifts
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: weeklyshifts_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER weeklyshifts_modified_trigger
    BEFORE UPDATE ON weeklyshifts
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: workers_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER workers_created_trigger
    BEFORE INSERT ON workers
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: workers_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER workers_modified_trigger
    BEFORE UPDATE ON workers
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: workersqualifyforjobs_created_t; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER workersqualifyforjobs_created_t
    BEFORE INSERT ON workersqualifyforjobs
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: workersqualifyforjobs_modified_; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER workersqualifyforjobs_modified_
    BEFORE UPDATE ON workersqualifyforjobs
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: workmonths_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER workmonths_created_trigger
    BEFORE INSERT ON workmonths
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: workmonths_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER workmonths_modified_trigger
    BEFORE UPDATE ON workmonths
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: cards_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: cddrives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY cddrives
    ADD CONSTRAINT cddrives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: components_gizmos_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY components
    ADD CONSTRAINT components_gizmos_fk FOREIGN KEY (id) REFERENCES gizmos(id);


--
-- Name: controllercards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY controllercards
    ADD CONSTRAINT controllercards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: drives_gizmos_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY drives
    ADD CONSTRAINT drives_gizmos_fk FOREIGN KEY (id) REFERENCES gizmos(id);


--
-- Name: floppydrives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY floppydrives
    ADD CONSTRAINT floppydrives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: ideharddrives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY ideharddrives
    ADD CONSTRAINT ideharddrives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: keyboards_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY keyboards
    ADD CONSTRAINT keyboards_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: misccards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY misccards
    ADD CONSTRAINT misccards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: misccomponents_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY misccomponents
    ADD CONSTRAINT misccomponents_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: miscdrives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY miscdrives
    ADD CONSTRAINT miscdrives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: miscgizmos_gizmos_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY miscgizmos
    ADD CONSTRAINT miscgizmos_gizmos_fk FOREIGN KEY (id) REFERENCES gizmos(id);


--
-- Name: modems_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY modems
    ADD CONSTRAINT modems_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: modemcards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY modemcards
    ADD CONSTRAINT modemcards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: monitors_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY monitors
    ADD CONSTRAINT monitors_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: networkcards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY networkcards
    ADD CONSTRAINT networkcards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: pointingdevices_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY pointingdevices
    ADD CONSTRAINT pointingdevices_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: powersupplies_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY powersupplies
    ADD CONSTRAINT powersupplies_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: printers_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY printers
    ADD CONSTRAINT printers_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: processors_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY processors
    ADD CONSTRAINT processors_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: scanners_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY scanners
    ADD CONSTRAINT scanners_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: scsicards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY scsicards
    ADD CONSTRAINT scsicards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: scsiharddrives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY scsiharddrives
    ADD CONSTRAINT scsiharddrives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: soundcards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY soundcards
    ADD CONSTRAINT soundcards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: speakers_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY speakers
    ADD CONSTRAINT speakers_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: systems_gizmos_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY systems
    ADD CONSTRAINT systems_gizmos_fk FOREIGN KEY (id) REFERENCES gizmos(id);


--
-- Name: systemboards_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY systemboards
    ADD CONSTRAINT systemboards_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: systemcases_gizmos_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY systemcases
    ADD CONSTRAINT systemcases_gizmos_fk FOREIGN KEY (id) REFERENCES gizmos(id);


--
-- Name: tapedrives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY tapedrives
    ADD CONSTRAINT tapedrives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: videocards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY videocards
    ADD CONSTRAINT videocards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- PostgreSQL database dump complete
--

