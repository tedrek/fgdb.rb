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
-- Name: plpgsql_call_handler(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION plpgsql_call_handler() RETURNS language_handler
    AS '$libdir/plpgsql', 'plpgsql_call_handler'
    LANGUAGE c;


--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: public; Owner: 
--

CREATE TRUSTED PROCEDURAL LANGUAGE plpgsql HANDLER plpgsql_call_handler;


--
-- Name: contact_addr_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
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
-- Name: contact_addr_trigger2(); Type: FUNCTION; Schema: public; Owner: postgres
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
-- Name: created_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
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
-- Name: d_connect(character varying); Type: FUNCTION; Schema: public; Owner: postgres
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

UPDATE donation SET contactid = PARENT_ID WHERE dupe_key = DUPEKEY;

RETURN 0 ;
END ;
$_$
    LANGUAGE plpgsql;


--
-- Name: format_phone(character varying); Type: FUNCTION; Schema: public; Owner: postgres
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
-- Name: get_sort_name(character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: postgres
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
-- Name: gizmo_status_changed(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gizmo_status_changed() RETURNS "trigger"
    AS $$
  BEGIN
    IF NEW.newstatus <> OLD.newstatus THEN
      INSERT INTO gizmostatuschanges (id, oldStatus, newStatus) VALUES (OLD.id, OLD.newstatus, NEW.newstatus);
      -- this is redundant oldstatus is in the history table, so
      -- it does not really need to be in gizmo as well
      NEW.oldstatus := OLD.newstatus;
    END IF;
    RETURN NEW;
  END;
$$
    LANGUAGE plpgsql;


--
-- Name: gizmo_status_insert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION gizmo_status_insert() RETURNS "trigger"
    AS $$
  BEGIN
    INSERT INTO gizmostatuschanges (id, oldStatus, newStatus) VALUES (NEW.id, 'none', NEW.newstatus);
    -- this is redundant oldstatus is in the history table, so
    -- it does not really need to be in gizmo as well
    NEW.oldstatus := 'none';
    RETURN NEW;
  END;
$$
    LANGUAGE plpgsql;


--
-- Name: merge(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION merge(integer, integer) RETURNS integer
    AS $_$ 
DECLARE
    KEEP_ID ALIAS FOR $1 ;
    TOSS_ID ALIAS FOR $2 ;




BEGIN



UPDATE sales        SET contactid = KEEP_ID WHERE contactid = TOSS_ID;
UPDATE donation     SET contactid = KEEP_ID WHERE contactid = TOSS_ID;
UPDATE income       SET contactid = KEEP_ID WHERE contactid = TOSS_ID;
UPDATE pickups      SET vendorid  = KEEP_ID WHERE vendorid  = TOSS_ID;

UPDATE workersqualifyforjobs 
                    SET contactid = KEEP_ID WHERE contactid = TOSS_ID;
UPDATE daysoff      SET contactid = KEEP_ID WHERE contactid = TOSS_ID;
UPDATE workmonths   SET contactid = KEEP_ID WHERE contactid = TOSS_ID;
UPDATE weeklyshifts SET contactid = KEEP_ID WHERE contactid = TOSS_ID;
UPDATE workers      SET id =        KEEP_ID WHERE id        = TOSS_ID
    AND NOT EXISTS (SELECT * FROM workers WHERE id = KEEP_ID);

UPDATE memberhour   SET memberid  = KEEP_ID WHERE memberid  = TOSS_ID;
UPDATE member       SET id        = KEEP_ID WHERE id        = TOSS_ID
    AND NOT EXISTS (SELECT * FROM member WHERE id = KEEP_ID);

UPDATE contactlist  SET contactid = KEEP_ID WHERE contactid = TOSS_ID;
UPDATE borrow       SET contactid = KEEP_ID WHERE contactid = TOSS_ID;
UPDATE gizmo        SET inspectorid = 
                                    KEEP_ID WHERE inspectorid = 
                                                             TOSS_ID;
UPDATE gizmo        SET adopterid = KEEP_ID WHERE adopterid = TOSS_ID;
UPDATE gizmo        SET builderid = KEEP_ID WHERE builderid = TOSS_ID;
UPDATE scratchpad   SET contactid = KEEP_ID WHERE contactid = TOSS_ID;






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
DELETE FROM dupe_sets WHERE keepid = KEEP_ID AND tossid = TOSS_ID;
RETURN 0 ;
END ;
$_$
    LANGUAGE plpgsql;


--
-- Name: modified_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
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
-- Name: s_connect(character varying); Type: FUNCTION; Schema: public; Owner: postgres
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

UPDATE sales SET contactid = PARENT_ID WHERE dupe_key = DUPEKEY;

RETURN 0 ;
END ;
$_$
    LANGUAGE plpgsql;


--
-- Name: swap(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION swap(integer, integer) RETURNS integer
    AS $_$ 
DECLARE
    KEEP_ID ALIAS FOR $1 ;
    TOSS_ID ALIAS FOR $2 ;

BEGIN

UPDATE dupe_sets SET 
    keepid = TOSS_ID, tossid = KEEP_ID 
    WHERE keepid = KEEP_ID AND tossid = TOSS_ID;

RETURN 0 ;

END ;
$_$
    LANGUAGE plpgsql;


SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: allowedstatuses; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE allowedstatuses (
    id integer DEFAULT nextval('allowedStatuses_id_seq'::text) NOT NULL,
    oldstatus character varying(15),
    newstatus character varying(15)
);


--
-- Name: allowedstatuses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE allowedstatuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: anondict_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE anondict_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: answers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE answers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: borrow; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE borrow (
    id integer DEFAULT nextval('Borrow_id_seq'::text) NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
    gizmoid integer DEFAULT 0 NOT NULL,
    borrowdate date NOT NULL,
    returndate date NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: borrow_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE borrow_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: card; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE card (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    slottype character varying(10)
);


--
-- Name: cddrive; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cddrive (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    interface character varying(10) DEFAULT ''::character varying,
    speed character varying(10) DEFAULT ''::character varying,
    writemode character varying(15) DEFAULT ''::character varying,
    scsi character varying(1) DEFAULT 'N'::character varying,
    spinrate integer,
    CONSTRAINT cddrive_scsi CHECK ((((scsi)::text = ('N'::character varying)::text) OR ((scsi)::text = ('Y'::character varying)::text)))
);


--
-- Name: cellphone; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cellphone (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100)
);


--
-- Name: classtree; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
-- Name: classtree_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE classtree_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: cleanup; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cleanup (
    id integer,
    waiting character(1),
    member character(1),
    volunteer character(1),
    donor character(1),
    buyer character(1),
    sourceid integer,
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
    contactid integer,
    donationid integer,
    salesid integer
);


--
-- Name: codedinfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
-- Name: codedinfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE codedinfo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: component; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE component (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    insysid integer DEFAULT 0 NOT NULL
);


--
-- Name: contact; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
-- Name: contact_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: contactlist; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE contactlist (
    id integer DEFAULT nextval('ContactList_id_seq'::text) NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
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
-- Name: contactlist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE contactlist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: controllercard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE controllercard (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    numserial integer DEFAULT 0 NOT NULL,
    numparallel integer DEFAULT 0 NOT NULL,
    numide integer DEFAULT 0 NOT NULL,
    floppy character varying(1) DEFAULT 'Y'::character varying NOT NULL,
    CONSTRAINT controllercard_floppy CHECK ((((floppy)::text = ('N'::character varying)::text) OR ((floppy)::text = ('Y'::character varying)::text)))
);


--
-- Name: daysoff; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE daysoff (
    id integer DEFAULT nextval('DaysOff_id_seq'::text) NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
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
-- Name: daysoff_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE daysoff_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: deduper; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE deduper (
    id integer,
    waiting character varying,
    member character varying,
    volunteer character varying,
    donor character varying,
    buyer character varying,
    sourceid integer,
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
-- Name: defaultvalues; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE defaultvalues (
    id integer DEFAULT nextval('defaultValues_id_seq'::text) NOT NULL,
    classtree character varying(100),
    fieldname character varying(50),
    defaultvalue character varying(50)
);


--
-- Name: defaultvalues_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE defaultvalues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: donation; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE donation (
    id integer DEFAULT nextval('Donation_id_seq'::text) NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
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
-- Name: donation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE donation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: donationline; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE donationline (
    id integer DEFAULT nextval('DonationLine_id_seq'::text) NOT NULL,
    donationid integer DEFAULT 0 NOT NULL,
    description text,
    quantity integer DEFAULT 1 NOT NULL,
    crt boolean
);


--
-- Name: donationline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE donationline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: drive; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE drive (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100)
);


--
-- Name: dupe_keys; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dupe_keys (
    dupe_key character varying(50),
    id integer,
    count bigint
);


--
-- Name: dupe_sets; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE dupe_sets (
    keepid integer,
    tossid integer
);


--
-- Name: fieldmap; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
-- Name: fieldmap_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE fieldmap_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: floppydrive; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE floppydrive (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    disksize character varying(10),
    capacity character varying(10),
    cylinders integer DEFAULT 0,
    heads integer DEFAULT 0,
    sectors integer DEFAULT 0
);


--
-- Name: gizmo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE gizmo (
    id integer DEFAULT nextval('Gizmo_id_seq'::text) NOT NULL,
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
    builderid integer DEFAULT 0 NOT NULL,
    inspectorid integer DEFAULT 0 NOT NULL,
    linuxfund character varying(1) DEFAULT 'N'::character varying NOT NULL,
    cashvalue numeric(8,2) DEFAULT 0.00 NOT NULL,
    needsexpert character varying(1) DEFAULT 'N'::character varying,
    gizmotype character varying(10) DEFAULT 'Other'::character varying,
    adopterid integer DEFAULT 0 NOT NULL,
    CONSTRAINT gizmo_linuxfund CHECK (((((linuxfund)::text = ('N'::character varying)::text) OR ((linuxfund)::text = ('Y'::character varying)::text)) OR ((linuxfund)::text = ('M'::character varying)::text))),
    CONSTRAINT gizmo_needsexpert CHECK ((((needsexpert)::text = ('N'::character varying)::text) OR ((needsexpert)::text = ('Y'::character varying)::text))),
    CONSTRAINT gizmo_obsolete CHECK (((((obsolete)::text = ('N'::character varying)::text) OR ((obsolete)::text = ('Y'::character varying)::text)) OR ((obsolete)::text = ('M'::character varying)::text))),
    CONSTRAINT gizmo_testdata CHECK ((((testdata)::text = ('N'::character varying)::text) OR ((testdata)::text = ('Y'::character varying)::text))),
    CONSTRAINT gizmo_working CHECK (((((working)::text = ('N'::character varying)::text) OR ((working)::text = ('Y'::character varying)::text)) OR ((working)::text = ('M'::character varying)::text)))
);


--
-- Name: gizmo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE gizmo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gizmoclones; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE gizmoclones (
    id integer DEFAULT nextval('GizmoClones_id_seq'::text) NOT NULL,
    parentid integer DEFAULT 0 NOT NULL,
    childid integer DEFAULT 0 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: gizmoclones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE gizmoclones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gizmostatuschanges; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE gizmostatuschanges (
    id integer DEFAULT 0 NOT NULL,
    oldstatus character varying(15),
    newstatus character varying(15),
    created timestamp with time zone DEFAULT now(),
    change_id integer DEFAULT nextval('GizmoStatusChanges_change_id_se'::text) NOT NULL
);


--
-- Name: gizmostatuschanges_change_id_se; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE gizmostatuschanges_change_id_se
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: helpscreen_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE helpscreen_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: holidays; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE holidays (
    id integer DEFAULT nextval('Holidays_id_seq'::text) NOT NULL,
    name character varying(50),
    holiday date,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: holidays_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE holidays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ideharddrive; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ideharddrive (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    cylinders integer DEFAULT 0 NOT NULL,
    heads integer DEFAULT 0 NOT NULL,
    sectors integer DEFAULT 0 NOT NULL,
    ata character varying(10),
    sizemb integer DEFAULT 0 NOT NULL
);


--
-- Name: income; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE income (
    id integer DEFAULT nextval('Income_id_seq'::text) NOT NULL,
    incometype character varying(10),
    description character varying(50),
    received date,
    amount numeric(8,2) DEFAULT 0.00 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    contactid integer DEFAULT 0 NOT NULL
);


--
-- Name: income_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE income_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: issuenotes; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE issuenotes (
    id integer DEFAULT 0 NOT NULL,
    issueid integer DEFAULT 0 NOT NULL,
    techname character varying(25),
    notes text,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: issues; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE issues (
    id integer DEFAULT 0 NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
    gizmoid integer DEFAULT 0 NOT NULL,
    issuename character varying(100),
    issuestatus character varying(10),
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: jobs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: keyboard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE keyboard (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    kbtype character varying(10),
    numkeys character varying(10)
);


--
-- Name: laptop; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE laptop (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    ram integer,
    harddrivesizegb numeric(8,2) DEFAULT 0.00,
    chipclass character varying(15),
    chipspeed integer DEFAULT 0 NOT NULL
);


--
-- Name: links; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: mailingpieces; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE mailingpieces (
    id integer DEFAULT nextval('"mailingpieces_id_seq"'::text) NOT NULL,
    mailingid integer DEFAULT 0 NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
    container integer,
    containertype character varying(10),
    bundle integer
);


--
-- Name: mailingpieces_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE mailingpieces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: mailings; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
-- Name: mailings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE mailings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: materials; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
-- Name: materials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: member; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
-- Name: memberhour; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE memberhour (
    id integer DEFAULT nextval('MemberHour_id_seq'::text) NOT NULL,
    memberid integer DEFAULT 0 NOT NULL,
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
-- Name: memberhour_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE memberhour_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: misccard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE misccard (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    miscnotes text
);


--
-- Name: misccomponent; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE misccomponent (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    miscnotes text
);


--
-- Name: miscdrive; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE miscdrive (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    miscnotes text
);


--
-- Name: miscgizmo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE miscgizmo (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100)
);


--
-- Name: modem; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE modem (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    speed character varying(15)
);


--
-- Name: modemcard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE modemcard (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    speed character varying(15)
);


--
-- Name: monitor; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE monitor (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    size character varying(10),
    resolution character varying(10)
);


--
-- Name: networkcard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE networkcard (
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
    CONSTRAINT networkcard_aux CHECK ((((aux)::text = ('N'::character varying)::text) OR ((aux)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkcard_bnc CHECK ((((bnc)::text = ('N'::character varying)::text) OR ((bnc)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkcard_rj45 CHECK ((((rj45)::text = ('N'::character varying)::text) OR ((rj45)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkcard_thicknet CHECK ((((thicknet)::text = ('N'::character varying)::text) OR ((thicknet)::text = ('Y'::character varying)::text)))
);


--
-- Name: networkingdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE networkingdevice (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    speed character varying(10),
    rj45 character varying(1) DEFAULT 'N'::character varying NOT NULL,
    aux character varying(1) DEFAULT 'N'::character varying NOT NULL,
    bnc character varying(1) DEFAULT 'N'::character varying NOT NULL,
    thicknet character varying(1) DEFAULT 'N'::character varying NOT NULL,
    CONSTRAINT networkingdevice_aux CHECK ((((aux)::text = ('N'::character varying)::text) OR ((aux)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkingdevice_bnc CHECK ((((bnc)::text = ('N'::character varying)::text) OR ((bnc)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkingdevice_rj45 CHECK ((((rj45)::text = ('N'::character varying)::text) OR ((rj45)::text = ('Y'::character varying)::text))),
    CONSTRAINT networkingdevice_thicknet CHECK ((((thicknet)::text = ('N'::character varying)::text) OR ((thicknet)::text = ('Y'::character varying)::text)))
);


--
-- Name: options_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE options_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: organization; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE organization (
    id integer DEFAULT 0 NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
    missionstatement text,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: pagelinks; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pagelinks (
    id integer DEFAULT nextval('PageLinks_id_seq'::text) NOT NULL,
    pageid integer DEFAULT 0 NOT NULL,
    linkid integer DEFAULT 0 NOT NULL,
    break character varying(1) DEFAULT 'N'::character varying,
    displayorder integer DEFAULT 0 NOT NULL,
    helptext character varying(100),
    linktext character varying(250),
    CONSTRAINT pagelinks_break CHECK ((((break)::text = ('N'::character varying)::text) OR ((break)::text = ('Y'::character varying)::text)))
);


--
-- Name: pagelinks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pagelinks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pages; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pages (
    id integer DEFAULT nextval('Pages_id_seq'::text) NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    shortname character varying(25),
    longname character varying(100),
    visible character varying(1) DEFAULT 'Y'::character varying,
    linkid integer DEFAULT 0 NOT NULL,
    displayorder integer DEFAULT 0 NOT NULL,
    helptext character varying(100),
    CONSTRAINT pages_visible CHECK ((((visible)::text = ('N'::character varying)::text) OR ((visible)::text = ('Y'::character varying)::text)))
);


--
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pickuplines; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pickuplines (
    id integer DEFAULT nextval('PickupLines_id_seq'::text) NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    pickupid integer DEFAULT 0 NOT NULL,
    materialid integer DEFAULT 0 NOT NULL,
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
-- Name: pickuplines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pickuplines_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pickups; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pickups (
    id integer DEFAULT nextval('Pickups_id_seq'::text) NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    vendorid integer DEFAULT 0 NOT NULL,
    pickupdate date NOT NULL,
    receiptnumber character varying(20),
    settlementnumber character varying(20)
);


--
-- Name: pickups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE pickups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: pointingdevice; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE pointingdevice (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    connector character varying(10),
    pointertype character varying(10)
);


--
-- Name: powersupply; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE powersupply (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    watts integer DEFAULT 0 NOT NULL,
    connection character varying(10)
);


--
-- Name: printer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE printer (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    speedppm integer DEFAULT 0 NOT NULL,
    printertype character varying(10),
    interface character varying(10) DEFAULT 'Parallel'::character varying
);


--
-- Name: processor; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE processor (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    chipclass character varying(15),
    interface character varying(10),
    speed integer DEFAULT 0 NOT NULL
);


--
-- Name: questions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE questions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: relations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE relations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: sales; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE sales (
    id integer DEFAULT nextval('Sales_id_seq'::text) NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
    zip character varying(10),
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    subtotal numeric(8,2) DEFAULT 0.00 NOT NULL,
    discount numeric(8,2) DEFAULT 0.00 NOT NULL,
    total numeric(8,2) DEFAULT 0.00 NOT NULL,
    bulk boolean
);


--
-- Name: sales_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: salesline; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE salesline (
    id integer DEFAULT nextval('SalesLine_id_seq'::text) NOT NULL,
    salesid integer DEFAULT 0 NOT NULL,
    gizmoid integer DEFAULT 0 NOT NULL,
    description text,
    cashvalue numeric(8,2) DEFAULT 0.00 NOT NULL,
    subtotal numeric(8,2) DEFAULT 0.00 NOT NULL,
    discount numeric(8,2) DEFAULT 0.00 NOT NULL,
    total numeric(8,2) DEFAULT 0.00 NOT NULL
);


--
-- Name: salesline_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE salesline_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: scanner; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE scanner (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    interface character varying(10)
);


--
-- Name: scratchpad; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE scratchpad (
    id integer DEFAULT nextval('ScratchPad_id_seq'::text) NOT NULL,
    pageid integer DEFAULT 0 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    contactid integer DEFAULT 0 NOT NULL,
    name character varying(25),
    note text,
    urgent character varying(1) DEFAULT 'N'::character varying,
    visible character varying(1) DEFAULT 'Y'::character varying,
    CONSTRAINT scratchpad_urgent CHECK ((((urgent)::text = ('N'::character varying)::text) OR ((urgent)::text = ('Y'::character varying)::text))),
    CONSTRAINT scratchpad_visible CHECK ((((visible)::text = ('N'::character varying)::text) OR ((visible)::text = ('Y'::character varying)::text)))
);


--
-- Name: scratchpad_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE scratchpad_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: scsicard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE scsicard (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    internalinterface character varying(15),
    externalinterface character varying(15),
    parms text
);


--
-- Name: scsiharddrive; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE scsiharddrive (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    sizemb integer DEFAULT 0 NOT NULL,
    scsiversion character varying(10)
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: shifts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: soundcard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE soundcard (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    soundtype character varying(15)
);


--
-- Name: speaker; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE speaker (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    powered character varying(1) DEFAULT 'N'::character varying NOT NULL,
    subwoofer character varying(1) DEFAULT 'N'::character varying NOT NULL,
    CONSTRAINT speaker_powered CHECK ((((powered)::text = ('N'::character varying)::text) OR ((powered)::text = ('Y'::character varying)::text))),
    CONSTRAINT speaker_subwoofer CHECK ((((subwoofer)::text = ('N'::character varying)::text) OR ((subwoofer)::text = ('Y'::character varying)::text)))
);


--
-- Name: standardshifts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE standardshifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: stereo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stereo (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100)
);


--
-- Name: system; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE system (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    systemconfiguration text,
    systemboard text,
    adapterinformation text,
    multiprocessorinformation text,
    displaydetails text,
    displayinformation text,
    scsiinformation text,
    pcmciainformation text,
    modeminformation text,
    multimediainformation text,
    plugnplayinformation text,
    physicaldrives text,
    ram integer,
    videoram integer,
    sizemb integer,
    scsi character varying(1) DEFAULT 'N'::character varying,
    chipclass character varying(15),
    speed integer DEFAULT 0 NOT NULL,
    CONSTRAINT system_scsi CHECK ((((scsi)::text = ('N'::character varying)::text) OR ((scsi)::text = ('Y'::character varying)::text)))
);


--
-- Name: systemboard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE systemboard (
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
    CONSTRAINT systemboard_agpslot CHECK ((((agpslot)::text = ('N'::character varying)::text) OR ((agpslot)::text = ('Y'::character varying)::text)))
);


--
-- Name: systemcase; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE systemcase (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    casetype character varying(10)
);


--
-- Name: tapedrive; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tapedrive (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    interface character varying(15)
);


--
-- Name: unit2material; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE unit2material (
    id integer DEFAULT nextval('Unit2Material_id_seq'::text) NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    materialid integer DEFAULT 0 NOT NULL,
    unittype character varying(20)
);


--
-- Name: unit2material_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE unit2material_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: ups; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE ups (
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
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    id integer DEFAULT nextval('Users_id_seq'::text) NOT NULL,
    username character varying(50) NOT NULL,
    "password" character varying(50),
    usergroup character varying(50)
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: vcr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vcr (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100)
);


--
-- Name: videocard; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE videocard (
    id integer DEFAULT 0 NOT NULL,
    classtree character varying(100),
    videomemory character varying(10),
    resolutions text
);


--
-- Name: weeklyshifts; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE weeklyshifts (
    id integer DEFAULT nextval('WeeklyShifts_id_seq'::text) NOT NULL,
    schedulename character varying(15) DEFAULT 'Main'::character varying NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
    jobid integer DEFAULT 0 NOT NULL,
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
-- Name: weeklyshifts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE weeklyshifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: workers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
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
-- Name: workersqualifyforjobs; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE workersqualifyforjobs (
    id integer DEFAULT nextval('WorkersQualifyForJobs_id_seq'::text) NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
    jobid integer DEFAULT 0 NOT NULL,
    injobdescription character varying(1) DEFAULT 'N'::character varying,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT workersqualifyf_injobdescriptio CHECK ((((injobdescription)::text = ('N'::character varying)::text) OR ((injobdescription)::text = ('Y'::character varying)::text)))
);


--
-- Name: workersqualifyforjobs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE workersqualifyforjobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: workmonths; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE workmonths (
    id integer DEFAULT nextval('WorkMonths_id_seq'::text) NOT NULL,
    contactid integer DEFAULT 0 NOT NULL,
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
-- Name: workmonths_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE workmonths_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: allowedstatuses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY allowedstatuses
    ADD CONSTRAINT allowedstatuses_pkey PRIMARY KEY (id);


--
-- Name: borrow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY borrow
    ADD CONSTRAINT borrow_pkey PRIMARY KEY (id);


--
-- Name: card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY card
    ADD CONSTRAINT card_pkey PRIMARY KEY (id);


--
-- Name: cddrive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cddrive
    ADD CONSTRAINT cddrive_pkey PRIMARY KEY (id);


--
-- Name: cellphone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cellphone
    ADD CONSTRAINT cellphone_pkey PRIMARY KEY (id);


--
-- Name: classtree_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY classtree
    ADD CONSTRAINT classtree_pkey PRIMARY KEY (id);


--
-- Name: codedinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY codedinfo
    ADD CONSTRAINT codedinfo_pkey PRIMARY KEY (id);


--
-- Name: component_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY component
    ADD CONSTRAINT component_pkey PRIMARY KEY (id);


--
-- Name: contact_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contact
    ADD CONSTRAINT contact_pkey PRIMARY KEY (id);


--
-- Name: contactlist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY contactlist
    ADD CONSTRAINT contactlist_pkey PRIMARY KEY (id);


--
-- Name: controllercard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY controllercard
    ADD CONSTRAINT controllercard_pkey PRIMARY KEY (id);


--
-- Name: daysoff_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY daysoff
    ADD CONSTRAINT daysoff_pkey PRIMARY KEY (id);


--
-- Name: defaultvalues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY defaultvalues
    ADD CONSTRAINT defaultvalues_pkey PRIMARY KEY (id);


--
-- Name: donation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY donation
    ADD CONSTRAINT donation_pkey PRIMARY KEY (id);


--
-- Name: donationline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY donationline
    ADD CONSTRAINT donationline_pkey PRIMARY KEY (id);


--
-- Name: drive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY drive
    ADD CONSTRAINT drive_pkey PRIMARY KEY (id);


--
-- Name: fieldmap_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY fieldmap
    ADD CONSTRAINT fieldmap_pkey PRIMARY KEY (id);


--
-- Name: floppydrive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY floppydrive
    ADD CONSTRAINT floppydrive_pkey PRIMARY KEY (id);


--
-- Name: gizmo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gizmo
    ADD CONSTRAINT gizmo_pkey PRIMARY KEY (id);


--
-- Name: gizmoclones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gizmoclones
    ADD CONSTRAINT gizmoclones_pkey PRIMARY KEY (id);


--
-- Name: gizmostatuschanges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY gizmostatuschanges
    ADD CONSTRAINT gizmostatuschanges_pkey PRIMARY KEY (change_id);


--
-- Name: holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY holidays
    ADD CONSTRAINT holidays_pkey PRIMARY KEY (id);


--
-- Name: ideharddrive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ideharddrive
    ADD CONSTRAINT ideharddrive_pkey PRIMARY KEY (id);


--
-- Name: income_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY income
    ADD CONSTRAINT income_pkey PRIMARY KEY (id);


--
-- Name: issuenotes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY issuenotes
    ADD CONSTRAINT issuenotes_pkey PRIMARY KEY (id);


--
-- Name: issues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY jobs
    ADD CONSTRAINT jobs_pkey PRIMARY KEY (id);


--
-- Name: keyboard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY keyboard
    ADD CONSTRAINT keyboard_pkey PRIMARY KEY (id);


--
-- Name: laptop_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY laptop
    ADD CONSTRAINT laptop_pkey PRIMARY KEY (id);


--
-- Name: links_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY links
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY materials
    ADD CONSTRAINT materials_pkey PRIMARY KEY (id);


--
-- Name: member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY member
    ADD CONSTRAINT member_pkey PRIMARY KEY (id);


--
-- Name: memberhour_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY memberhour
    ADD CONSTRAINT memberhour_pkey PRIMARY KEY (id);


--
-- Name: misccard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY misccard
    ADD CONSTRAINT misccard_pkey PRIMARY KEY (id);


--
-- Name: misccomponent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY misccomponent
    ADD CONSTRAINT misccomponent_pkey PRIMARY KEY (id);


--
-- Name: miscdrive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY miscdrive
    ADD CONSTRAINT miscdrive_pkey PRIMARY KEY (id);


--
-- Name: miscgizmo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY miscgizmo
    ADD CONSTRAINT miscgizmo_pkey PRIMARY KEY (id);


--
-- Name: modem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY modem
    ADD CONSTRAINT modem_pkey PRIMARY KEY (id);


--
-- Name: modemcard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY modemcard
    ADD CONSTRAINT modemcard_pkey PRIMARY KEY (id);


--
-- Name: monitor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY monitor
    ADD CONSTRAINT monitor_pkey PRIMARY KEY (id);


--
-- Name: networkcard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY networkcard
    ADD CONSTRAINT networkcard_pkey PRIMARY KEY (id);


--
-- Name: networkingdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY networkingdevice
    ADD CONSTRAINT networkingdevice_pkey PRIMARY KEY (id);


--
-- Name: organization_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY organization
    ADD CONSTRAINT organization_pkey PRIMARY KEY (id);


--
-- Name: pagelinks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pagelinks
    ADD CONSTRAINT pagelinks_pkey PRIMARY KEY (id);


--
-- Name: pages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pages
    ADD CONSTRAINT pages_pkey PRIMARY KEY (id);


--
-- Name: pickuplines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pickuplines
    ADD CONSTRAINT pickuplines_pkey PRIMARY KEY (id);


--
-- Name: pickups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pickups
    ADD CONSTRAINT pickups_pkey PRIMARY KEY (id);


--
-- Name: pointingdevice_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY pointingdevice
    ADD CONSTRAINT pointingdevice_pkey PRIMARY KEY (id);


--
-- Name: powersupply_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY powersupply
    ADD CONSTRAINT powersupply_pkey PRIMARY KEY (id);


--
-- Name: printer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY printer
    ADD CONSTRAINT printer_pkey PRIMARY KEY (id);


--
-- Name: processor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY processor
    ADD CONSTRAINT processor_pkey PRIMARY KEY (id);


--
-- Name: sales_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY sales
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);


--
-- Name: salesline_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY salesline
    ADD CONSTRAINT salesline_pkey PRIMARY KEY (id);


--
-- Name: scanner_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY scanner
    ADD CONSTRAINT scanner_pkey PRIMARY KEY (id);


--
-- Name: scratchpad_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY scratchpad
    ADD CONSTRAINT scratchpad_pkey PRIMARY KEY (id);


--
-- Name: scsicard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY scsicard
    ADD CONSTRAINT scsicard_pkey PRIMARY KEY (id);


--
-- Name: scsiharddrive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY scsiharddrive
    ADD CONSTRAINT scsiharddrive_pkey PRIMARY KEY (id);


--
-- Name: soundcard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY soundcard
    ADD CONSTRAINT soundcard_pkey PRIMARY KEY (id);


--
-- Name: speaker_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY speaker
    ADD CONSTRAINT speaker_pkey PRIMARY KEY (id);


--
-- Name: stereo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stereo
    ADD CONSTRAINT stereo_pkey PRIMARY KEY (id);


--
-- Name: system_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY system
    ADD CONSTRAINT system_pkey PRIMARY KEY (id);


--
-- Name: systemboard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY systemboard
    ADD CONSTRAINT systemboard_pkey PRIMARY KEY (id);


--
-- Name: systemcase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY systemcase
    ADD CONSTRAINT systemcase_pkey PRIMARY KEY (id);


--
-- Name: tapedrive_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tapedrive
    ADD CONSTRAINT tapedrive_pkey PRIMARY KEY (id);


--
-- Name: unit2material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY unit2material
    ADD CONSTRAINT unit2material_pkey PRIMARY KEY (id);


--
-- Name: ups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY ups
    ADD CONSTRAINT ups_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: vcr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vcr
    ADD CONSTRAINT vcr_pkey PRIMARY KEY (id);


--
-- Name: videocard_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY videocard
    ADD CONSTRAINT videocard_pkey PRIMARY KEY (id);


--
-- Name: weeklyshifts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY weeklyshifts
    ADD CONSTRAINT weeklyshifts_pkey PRIMARY KEY (id);


--
-- Name: workers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY workers
    ADD CONSTRAINT workers_pkey PRIMARY KEY (id);


--
-- Name: workersqualifyforjobs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY workersqualifyforjobs
    ADD CONSTRAINT workersqualifyforjobs_pkey PRIMARY KEY (id);


--
-- Name: workmonths_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY workmonths
    ADD CONSTRAINT workmonths_pkey PRIMARY KEY (id);


--
-- Name: contact_sortname; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX contact_sortname ON contact USING btree (sortname);


--
-- Name: mailingpieces_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX mailingpieces_id_key ON mailingpieces USING btree (id);


--
-- Name: mailings_id_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX mailings_id_key ON mailings USING btree (id);


--
-- Name: users_username_key; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX users_username_key ON users USING btree (username);


--
-- Name: RI_ConstraintTrigger_36659; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER component_gizmo_fk
    AFTER INSERT OR UPDATE ON component
    FROM gizmo
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('component_gizmo_fk', 'component', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36660; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER component_gizmo_fk
    AFTER DELETE ON gizmo
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('component_gizmo_fk', 'component', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36661; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER component_gizmo_fk
    AFTER UPDATE ON gizmo
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('component_gizmo_fk', 'component', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36662; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER card_component_fk
    AFTER INSERT OR UPDATE ON card
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('card_component_fk', 'card', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36663; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER card_component_fk
    AFTER DELETE ON component
    FROM card
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('card_component_fk', 'card', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36664; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER card_component_fk
    AFTER UPDATE ON component
    FROM card
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('card_component_fk', 'card', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36665; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER misccard_card_fk
    AFTER INSERT OR UPDATE ON misccard
    FROM card
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('misccard_card_fk', 'misccard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36666; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER misccard_card_fk
    AFTER DELETE ON card
    FROM misccard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('misccard_card_fk', 'misccard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36667; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER misccard_card_fk
    AFTER UPDATE ON card
    FROM misccard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('misccard_card_fk', 'misccard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36668; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER modemcard_card_fk
    AFTER INSERT OR UPDATE ON modemcard
    FROM card
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('modemcard_card_fk', 'modemcard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36669; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER modemcard_card_fk
    AFTER DELETE ON card
    FROM modemcard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('modemcard_card_fk', 'modemcard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36670; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER modemcard_card_fk
    AFTER UPDATE ON card
    FROM modemcard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('modemcard_card_fk', 'modemcard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36671; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER networkcard_card_fk
    AFTER INSERT OR UPDATE ON networkcard
    FROM card
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('networkcard_card_fk', 'networkcard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36672; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER networkcard_card_fk
    AFTER DELETE ON card
    FROM networkcard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('networkcard_card_fk', 'networkcard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36673; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER networkcard_card_fk
    AFTER UPDATE ON card
    FROM networkcard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('networkcard_card_fk', 'networkcard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36674; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER scsicard_card_fk
    AFTER INSERT OR UPDATE ON scsicard
    FROM card
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('scsicard_card_fk', 'scsicard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36675; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER scsicard_card_fk
    AFTER DELETE ON card
    FROM scsicard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('scsicard_card_fk', 'scsicard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36676; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER scsicard_card_fk
    AFTER UPDATE ON card
    FROM scsicard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('scsicard_card_fk', 'scsicard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36677; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER soundcard_card_fk
    AFTER INSERT OR UPDATE ON soundcard
    FROM card
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('soundcard_card_fk', 'soundcard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36678; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER soundcard_card_fk
    AFTER DELETE ON card
    FROM soundcard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('soundcard_card_fk', 'soundcard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36679; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER soundcard_card_fk
    AFTER UPDATE ON card
    FROM soundcard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('soundcard_card_fk', 'soundcard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36680; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER videocard_card_fk
    AFTER INSERT OR UPDATE ON videocard
    FROM card
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('videocard_card_fk', 'videocard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36681; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER videocard_card_fk
    AFTER DELETE ON card
    FROM videocard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('videocard_card_fk', 'videocard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36682; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER videocard_card_fk
    AFTER UPDATE ON card
    FROM videocard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('videocard_card_fk', 'videocard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36683; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER controllercard_card_fk
    AFTER INSERT OR UPDATE ON controllercard
    FROM card
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('controllercard_card_fk', 'controllercard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36684; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER controllercard_card_fk
    AFTER DELETE ON card
    FROM controllercard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('controllercard_card_fk', 'controllercard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36685; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER controllercard_card_fk
    AFTER UPDATE ON card
    FROM controllercard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('controllercard_card_fk', 'controllercard', 'card', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36686; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER drive_gizmo_fk
    AFTER INSERT OR UPDATE ON drive
    FROM gizmo
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('drive_gizmo_fk', 'drive', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36687; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER drive_gizmo_fk
    AFTER DELETE ON gizmo
    FROM drive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('drive_gizmo_fk', 'drive', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36688; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER drive_gizmo_fk
    AFTER UPDATE ON gizmo
    FROM drive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('drive_gizmo_fk', 'drive', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36689; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER floppydrive_drive_fk
    AFTER INSERT OR UPDATE ON floppydrive
    FROM drive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('floppydrive_drive_fk', 'floppydrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36690; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER floppydrive_drive_fk
    AFTER DELETE ON drive
    FROM floppydrive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('floppydrive_drive_fk', 'floppydrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36691; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER floppydrive_drive_fk
    AFTER UPDATE ON drive
    FROM floppydrive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('floppydrive_drive_fk', 'floppydrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36692; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER ideharddrive_drive_fk
    AFTER INSERT OR UPDATE ON ideharddrive
    FROM drive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('ideharddrive_drive_fk', 'ideharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36693; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER ideharddrive_drive_fk
    AFTER DELETE ON drive
    FROM ideharddrive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('ideharddrive_drive_fk', 'ideharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36694; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER ideharddrive_drive_fk
    AFTER UPDATE ON drive
    FROM ideharddrive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('ideharddrive_drive_fk', 'ideharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36695; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER miscdrive_drive_fk
    AFTER INSERT OR UPDATE ON miscdrive
    FROM drive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('miscdrive_drive_fk', 'miscdrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36696; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER miscdrive_drive_fk
    AFTER DELETE ON drive
    FROM miscdrive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('miscdrive_drive_fk', 'miscdrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36697; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER miscdrive_drive_fk
    AFTER UPDATE ON drive
    FROM miscdrive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('miscdrive_drive_fk', 'miscdrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36698; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER scsiharddrive_drive_fk
    AFTER INSERT OR UPDATE ON scsiharddrive
    FROM drive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('scsiharddrive_drive_fk', 'scsiharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36699; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER scsiharddrive_drive_fk
    AFTER DELETE ON drive
    FROM scsiharddrive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('scsiharddrive_drive_fk', 'scsiharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36700; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER scsiharddrive_drive_fk
    AFTER UPDATE ON drive
    FROM scsiharddrive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('scsiharddrive_drive_fk', 'scsiharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36701; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER tapedrive_drive_fk
    AFTER INSERT OR UPDATE ON tapedrive
    FROM drive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('tapedrive_drive_fk', 'tapedrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36702; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER tapedrive_drive_fk
    AFTER DELETE ON drive
    FROM tapedrive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('tapedrive_drive_fk', 'tapedrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36703; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER tapedrive_drive_fk
    AFTER UPDATE ON drive
    FROM tapedrive
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('tapedrive_drive_fk', 'tapedrive', 'drive', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36704; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER keyboard_component_fk
    AFTER INSERT OR UPDATE ON keyboard
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('keyboard_component_fk', 'keyboard', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36705; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER keyboard_component_fk
    AFTER DELETE ON component
    FROM keyboard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('keyboard_component_fk', 'keyboard', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36706; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER keyboard_component_fk
    AFTER UPDATE ON component
    FROM keyboard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('keyboard_component_fk', 'keyboard', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36707; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER misccompponent_component_fk
    AFTER INSERT OR UPDATE ON misccomponent
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('misccompponent_component_fk', 'misccomponent', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36708; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER misccompponent_component_fk
    AFTER DELETE ON component
    FROM misccomponent
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('misccompponent_component_fk', 'misccomponent', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36709; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER misccompponent_component_fk
    AFTER UPDATE ON component
    FROM misccomponent
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('misccompponent_component_fk', 'misccomponent', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36710; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER modem_component_fk
    AFTER INSERT OR UPDATE ON modem
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('modem_component_fk', 'modem', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36711; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER modem_component_fk
    AFTER DELETE ON component
    FROM modem
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('modem_component_fk', 'modem', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36712; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER modem_component_fk
    AFTER UPDATE ON component
    FROM modem
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('modem_component_fk', 'modem', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36713; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER monitor_component_fk
    AFTER INSERT OR UPDATE ON monitor
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('monitor_component_fk', 'monitor', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36714; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER monitor_component_fk
    AFTER DELETE ON component
    FROM monitor
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('monitor_component_fk', 'monitor', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36715; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER monitor_component_fk
    AFTER UPDATE ON component
    FROM monitor
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('monitor_component_fk', 'monitor', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36716; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER pointingdevice_component_fk
    AFTER INSERT OR UPDATE ON pointingdevice
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('pointingdevice_component_fk', 'pointingdevice', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36717; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER pointingdevice_component_fk
    AFTER DELETE ON component
    FROM pointingdevice
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('pointingdevice_component_fk', 'pointingdevice', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36718; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER pointingdevice_component_fk
    AFTER UPDATE ON component
    FROM pointingdevice
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('pointingdevice_component_fk', 'pointingdevice', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36719; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER powersupply_component_fk
    AFTER INSERT OR UPDATE ON powersupply
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('powersupply_component_fk', 'powersupply', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36720; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER powersupply_component_fk
    AFTER DELETE ON component
    FROM powersupply
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('powersupply_component_fk', 'powersupply', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36721; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER powersupply_component_fk
    AFTER UPDATE ON component
    FROM powersupply
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('powersupply_component_fk', 'powersupply', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36722; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER printer_component_fk
    AFTER INSERT OR UPDATE ON printer
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('printer_component_fk', 'printer', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36723; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER printer_component_fk
    AFTER DELETE ON component
    FROM printer
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('printer_component_fk', 'printer', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36724; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER printer_component_fk
    AFTER UPDATE ON component
    FROM printer
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('printer_component_fk', 'printer', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36725; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER processor_component_fk
    AFTER INSERT OR UPDATE ON processor
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('processor_component_fk', 'processor', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36726; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER processor_component_fk
    AFTER DELETE ON component
    FROM processor
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('processor_component_fk', 'processor', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36727; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER processor_component_fk
    AFTER UPDATE ON component
    FROM processor
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('processor_component_fk', 'processor', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36728; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER scanner_component_fk
    AFTER INSERT OR UPDATE ON scanner
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('scanner_component_fk', 'scanner', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36729; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER scanner_component_fk
    AFTER DELETE ON component
    FROM scanner
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('scanner_component_fk', 'scanner', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36730; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER scanner_component_fk
    AFTER UPDATE ON component
    FROM scanner
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('scanner_component_fk', 'scanner', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36731; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER speaker_component_fk
    AFTER INSERT OR UPDATE ON speaker
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('speaker_component_fk', 'speaker', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36732; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER speaker_component_fk
    AFTER DELETE ON component
    FROM speaker
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('speaker_component_fk', 'speaker', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36733; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER speaker_component_fk
    AFTER UPDATE ON component
    FROM speaker
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('speaker_component_fk', 'speaker', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36734; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER systemboard_component_fk
    AFTER INSERT OR UPDATE ON systemboard
    FROM component
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('systemboard_component_fk', 'systemboard', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36735; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER systemboard_component_fk
    AFTER DELETE ON component
    FROM systemboard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('systemboard_component_fk', 'systemboard', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36736; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER systemboard_component_fk
    AFTER UPDATE ON component
    FROM systemboard
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('systemboard_component_fk', 'systemboard', 'component', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36737; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER miscgizmo_gizmo_fk
    AFTER INSERT OR UPDATE ON miscgizmo
    FROM gizmo
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('miscgizmo_gizmo_fk', 'miscgizmo', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36738; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER miscgizmo_gizmo_fk
    AFTER DELETE ON gizmo
    FROM miscgizmo
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('miscgizmo_gizmo_fk', 'miscgizmo', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36739; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER miscgizmo_gizmo_fk
    AFTER UPDATE ON gizmo
    FROM miscgizmo
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('miscgizmo_gizmo_fk', 'miscgizmo', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36740; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER system_gizmo_fk
    AFTER INSERT OR UPDATE ON system
    FROM gizmo
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('system_gizmo_fk', 'system', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36741; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER system_gizmo_fk
    AFTER DELETE ON gizmo
    FROM system
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('system_gizmo_fk', 'system', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36742; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER system_gizmo_fk
    AFTER UPDATE ON gizmo
    FROM system
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('system_gizmo_fk', 'system', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36743; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER systemcase_gizmo_fk
    AFTER INSERT OR UPDATE ON systemcase
    FROM gizmo
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('systemcase_gizmo_fk', 'systemcase', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36744; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER systemcase_gizmo_fk
    AFTER DELETE ON gizmo
    FROM systemcase
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('systemcase_gizmo_fk', 'systemcase', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_36745; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER systemcase_gizmo_fk
    AFTER UPDATE ON gizmo
    FROM systemcase
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('systemcase_gizmo_fk', 'systemcase', 'gizmo', 'UNSPECIFIED', 'id', 'id');


--
-- Name: borrow_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER borrow_created_trigger
    BEFORE INSERT ON borrow
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: borrow_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER borrow_modified_trigger
    BEFORE UPDATE ON borrow
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: codedinfo_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER codedinfo_created_trigger
    BEFORE INSERT ON codedinfo
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: codedinfo_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER codedinfo_modified_trigger
    BEFORE UPDATE ON codedinfo
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: contact_addr_change_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER contact_addr_change_trigger
    BEFORE UPDATE ON contact
    FOR EACH ROW
    EXECUTE PROCEDURE contact_addr_trigger();


--
-- Name: contact_addr_insert_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER contact_addr_insert_trigger
    BEFORE INSERT ON contact
    FOR EACH ROW
    EXECUTE PROCEDURE contact_addr_trigger2();


--
-- Name: contact_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER contact_created_trigger
    BEFORE INSERT ON contact
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: contact_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER contact_modified_trigger
    BEFORE UPDATE ON contact
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: contactlist_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER contactlist_created_trigger
    BEFORE INSERT ON contactlist
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: contactlist_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER contactlist_modified_trigger
    BEFORE UPDATE ON contactlist
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: daysoff_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER daysoff_created_trigger
    BEFORE INSERT ON daysoff
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: daysoff_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER daysoff_modified_trigger
    BEFORE UPDATE ON daysoff
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: donation_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER donation_created_trigger
    BEFORE INSERT ON donation
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: donation_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER donation_modified_trigger
    BEFORE UPDATE ON donation
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: gizmo_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER gizmo_created_trigger
    BEFORE INSERT ON gizmo
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: gizmo_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER gizmo_modified_trigger
    BEFORE UPDATE ON gizmo
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: gizmo_status_change_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER gizmo_status_change_trigger
    BEFORE UPDATE ON gizmo
    FOR EACH ROW
    EXECUTE PROCEDURE gizmo_status_changed();


--
-- Name: gizmo_status_insert_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER gizmo_status_insert_trigger
    BEFORE INSERT ON gizmo
    FOR EACH ROW
    EXECUTE PROCEDURE gizmo_status_insert();


--
-- Name: gizmoclones_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER gizmoclones_created_trigger
    BEFORE INSERT ON gizmoclones
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: gizmoclones_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER gizmoclones_modified_trigger
    BEFORE UPDATE ON gizmoclones
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: holidays_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER holidays_created_trigger
    BEFORE INSERT ON holidays
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: holidays_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER holidays_modified_trigger
    BEFORE UPDATE ON holidays
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: income_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER income_created_trigger
    BEFORE INSERT ON income
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: income_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER income_modified_trigger
    BEFORE UPDATE ON income
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: issuenotes_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER issuenotes_created_trigger
    BEFORE INSERT ON issuenotes
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: issuenotes_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER issuenotes_modified_trigger
    BEFORE UPDATE ON issuenotes
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: issues_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER issues_created_trigger
    BEFORE INSERT ON issues
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: issues_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER issues_modified_trigger
    BEFORE UPDATE ON issues
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: jobs_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER jobs_created_trigger
    BEFORE INSERT ON jobs
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: jobs_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER jobs_modified_trigger
    BEFORE UPDATE ON jobs
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: materials_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER materials_created_trigger
    BEFORE INSERT ON materials
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: materials_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER materials_modified_trigger
    BEFORE UPDATE ON materials
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: member_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER member_created_trigger
    BEFORE INSERT ON member
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: member_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER member_modified_trigger
    BEFORE UPDATE ON member
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: memberhour_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER memberhour_created_trigger
    BEFORE INSERT ON memberhour
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: memberhour_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER memberhour_modified_trigger
    BEFORE UPDATE ON memberhour
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: organization_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER organization_created_trigger
    BEFORE INSERT ON organization
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: organization_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER organization_modified_trigger
    BEFORE UPDATE ON organization
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: pages_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER pages_created_trigger
    BEFORE INSERT ON pages
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: pages_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER pages_modified_trigger
    BEFORE UPDATE ON pages
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: pickuplines_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER pickuplines_created_trigger
    BEFORE INSERT ON pickuplines
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: pickuplines_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER pickuplines_modified_trigger
    BEFORE UPDATE ON pickuplines
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: pickups_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER pickups_created_trigger
    BEFORE INSERT ON pickups
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: pickups_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER pickups_modified_trigger
    BEFORE UPDATE ON pickups
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: sales_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER sales_created_trigger
    BEFORE INSERT ON sales
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: sales_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER sales_modified_trigger
    BEFORE UPDATE ON sales
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: scratchpad_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER scratchpad_created_trigger
    BEFORE INSERT ON scratchpad
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: scratchpad_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER scratchpad_modified_trigger
    BEFORE UPDATE ON scratchpad
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: unit2material_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER unit2material_created_trigger
    BEFORE INSERT ON unit2material
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: unit2material_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER unit2material_modified_trigger
    BEFORE UPDATE ON unit2material
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: weeklyshifts_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER weeklyshifts_created_trigger
    BEFORE INSERT ON weeklyshifts
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: weeklyshifts_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER weeklyshifts_modified_trigger
    BEFORE UPDATE ON weeklyshifts
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: workers_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER workers_created_trigger
    BEFORE INSERT ON workers
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: workers_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER workers_modified_trigger
    BEFORE UPDATE ON workers
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: workersqualifyforjobs_created_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER workersqualifyforjobs_created_t
    BEFORE INSERT ON workersqualifyforjobs
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: workersqualifyforjobs_modified_; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER workersqualifyforjobs_modified_
    BEFORE UPDATE ON workersqualifyforjobs
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: workmonths_created_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER workmonths_created_trigger
    BEFORE INSERT ON workmonths
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: workmonths_modified_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER workmonths_modified_trigger
    BEFORE UPDATE ON workmonths
    FOR EACH ROW
    EXECUTE PROCEDURE modified_trigger();


--
-- Name: card_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY card
    ADD CONSTRAINT card_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: cddrive_drive_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cddrive
    ADD CONSTRAINT cddrive_drive_fk FOREIGN KEY (id) REFERENCES drive(id);


--
-- Name: component_gizmo_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY component
    ADD CONSTRAINT component_gizmo_fk FOREIGN KEY (id) REFERENCES gizmo(id);


--
-- Name: controllercard_card_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY controllercard
    ADD CONSTRAINT controllercard_card_fk FOREIGN KEY (id) REFERENCES card(id);


--
-- Name: drive_gizmo_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY drive
    ADD CONSTRAINT drive_gizmo_fk FOREIGN KEY (id) REFERENCES gizmo(id);


--
-- Name: floppydrive_drive_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY floppydrive
    ADD CONSTRAINT floppydrive_drive_fk FOREIGN KEY (id) REFERENCES drive(id);


--
-- Name: ideharddrive_drive_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ideharddrive
    ADD CONSTRAINT ideharddrive_drive_fk FOREIGN KEY (id) REFERENCES drive(id);


--
-- Name: keyboard_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY keyboard
    ADD CONSTRAINT keyboard_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: misccard_card_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY misccard
    ADD CONSTRAINT misccard_card_fk FOREIGN KEY (id) REFERENCES card(id);


--
-- Name: misccompponent_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY misccomponent
    ADD CONSTRAINT misccompponent_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: miscdrive_drive_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY miscdrive
    ADD CONSTRAINT miscdrive_drive_fk FOREIGN KEY (id) REFERENCES drive(id);


--
-- Name: miscgizmo_gizmo_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY miscgizmo
    ADD CONSTRAINT miscgizmo_gizmo_fk FOREIGN KEY (id) REFERENCES gizmo(id);


--
-- Name: modem_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY modem
    ADD CONSTRAINT modem_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: modemcard_card_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY modemcard
    ADD CONSTRAINT modemcard_card_fk FOREIGN KEY (id) REFERENCES card(id);


--
-- Name: monitor_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY monitor
    ADD CONSTRAINT monitor_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: networkcard_card_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY networkcard
    ADD CONSTRAINT networkcard_card_fk FOREIGN KEY (id) REFERENCES card(id);


--
-- Name: pointingdevice_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY pointingdevice
    ADD CONSTRAINT pointingdevice_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: powersupply_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY powersupply
    ADD CONSTRAINT powersupply_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: printer_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY printer
    ADD CONSTRAINT printer_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: processor_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY processor
    ADD CONSTRAINT processor_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: scanner_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY scanner
    ADD CONSTRAINT scanner_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: scsicard_card_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY scsicard
    ADD CONSTRAINT scsicard_card_fk FOREIGN KEY (id) REFERENCES card(id);


--
-- Name: scsiharddrive_drive_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY scsiharddrive
    ADD CONSTRAINT scsiharddrive_drive_fk FOREIGN KEY (id) REFERENCES drive(id);


--
-- Name: soundcard_card_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY soundcard
    ADD CONSTRAINT soundcard_card_fk FOREIGN KEY (id) REFERENCES card(id);


--
-- Name: speaker_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY speaker
    ADD CONSTRAINT speaker_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: system_gizmo_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY system
    ADD CONSTRAINT system_gizmo_fk FOREIGN KEY (id) REFERENCES gizmo(id);


--
-- Name: systemboard_component_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY systemboard
    ADD CONSTRAINT systemboard_component_fk FOREIGN KEY (id) REFERENCES component(id);


--
-- Name: systemcase_gizmo_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY systemcase
    ADD CONSTRAINT systemcase_gizmo_fk FOREIGN KEY (id) REFERENCES gizmo(id);


--
-- Name: tapedrive_drive_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tapedrive
    ADD CONSTRAINT tapedrive_drive_fk FOREIGN KEY (id) REFERENCES drive(id);


--
-- Name: videocard_card_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY videocard
    ADD CONSTRAINT videocard_card_fk FOREIGN KEY (id) REFERENCES card(id);


--
-- PostgreSQL database dump complete
--

