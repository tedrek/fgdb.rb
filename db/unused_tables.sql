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
-- Name: standardshifts_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE standardshifts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


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
-- Name: borrow_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY borrow
    ADD CONSTRAINT borrow_pkey PRIMARY KEY (id);


--
-- Name: codedinfo_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY codedinfo
    ADD CONSTRAINT codedinfo_pkey PRIMARY KEY (id);


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
-- Name: daysoff_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY daysoff
    ADD CONSTRAINT daysoff_pkey PRIMARY KEY (id);


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
-- Name: fieldmap_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY fieldmap
    ADD CONSTRAINT fieldmap_pkey PRIMARY KEY (id);


--
-- Name: holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY holidays
    ADD CONSTRAINT holidays_pkey PRIMARY KEY (id);


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
-- Name: scratchpad_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY scratchpad
    ADD CONSTRAINT scratchpad_pkey PRIMARY KEY (id);


--
-- Name: unit2material_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY unit2material
    ADD CONSTRAINT unit2material_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


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


