--
-- Selected TOC Entries:
--
\connect - postgres

--
-- TOC Entry ID 201 (OID 2556460)
--
-- Name: "plpgsql_call_handler" () Type: FUNCTION Owner: postgres
--

CREATE FUNCTION "plpgsql_call_handler" () RETURNS opaque AS '$libdir/plpgsql', 'plpgsql_call_handler' LANGUAGE 'C';

--
-- TOC Entry ID 202 (OID 2556461)
--
-- Name: plpgsql Type: PROCEDURAL LANGUAGE Owner: 
--

CREATE TRUSTED PROCEDURAL LANGUAGE 'plpgsql' HANDLER "plpgsql_call_handler" LANCOMPILER '';

\connect - fgdb

--
-- TOC Entry ID 203 (OID 2556462)
--
-- Name: "created_trigger" () Type: FUNCTION Owner: fgdb
--

CREATE FUNCTION "created_trigger" () RETURNS opaque AS '
BEGIN
    NEW.created := ''now'';
    NEW.modified := ''now'';
    RETURN NEW;
END;
' LANGUAGE 'plpgsql';

--
-- TOC Entry ID 204 (OID 2556463)
--
-- Name: "modified_trigger" () Type: FUNCTION Owner: fgdb
--

CREATE FUNCTION "modified_trigger" () RETURNS opaque AS '
BEGIN
    NEW.modified := ''now'';
    RETURN NEW;
END;
' LANGUAGE 'plpgsql';

--
-- TOC Entry ID 2 (OID 2556464)
--
-- Name: borrow_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "borrow_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 3 (OID 2556466)
--
-- Name: contact_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "contact_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 4 (OID 2556468)
--
-- Name: contactlist_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "contactlist_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 5 (OID 2556470)
--
-- Name: daysoff_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "daysoff_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 6 (OID 2556472)
--
-- Name: donation_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "donation_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 7 (OID 2556474)
--
-- Name: donationline_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "donationline_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 8 (OID 2556476)
--
-- Name: gizmo_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "gizmo_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 9 (OID 2556476)
--
-- Name: gizmo_id_seq Type: ACL Owner: 
--

REVOKE ALL on "gizmo_id_seq" from PUBLIC;
GRANT ALL on "gizmo_id_seq" to "fgdb";
GRANT ALL on "gizmo_id_seq" to "fgdiag";

--
-- TOC Entry ID 10 (OID 2556478)
--
-- Name: gizmoclones_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "gizmoclones_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 11 (OID 2556480)
--
-- Name: gizmostatuschanges_change_id_se Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "gizmostatuschanges_change_id_se" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 12 (OID 2556480)
--
-- Name: gizmostatuschanges_change_id_se Type: ACL Owner: 
--

REVOKE ALL on "gizmostatuschanges_change_id_se" from PUBLIC;
GRANT ALL on "gizmostatuschanges_change_id_se" to "fgdb";
GRANT ALL on "gizmostatuschanges_change_id_se" to "fgdiag";

--
-- TOC Entry ID 13 (OID 2556482)
--
-- Name: holidays_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "holidays_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 14 (OID 2556484)
--
-- Name: income_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "income_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 15 (OID 2556486)
--
-- Name: jobs_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "jobs_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 16 (OID 2556488)
--
-- Name: links_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "links_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 17 (OID 2556490)
--
-- Name: materials_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "materials_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 18 (OID 2556492)
--
-- Name: memberhour_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "memberhour_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 19 (OID 2556494)
--
-- Name: pagelinks_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "pagelinks_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 20 (OID 2556496)
--
-- Name: pages_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "pages_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 21 (OID 2556498)
--
-- Name: pickuplines_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "pickuplines_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 22 (OID 2556500)
--
-- Name: pickups_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "pickups_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 23 (OID 2556502)
--
-- Name: sales_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "sales_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 24 (OID 2556504)
--
-- Name: salesline_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "salesline_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 25 (OID 2556506)
--
-- Name: scratchpad_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "scratchpad_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 26 (OID 2556508)
--
-- Name: shifts_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "shifts_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 27 (OID 2556510)
--
-- Name: standardshifts_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "standardshifts_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 28 (OID 2556512)
--
-- Name: unit2material_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "unit2material_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 29 (OID 2556514)
--
-- Name: users_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "users_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 30 (OID 2556516)
--
-- Name: workmonths_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "workmonths_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 31 (OID 2556518)
--
-- Name: workersqualifyforjobs_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "workersqualifyforjobs_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 32 (OID 2556522)
--
-- Name: anondict_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "anondict_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 33 (OID 2556524)
--
-- Name: answers_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "answers_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 34 (OID 2556526)
--
-- Name: classtree_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "classtree_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 35 (OID 2556528)
--
-- Name: codedinfo_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "codedinfo_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 36 (OID 2556530)
--
-- Name: defaultvalues_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "defaultvalues_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 37 (OID 2556532)
--
-- Name: fieldmap_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "fieldmap_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 38 (OID 2556534)
--
-- Name: helpscreen_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "helpscreen_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 39 (OID 2556536)
--
-- Name: options_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "options_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 40 (OID 2556538)
--
-- Name: questions_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "questions_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 41 (OID 2556540)
--
-- Name: relations_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "relations_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 42 (OID 2556542)
--
-- Name: sessions_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "sessions_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 45 (OID 2556544)
--
-- Name: borrow Type: TABLE Owner: fgdb
--

CREATE TABLE "borrow" (
	"id" integer DEFAULT nextval('Borrow_id_seq'::text) NOT NULL,
	"contactid" integer DEFAULT '0' NOT NULL,
	"gizmoid" integer DEFAULT '0' NOT NULL,
	"borrowdate" date NOT NULL,
	"returndate" date NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "borrow_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 46 (OID 2556544)
--
-- Name: borrow Type: ACL Owner: 
--

REVOKE ALL on "borrow" from PUBLIC;
GRANT ALL on "borrow" to "fgdb";
GRANT ALL on "borrow" to "fgdiag";

--
-- TOC Entry ID 47 (OID 2556547)
--
-- Name: cddrive Type: TABLE Owner: fgdb
--

CREATE TABLE "cddrive" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"interface" character varying(10) DEFAULT '',
	"speed" character varying(10) DEFAULT '',
	"writemode" character varying(15) DEFAULT '',
	"scsi" character varying(1) DEFAULT 'N',
	CONSTRAINT "cddrive_scsi" CHECK (((scsi = 'N'::"varchar") OR (scsi = 'Y'::"varchar"))),
	Constraint "cddrive_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 48 (OID 2556547)
--
-- Name: cddrive Type: ACL Owner: 
--

REVOKE ALL on "cddrive" from PUBLIC;
GRANT ALL on "cddrive" to "fgdb";
GRANT ALL on "cddrive" to "fgdiag";

--
-- TOC Entry ID 49 (OID 2556550)
--
-- Name: card Type: TABLE Owner: fgdb
--

CREATE TABLE "card" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"slottype" character varying(10),
	Constraint "card_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 50 (OID 2556550)
--
-- Name: card Type: ACL Owner: 
--

REVOKE ALL on "card" from PUBLIC;
GRANT ALL on "card" to "fgdb";
GRANT ALL on "card" to "fgdiag";

--
-- TOC Entry ID 51 (OID 2556553)
--
-- Name: component Type: TABLE Owner: fgdb
--

CREATE TABLE "component" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"insysid" integer DEFAULT '0' NOT NULL,
	Constraint "component_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 52 (OID 2556553)
--
-- Name: component Type: ACL Owner: 
--

REVOKE ALL on "component" from PUBLIC;
GRANT ALL on "component" to "fgdb";
GRANT ALL on "component" to "fgdiag";

--
-- TOC Entry ID 53 (OID 2556556)
--
-- Name: contact Type: TABLE Owner: fgdb
--

CREATE TABLE "contact" (
	"id" integer DEFAULT nextval('Contact_id_seq'::text) NOT NULL,
	"waiting" character varying(1) DEFAULT 'N',
	"member" character varying(1) DEFAULT 'N',
	"volunteer" character varying(1) DEFAULT 'N',
	"donor" character varying(1) DEFAULT 'N',
	"buyer" character varying(1) DEFAULT 'N',
	"contacttype" character varying(1) DEFAULT 'P' NOT NULL,
	"firstname" character varying(25),
	"middlename" character varying(25),
	"lastname" character varying(50),
	"organization" character varying(50),
	"address" character varying(50),
	"address2" character varying(50),
	"city" character varying(30) DEFAULT 'Portland' NOT NULL,
	"state" character varying(2) DEFAULT 'OR',
	"zip" character varying(10),
	"phone" character varying(20),
	"fax" character varying(20),
	"email" character varying(50),
	"emailok" character varying(1),
	"mailok" character varying(1),
	"phoneok" character varying(1),
	"faxok" character varying(1),
	"notes" text,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"sortname" character varying(25),
	"preferemail" character varying(1),
	"comp4kids" character varying(1),
	"recycler" character varying(1),
	"grantor" character varying(1),
	"build" character varying(1),
	"adopter" character varying(1),
	CONSTRAINT "contact_buyer" CHECK (((buyer = 'N'::"varchar") OR (buyer = 'Y'::"varchar"))),
	CONSTRAINT "contact_contacttype" CHECK (((contacttype = 'O'::"varchar") OR (contacttype = 'P'::"varchar"))),
	CONSTRAINT "contact_donor" CHECK (((donor = 'N'::"varchar") OR (donor = 'Y'::"varchar"))),
	CONSTRAINT "contact_member" CHECK (((member = 'N'::"varchar") OR (member = 'Y'::"varchar"))),
	CONSTRAINT "contact_volunteer" CHECK (((volunteer = 'N'::"varchar") OR (volunteer = 'Y'::"varchar"))),
	CONSTRAINT "contact_waiting" CHECK (((waiting = 'N'::"varchar") OR (waiting = 'Y'::"varchar"))),
	Constraint "contact_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 54 (OID 2556556)
--
-- Name: contact Type: ACL Owner: 
--

REVOKE ALL on "contact" from PUBLIC;
GRANT ALL on "contact" to "fgdb";
GRANT ALL on "contact" to "fgdiag";

--
-- TOC Entry ID 55 (OID 2556562)
--
-- Name: contactlist Type: TABLE Owner: fgdb
--

CREATE TABLE "contactlist" (
	"id" integer DEFAULT nextval('ContactList_id_seq'::text) NOT NULL,
	"contactid" integer DEFAULT '0' NOT NULL,
	"listname" character varying(20),
	"putonlist" date,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"removedfromlist" date,
	"active" character varying(1) DEFAULT 'Y',
	"remarks" text,
	CONSTRAINT "contactlist_active" CHECK (((active = 'Y'::"varchar") OR (active = 'N'::"varchar"))),
	Constraint "contactlist_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 56 (OID 2556562)
--
-- Name: contactlist Type: ACL Owner: 
--

REVOKE ALL on "contactlist" from PUBLIC;
GRANT ALL on "contactlist" to "fgdb";
GRANT ALL on "contactlist" to "fgdiag";

--
-- TOC Entry ID 57 (OID 2556568)
--
-- Name: controllercard Type: TABLE Owner: fgdb
--

CREATE TABLE "controllercard" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"numserial" integer DEFAULT '0' NOT NULL,
	"numparallel" integer DEFAULT '0' NOT NULL,
	"numide" integer DEFAULT '0' NOT NULL,
	"floppy" character varying(1) DEFAULT 'Y' NOT NULL,
	CONSTRAINT "controllercard_floppy" CHECK (((floppy = 'N'::"varchar") OR (floppy = 'Y'::"varchar"))),
	Constraint "controllercard_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 58 (OID 2556568)
--
-- Name: controllercard Type: ACL Owner: 
--

REVOKE ALL on "controllercard" from PUBLIC;
GRANT ALL on "controllercard" to "fgdb";
GRANT ALL on "controllercard" to "fgdiag";

--
-- TOC Entry ID 59 (OID 2556571)
--
-- Name: daysoff Type: TABLE Owner: fgdb
--

CREATE TABLE "daysoff" (
	"id" integer DEFAULT nextval('DaysOff_id_seq'::text) NOT NULL,
	"contactid" integer DEFAULT '0' NOT NULL,
	"dayoff" date,
	"vacation" character varying(1) DEFAULT 'N',
	"offsitework" character varying(1) DEFAULT 'N',
	"notes" text,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	CONSTRAINT "daysoff_offsitework" CHECK (((offsitework = 'N'::"varchar") OR (offsitework = 'Y'::"varchar"))),
	CONSTRAINT "daysoff_vacation" CHECK (((vacation = 'N'::"varchar") OR (vacation = 'Y'::"varchar"))),
	Constraint "daysoff_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 60 (OID 2556571)
--
-- Name: daysoff Type: ACL Owner: 
--

REVOKE ALL on "daysoff" from PUBLIC;
GRANT ALL on "daysoff" to "fgdb";
GRANT ALL on "daysoff" to "fgdiag";

--
-- TOC Entry ID 61 (OID 2556577)
--
-- Name: donation Type: TABLE Owner: fgdb
--

CREATE TABLE "donation" (
	"id" integer DEFAULT nextval('Donation_id_seq'::text) NOT NULL,
	"contactid" integer DEFAULT '0' NOT NULL,
	"contacttype" character varying(1) DEFAULT 'P' NOT NULL,
	"firstname" character varying(25),
	"middlename" character varying(25),
	"lastname" character varying(50),
	"organization" character varying(50),
	"address" character varying(50),
	"address2" character varying(50),
	"city" character varying(30) DEFAULT 'Portland' NOT NULL,
	"state" character varying(2) DEFAULT 'OR',
	"zip" character varying(10),
	"phone" character varying(20),
	"email" character varying(50),
	"emailok" character varying(1) DEFAULT 'Y' NOT NULL,
	"mailok" character varying(1) DEFAULT 'Y' NOT NULL,
	"phoneok" character varying(1) DEFAULT 'Y' NOT NULL,
	"cashdonation" numeric(8,2) DEFAULT '0.00' NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"sortname" character varying(25),
	"mbrpayment" character varying(1) DEFAULT 'N' NOT NULL,
	"comp4kids" character varying(1) DEFAULT 'N' NOT NULL,
	"monitorfee" numeric(8,2) DEFAULT '0.00',
	CONSTRAINT "donation_comp4kids" CHECK (((comp4kids = 'N'::"varchar") OR (comp4kids = 'Y'::"varchar"))),
	CONSTRAINT "donation_contacttype" CHECK (((contacttype = 'O'::"varchar") OR (contacttype = 'P'::"varchar"))),
	CONSTRAINT "donation_emailok" CHECK (((emailok = 'N'::"varchar") OR (emailok = 'Y'::"varchar"))),
	CONSTRAINT "donation_mailok" CHECK (((mailok = 'N'::"varchar") OR (mailok = 'Y'::"varchar"))),
	CONSTRAINT "donation_mbrpayment" CHECK (((mbrpayment = 'N'::"varchar") OR (mbrpayment = 'Y'::"varchar"))),
	CONSTRAINT "donation_phoneok" CHECK (((phoneok = 'N'::"varchar") OR (phoneok = 'Y'::"varchar"))),
	Constraint "donation_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 62 (OID 2556577)
--
-- Name: donation Type: ACL Owner: 
--

REVOKE ALL on "donation" from PUBLIC;
GRANT ALL on "donation" to "fgdb";
GRANT ALL on "donation" to "fgdiag";

--
-- TOC Entry ID 63 (OID 2556580)
--
-- Name: donationline Type: TABLE Owner: fgdb
--

CREATE TABLE "donationline" (
	"id" integer DEFAULT nextval('DonationLine_id_seq'::text) NOT NULL,
	"donationid" integer DEFAULT '0' NOT NULL,
	"description" text,
	"quantity" integer DEFAULT '1' NOT NULL,
	"crt" boolean,
	Constraint "donationline_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 64 (OID 2556580)
--
-- Name: donationline Type: ACL Owner: 
--

REVOKE ALL on "donationline" from PUBLIC;
GRANT ALL on "donationline" to "fgdb";
GRANT ALL on "donationline" to "fgdiag";

--
-- TOC Entry ID 65 (OID 2556586)
--
-- Name: drive Type: TABLE Owner: fgdb
--

CREATE TABLE "drive" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	Constraint "drive_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 66 (OID 2556586)
--
-- Name: drive Type: ACL Owner: 
--

REVOKE ALL on "drive" from PUBLIC;
GRANT ALL on "drive" to "fgdb";
GRANT ALL on "drive" to "fgdiag";

--
-- TOC Entry ID 67 (OID 2556589)
--
-- Name: floppydrive Type: TABLE Owner: fgdb
--

CREATE TABLE "floppydrive" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"disksize" character varying(10),
	"capacity" character varying(10),
	"cylinders" integer DEFAULT '0',
	"heads" integer DEFAULT '0',
	"sectors" integer DEFAULT '0',
	Constraint "floppydrive_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 68 (OID 2556589)
--
-- Name: floppydrive Type: ACL Owner: 
--

REVOKE ALL on "floppydrive" from PUBLIC;
GRANT ALL on "floppydrive" to "fgdb";
GRANT ALL on "floppydrive" to "fgdiag";

--
-- TOC Entry ID 69 (OID 2556592)
--
-- Name: gizmo Type: TABLE Owner: fgdb
--

CREATE TABLE "gizmo" (
	"id" integer DEFAULT nextval('Gizmo_id_seq'::text) NOT NULL,
	"classtree" character varying(100),
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"oldstatus" character varying(15),
	"newstatus" character varying(15) DEFAULT 'Received' NOT NULL,
	"obsolete" character varying(1) DEFAULT 'N' NOT NULL,
	"working" character varying(1) DEFAULT 'M' NOT NULL,
	"architecture" character varying(10) DEFAULT 'PC' NOT NULL,
	"manufacturer" character varying(50),
	"modelnumber" character varying(50),
	"location" character varying(10) DEFAULT 'Free Geek' NOT NULL,
	"notes" text,
	"testdata" character varying(1) DEFAULT 'N',
	"value" numeric(5,1) DEFAULT '0.0' NOT NULL,
	"inventoried" timestamp with time zone DEFAULT now(),
	"builderid" integer DEFAULT '0' NOT NULL,
	"inspectorid" integer DEFAULT '0' NOT NULL,
	"linuxfund" character varying(1) DEFAULT 'N' NOT NULL,
	"cashvalue" numeric(8,2) DEFAULT '0.00' NOT NULL,
	"needsexpert" character varying(1) DEFAULT 'N',
	"gizmotype" character varying(10) DEFAULT 'Other',
	"adopterid" integer DEFAULT '0' NOT NULL,
	CONSTRAINT "gizmo_linuxfund" CHECK ((((linuxfund = 'N'::"varchar") OR (linuxfund = 'Y'::"varchar")) OR (linuxfund = 'M'::"varchar"))),
	CONSTRAINT "gizmo_needsexpert" CHECK (((needsexpert = 'N'::"varchar") OR (needsexpert = 'Y'::"varchar"))),
	CONSTRAINT "gizmo_obsolete" CHECK ((((obsolete = 'N'::"varchar") OR (obsolete = 'Y'::"varchar")) OR (obsolete = 'M'::"varchar"))),
	CONSTRAINT "gizmo_testdata" CHECK (((testdata = 'N'::"varchar") OR (testdata = 'Y'::"varchar"))),
	CONSTRAINT "gizmo_working" CHECK ((((working = 'N'::"varchar") OR (working = 'Y'::"varchar")) OR (working = 'M'::"varchar"))),
	Constraint "gizmo_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 70 (OID 2556592)
--
-- Name: gizmo Type: ACL Owner: 
--

REVOKE ALL on "gizmo" from PUBLIC;
GRANT ALL on "gizmo" to "fgdb";
GRANT ALL on "gizmo" to "fgdiag";

--
-- TOC Entry ID 71 (OID 2556598)
--
-- Name: gizmoclones Type: TABLE Owner: fgdb
--

CREATE TABLE "gizmoclones" (
	"id" integer DEFAULT nextval('GizmoClones_id_seq'::text) NOT NULL,
	"parentid" integer DEFAULT '0' NOT NULL,
	"childid" integer DEFAULT '0' NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "gizmoclones_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 72 (OID 2556598)
--
-- Name: gizmoclones Type: ACL Owner: 
--

REVOKE ALL on "gizmoclones" from PUBLIC;
GRANT ALL on "gizmoclones" to "fgdb";
GRANT ALL on "gizmoclones" to "fgdiag";

--
-- TOC Entry ID 73 (OID 2556601)
--
-- Name: gizmostatuschanges Type: TABLE Owner: fgdb
--

CREATE TABLE "gizmostatuschanges" (
	"id" integer DEFAULT '0' NOT NULL,
	"oldstatus" character varying(15),
	"newstatus" character varying(15),
	"created" timestamp with time zone DEFAULT now(),
	"change_id" integer DEFAULT nextval('GizmoStatusChanges_change_id_seq'::text) NOT NULL,
	Constraint "gizmostatuschanges_pkey" Primary Key ("change_id")
);

--
-- TOC Entry ID 74 (OID 2556601)
--
-- Name: gizmostatuschanges Type: ACL Owner: 
--

REVOKE ALL on "gizmostatuschanges" from PUBLIC;
GRANT ALL on "gizmostatuschanges" to "fgdb";
GRANT ALL on "gizmostatuschanges" to "fgdiag";

--
-- TOC Entry ID 75 (OID 2556604)
--
-- Name: holidays Type: TABLE Owner: fgdb
--

CREATE TABLE "holidays" (
	"id" integer DEFAULT nextval('Holidays_id_seq'::text) NOT NULL,
	"name" character varying(50),
	"holiday" date,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "holidays_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 76 (OID 2556604)
--
-- Name: holidays Type: ACL Owner: 
--

REVOKE ALL on "holidays" from PUBLIC;
GRANT ALL on "holidays" to "fgdb";
GRANT ALL on "holidays" to "fgdiag";

--
-- TOC Entry ID 77 (OID 2556607)
--
-- Name: ideharddrive Type: TABLE Owner: fgdb
--

CREATE TABLE "ideharddrive" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"cylinders" integer DEFAULT '0' NOT NULL,
	"heads" integer DEFAULT '0' NOT NULL,
	"sectors" integer DEFAULT '0' NOT NULL,
	"ata" character varying(10),
	"sizemb" integer DEFAULT '0' NOT NULL,
	Constraint "ideharddrive_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 78 (OID 2556607)
--
-- Name: ideharddrive Type: ACL Owner: 
--

REVOKE ALL on "ideharddrive" from PUBLIC;
GRANT ALL on "ideharddrive" to "fgdb";
GRANT ALL on "ideharddrive" to "fgdiag";

--
-- TOC Entry ID 79 (OID 2556610)
--
-- Name: income Type: TABLE Owner: fgdb
--

CREATE TABLE "income" (
	"id" integer DEFAULT nextval('Income_id_seq'::text) NOT NULL,
	"incometype" character varying(10),
	"description" character varying(50),
	"received" date,
	"amount" numeric(8,2) DEFAULT '0.00' NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"contactid" integer DEFAULT '0' NOT NULL,
	Constraint "income_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 80 (OID 2556610)
--
-- Name: income Type: ACL Owner: 
--

REVOKE ALL on "income" from PUBLIC;
GRANT ALL on "income" to "fgdb";
GRANT ALL on "income" to "fgdiag";

--
-- TOC Entry ID 81 (OID 2556613)
--
-- Name: issuenotes Type: TABLE Owner: fgdb
--

CREATE TABLE "issuenotes" (
	"id" integer DEFAULT '0' NOT NULL,
	"issueid" integer DEFAULT '0' NOT NULL,
	"techname" character varying(25),
	"notes" text,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "issuenotes_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 82 (OID 2556613)
--
-- Name: issuenotes Type: ACL Owner: 
--

REVOKE ALL on "issuenotes" from PUBLIC;
GRANT ALL on "issuenotes" to "fgdb";
GRANT ALL on "issuenotes" to "fgdiag";

--
-- TOC Entry ID 83 (OID 2556619)
--
-- Name: issues Type: TABLE Owner: fgdb
--

CREATE TABLE "issues" (
	"id" integer DEFAULT '0' NOT NULL,
	"contactid" integer DEFAULT '0' NOT NULL,
	"gizmoid" integer DEFAULT '0' NOT NULL,
	"issuename" character varying(100),
	"issuestatus" character varying(10),
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "issues_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 84 (OID 2556619)
--
-- Name: issues Type: ACL Owner: 
--

REVOKE ALL on "issues" from PUBLIC;
GRANT ALL on "issues" to "fgdb";
GRANT ALL on "issues" to "fgdiag";

--
-- TOC Entry ID 85 (OID 2556622)
--
-- Name: jobs Type: TABLE Owner: fgdb
--

CREATE TABLE "jobs" (
	"id" integer DEFAULT nextval('Jobs_id_seq'::text) NOT NULL,
	"job" character varying(50),
	"schedulename" character varying(15) DEFAULT 'Main' NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "jobs_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 86 (OID 2556622)
--
-- Name: jobs Type: ACL Owner: 
--

REVOKE ALL on "jobs" from PUBLIC;
GRANT ALL on "jobs" to "fgdb";
GRANT ALL on "jobs" to "fgdiag";

--
-- TOC Entry ID 87 (OID 2556625)
--
-- Name: keyboard Type: TABLE Owner: fgdb
--

CREATE TABLE "keyboard" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"kbtype" character varying(10),
	"numkeys" character varying(10),
	Constraint "keyboard_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 88 (OID 2556625)
--
-- Name: keyboard Type: ACL Owner: 
--

REVOKE ALL on "keyboard" from PUBLIC;
GRANT ALL on "keyboard" to "fgdb";
GRANT ALL on "keyboard" to "fgdiag";

--
-- TOC Entry ID 89 (OID 2556628)
--
-- Name: links Type: TABLE Owner: fgdb
--

CREATE TABLE "links" (
	"id" integer DEFAULT nextval('Links_id_seq'::text) NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"url" character varying(250),
	"helptext" character varying(100),
	"linktext" character varying(250),
	"broken" character varying(1) DEFAULT 'N',
	"howto" character varying(1) DEFAULT 'N',
	"external" character varying(1) DEFAULT 'N',
	CONSTRAINT "links_broken" CHECK (((broken = 'N'::"varchar") OR (broken = 'Y'::"varchar"))),
	CONSTRAINT "links_external" CHECK (((external = 'N'::"varchar") OR (external = 'Y'::"varchar"))),
	CONSTRAINT "links_howto" CHECK (((howto = 'N'::"varchar") OR (howto = 'Y'::"varchar"))),
	Constraint "links_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 90 (OID 2556628)
--
-- Name: links Type: ACL Owner: 
--

REVOKE ALL on "links" from PUBLIC;
GRANT ALL on "links" to "fgdb";
GRANT ALL on "links" to "fgdiag";

--
-- TOC Entry ID 91 (OID 2556631)
--
-- Name: materials Type: TABLE Owner: fgdb
--

CREATE TABLE "materials" (
	"id" integer DEFAULT nextval('Materials_id_seq'::text) NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"materialname" character varying(25),
	"ratebase" character varying(1) DEFAULT 'W',
	"defaultunit" character varying(20),
	CONSTRAINT "materials_ratebase" CHECK (((ratebase = 'W'::"varchar") OR (ratebase = 'P'::"varchar"))),
	Constraint "materials_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 92 (OID 2556631)
--
-- Name: materials Type: ACL Owner: 
--

REVOKE ALL on "materials" from PUBLIC;
GRANT ALL on "materials" to "fgdb";
GRANT ALL on "materials" to "fgdiag";

--
-- TOC Entry ID 93 (OID 2556634)
--
-- Name: member Type: TABLE Owner: fgdb
--

CREATE TABLE "member" (
	"id" integer DEFAULT '0' NOT NULL,
	"membertype" character varying(1) DEFAULT 'M',
	"howfoundout" text,
	"interestcomputer" character varying(1) DEFAULT 'N' NOT NULL,
	"interestclasses" character varying(1) DEFAULT 'N' NOT NULL,
	"interestaccess" character varying(1) DEFAULT 'N' NOT NULL,
	"skillhardware" character varying(1) DEFAULT 'N' NOT NULL,
	"texthardware" text,
	"skillnetwork" character varying(1) DEFAULT 'N' NOT NULL,
	"textnetwork" text,
	"skilllinux" character varying(1) DEFAULT 'N' NOT NULL,
	"textlinux" text,
	"skillsoftware" character varying(1) DEFAULT 'N' NOT NULL,
	"textsoftware" text,
	"skillteaching" character varying(1) DEFAULT 'N' NOT NULL,
	"textteaching" text,
	"skillothercomputer" character varying(1) DEFAULT 'N' NOT NULL,
	"textothercomputer" text,
	"skilladmin" character varying(1) DEFAULT 'N' NOT NULL,
	"textadmin" text,
	"skillconstruction" character varying(1) DEFAULT 'N' NOT NULL,
	"textconstruction" text,
	"skillvolunteercoord" character varying(1) DEFAULT 'N' NOT NULL,
	"textvolunteercoord" text,
	"skillother" character varying(1) DEFAULT 'N' NOT NULL,
	"textother" text,
	"notes" text,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	CONSTRAINT "member_interestaccess" CHECK (((interestaccess = 'N'::"varchar") OR (interestaccess = 'Y'::"varchar"))),
	CONSTRAINT "member_interestclasses" CHECK (((interestclasses = 'N'::"varchar") OR (interestclasses = 'Y'::"varchar"))),
	CONSTRAINT "member_interestcomputer" CHECK (((interestcomputer = 'N'::"varchar") OR (interestcomputer = 'Y'::"varchar"))),
	CONSTRAINT "member_membertype" CHECK ((((membertype = 'V'::"varchar") OR (membertype = 'M'::"varchar")) OR (membertype = 'N'::"varchar"))),
	CONSTRAINT "member_skilladmin" CHECK (((skilladmin = 'N'::"varchar") OR (skilladmin = 'Y'::"varchar"))),
	CONSTRAINT "member_skillconstruction" CHECK (((skillconstruction = 'N'::"varchar") OR (skillconstruction = 'Y'::"varchar"))),
	CONSTRAINT "member_skillhardware" CHECK (((skillhardware = 'N'::"varchar") OR (skillhardware = 'Y'::"varchar"))),
	CONSTRAINT "member_skilllinux" CHECK (((skilllinux = 'N'::"varchar") OR (skilllinux = 'Y'::"varchar"))),
	CONSTRAINT "member_skillnetwork" CHECK (((skillnetwork = 'N'::"varchar") OR (skillnetwork = 'Y'::"varchar"))),
	CONSTRAINT "member_skillother" CHECK (((skillother = 'N'::"varchar") OR (skillother = 'Y'::"varchar"))),
	CONSTRAINT "member_skillothercomputer" CHECK (((skillothercomputer = 'N'::"varchar") OR (skillothercomputer = 'Y'::"varchar"))),
	CONSTRAINT "member_skillsoftware" CHECK (((skillsoftware = 'N'::"varchar") OR (skillsoftware = 'Y'::"varchar"))),
	CONSTRAINT "member_skillteaching" CHECK (((skillteaching = 'N'::"varchar") OR (skillteaching = 'Y'::"varchar"))),
	CONSTRAINT "member_skillvolunteercoord" CHECK (((skillvolunteercoord = 'N'::"varchar") OR (skillvolunteercoord = 'Y'::"varchar"))),
	Constraint "member_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 94 (OID 2556634)
--
-- Name: member Type: ACL Owner: 
--

REVOKE ALL on "member" from PUBLIC;
GRANT ALL on "member" to "fgdb";
GRANT ALL on "member" to "fgdiag";

--
-- TOC Entry ID 95 (OID 2556640)
--
-- Name: memberhour Type: TABLE Owner: fgdb
--

CREATE TABLE "memberhour" (
	"id" integer DEFAULT nextval('MemberHour_id_seq'::text) NOT NULL,
	"memberid" integer DEFAULT '0' NOT NULL,
	"workdate" date,
	"intime" time without time zone,
	"outtime" time without time zone,
	"jobtype" character varying(15),
	"jobdescription" text,
	"hours" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"paytype" character varying(1) DEFAULT 'V' NOT NULL,
	CONSTRAINT "memberhour_paytype" CHECK (((((paytype = 'V'::"varchar") OR (paytype = 'W'::"varchar")) OR (paytype = 'H'::"varchar")) OR (paytype = 'O'::"varchar"))),
	Constraint "memberhour_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 96 (OID 2556640)
--
-- Name: memberhour Type: ACL Owner: 
--

REVOKE ALL on "memberhour" from PUBLIC;
GRANT ALL on "memberhour" to "fgdb";
GRANT ALL on "memberhour" to "fgdiag";

--
-- TOC Entry ID 97 (OID 2556646)
--
-- Name: misccard Type: TABLE Owner: fgdb
--

CREATE TABLE "misccard" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"miscnotes" text,
	Constraint "misccard_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 98 (OID 2556646)
--
-- Name: misccard Type: ACL Owner: 
--

REVOKE ALL on "misccard" from PUBLIC;
GRANT ALL on "misccard" to "fgdb";
GRANT ALL on "misccard" to "fgdiag";

--
-- TOC Entry ID 99 (OID 2556652)
--
-- Name: misccomponent Type: TABLE Owner: fgdb
--

CREATE TABLE "misccomponent" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"miscnotes" text,
	Constraint "misccomponent_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 100 (OID 2556652)
--
-- Name: misccomponent Type: ACL Owner: 
--

REVOKE ALL on "misccomponent" from PUBLIC;
GRANT ALL on "misccomponent" to "fgdb";
GRANT ALL on "misccomponent" to "fgdiag";

--
-- TOC Entry ID 101 (OID 2556658)
--
-- Name: miscdrive Type: TABLE Owner: fgdb
--

CREATE TABLE "miscdrive" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"miscnotes" text,
	Constraint "miscdrive_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 102 (OID 2556658)
--
-- Name: miscdrive Type: ACL Owner: 
--

REVOKE ALL on "miscdrive" from PUBLIC;
GRANT ALL on "miscdrive" to "fgdb";
GRANT ALL on "miscdrive" to "fgdiag";

--
-- TOC Entry ID 103 (OID 2556664)
--
-- Name: miscgizmo Type: TABLE Owner: fgdb
--

CREATE TABLE "miscgizmo" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	Constraint "miscgizmo_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 104 (OID 2556664)
--
-- Name: miscgizmo Type: ACL Owner: 
--

REVOKE ALL on "miscgizmo" from PUBLIC;
GRANT ALL on "miscgizmo" to "fgdb";
GRANT ALL on "miscgizmo" to "fgdiag";

--
-- TOC Entry ID 105 (OID 2556667)
--
-- Name: modem Type: TABLE Owner: fgdb
--

CREATE TABLE "modem" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"speed" character varying(15),
	Constraint "modem_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 106 (OID 2556667)
--
-- Name: modem Type: ACL Owner: 
--

REVOKE ALL on "modem" from PUBLIC;
GRANT ALL on "modem" to "fgdb";
GRANT ALL on "modem" to "fgdiag";

--
-- TOC Entry ID 107 (OID 2556670)
--
-- Name: modemcard Type: TABLE Owner: fgdb
--

CREATE TABLE "modemcard" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"speed" character varying(15),
	Constraint "modemcard_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 108 (OID 2556670)
--
-- Name: modemcard Type: ACL Owner: 
--

REVOKE ALL on "modemcard" from PUBLIC;
GRANT ALL on "modemcard" to "fgdb";
GRANT ALL on "modemcard" to "fgdiag";

--
-- TOC Entry ID 109 (OID 2556673)
--
-- Name: monitor Type: TABLE Owner: fgdb
--

CREATE TABLE "monitor" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"size" character varying(10),
	"resolution" character varying(10),
	Constraint "monitor_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 110 (OID 2556673)
--
-- Name: monitor Type: ACL Owner: 
--

REVOKE ALL on "monitor" from PUBLIC;
GRANT ALL on "monitor" to "fgdb";
GRANT ALL on "monitor" to "fgdiag";

--
-- TOC Entry ID 111 (OID 2556676)
--
-- Name: networkcard Type: TABLE Owner: fgdb
--

CREATE TABLE "networkcard" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"speed" character varying(10),
	"rj45" character varying(1) DEFAULT 'N' NOT NULL,
	"aux" character varying(1) DEFAULT 'N' NOT NULL,
	"bnc" character varying(1) DEFAULT 'N' NOT NULL,
	"thicknet" character varying(1) DEFAULT 'N' NOT NULL,
	"module" character varying(50),
	"io" character varying(10),
	"irq" character varying(2),
	CONSTRAINT "networkcard_aux" CHECK (((aux = 'N'::"varchar") OR (aux = 'Y'::"varchar"))),
	CONSTRAINT "networkcard_bnc" CHECK (((bnc = 'N'::"varchar") OR (bnc = 'Y'::"varchar"))),
	CONSTRAINT "networkcard_rj45" CHECK (((rj45 = 'N'::"varchar") OR (rj45 = 'Y'::"varchar"))),
	CONSTRAINT "networkcard_thicknet" CHECK (((thicknet = 'N'::"varchar") OR (thicknet = 'Y'::"varchar"))),
	Constraint "networkcard_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 112 (OID 2556676)
--
-- Name: networkcard Type: ACL Owner: 
--

REVOKE ALL on "networkcard" from PUBLIC;
GRANT ALL on "networkcard" to "fgdb";
GRANT ALL on "networkcard" to "fgdiag";

--
-- TOC Entry ID 113 (OID 2556679)
--
-- Name: networkingdevice Type: TABLE Owner: fgdb
--

CREATE TABLE "networkingdevice" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"speed" character varying(10),
	"rj45" character varying(1) DEFAULT 'N' NOT NULL,
	"aux" character varying(1) DEFAULT 'N' NOT NULL,
	"bnc" character varying(1) DEFAULT 'N' NOT NULL,
	"thicknet" character varying(1) DEFAULT 'N' NOT NULL,
	CONSTRAINT "networkingdevice_aux" CHECK (((aux = 'N'::"varchar") OR (aux = 'Y'::"varchar"))),
	CONSTRAINT "networkingdevice_bnc" CHECK (((bnc = 'N'::"varchar") OR (bnc = 'Y'::"varchar"))),
	CONSTRAINT "networkingdevice_rj45" CHECK (((rj45 = 'N'::"varchar") OR (rj45 = 'Y'::"varchar"))),
	CONSTRAINT "networkingdevice_thicknet" CHECK (((thicknet = 'N'::"varchar") OR (thicknet = 'Y'::"varchar"))),
	Constraint "networkingdevice_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 114 (OID 2556679)
--
-- Name: networkingdevice Type: ACL Owner: 
--

REVOKE ALL on "networkingdevice" from PUBLIC;
GRANT ALL on "networkingdevice" to "fgdb";
GRANT ALL on "networkingdevice" to "fgdiag";

--
-- TOC Entry ID 115 (OID 2556682)
--
-- Name: organization Type: TABLE Owner: fgdb
--

CREATE TABLE "organization" (
	"id" integer DEFAULT '0' NOT NULL,
	"contactid" integer DEFAULT '0' NOT NULL,
	"missionstatement" text,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "organization_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 116 (OID 2556682)
--
-- Name: organization Type: ACL Owner: 
--

REVOKE ALL on "organization" from PUBLIC;
GRANT ALL on "organization" to "fgdb";
GRANT ALL on "organization" to "fgdiag";

--
-- TOC Entry ID 117 (OID 2556688)
--
-- Name: pagelinks Type: TABLE Owner: fgdb
--

CREATE TABLE "pagelinks" (
	"id" integer DEFAULT nextval('PageLinks_id_seq'::text) NOT NULL,
	"pageid" integer DEFAULT '0' NOT NULL,
	"linkid" integer DEFAULT '0' NOT NULL,
	"break" character varying(1) DEFAULT 'N',
	"displayorder" integer DEFAULT '0' NOT NULL,
	"helptext" character varying(100),
	"linktext" character varying(250),
	CONSTRAINT "pagelinks_break" CHECK (((break = 'N'::"varchar") OR (break = 'Y'::"varchar"))),
	Constraint "pagelinks_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 118 (OID 2556688)
--
-- Name: pagelinks Type: ACL Owner: 
--

REVOKE ALL on "pagelinks" from PUBLIC;
GRANT ALL on "pagelinks" to "fgdb";
GRANT ALL on "pagelinks" to "fgdiag";

--
-- TOC Entry ID 119 (OID 2556691)
--
-- Name: pages Type: TABLE Owner: fgdb
--

CREATE TABLE "pages" (
	"id" integer DEFAULT nextval('Pages_id_seq'::text) NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"shortname" character varying(25),
	"longname" character varying(100),
	"visible" character varying(1) DEFAULT 'Y',
	"linkid" integer DEFAULT '0' NOT NULL,
	"displayorder" integer DEFAULT '0' NOT NULL,
	"helptext" character varying(100),
	CONSTRAINT "pages_visible" CHECK (((visible = 'N'::"varchar") OR (visible = 'Y'::"varchar"))),
	Constraint "pages_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 120 (OID 2556691)
--
-- Name: pages Type: ACL Owner: 
--

REVOKE ALL on "pages" from PUBLIC;
GRANT ALL on "pages" to "fgdb";
GRANT ALL on "pages" to "fgdiag";

--
-- TOC Entry ID 121 (OID 2556694)
--
-- Name: pickuplines Type: TABLE Owner: fgdb
--

CREATE TABLE "pickuplines" (
	"id" integer DEFAULT nextval('PickupLines_id_seq'::text) NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"pickupid" integer DEFAULT '0' NOT NULL,
	"materialid" integer DEFAULT '0' NOT NULL,
	"pickupunittype" character varying(20),
	"processedunittype" character varying(20),
	"pickupunitcount" integer DEFAULT '1' NOT NULL,
	"processedunitcount" integer DEFAULT '1' NOT NULL,
	"pickupweight" numeric(10,2) DEFAULT '0.00' NOT NULL,
	"processedweight" numeric(10,2) DEFAULT '0.00' NOT NULL,
	"amountcharged" numeric(10,2) DEFAULT '0.00' NOT NULL,
	"rate" numeric(10,4) DEFAULT '0.0000' NOT NULL,
	Constraint "pickuplines_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 122 (OID 2556694)
--
-- Name: pickuplines Type: ACL Owner: 
--

REVOKE ALL on "pickuplines" from PUBLIC;
GRANT ALL on "pickuplines" to "fgdb";
GRANT ALL on "pickuplines" to "fgdiag";

--
-- TOC Entry ID 123 (OID 2556697)
--
-- Name: pickups Type: TABLE Owner: fgdb
--

CREATE TABLE "pickups" (
	"id" integer DEFAULT nextval('Pickups_id_seq'::text) NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"vendorid" integer DEFAULT '0' NOT NULL,
	"pickupdate" date NOT NULL,
	"receiptnumber" character varying(20),
	"settlementnumber" character varying(20),
	Constraint "pickups_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 124 (OID 2556697)
--
-- Name: pickups Type: ACL Owner: 
--

REVOKE ALL on "pickups" from PUBLIC;
GRANT ALL on "pickups" to "fgdb";
GRANT ALL on "pickups" to "fgdiag";

--
-- TOC Entry ID 125 (OID 2556700)
--
-- Name: pointingdevice Type: TABLE Owner: fgdb
--

CREATE TABLE "pointingdevice" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"connector" character varying(10),
	"pointertype" character varying(10),
	Constraint "pointingdevice_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 126 (OID 2556700)
--
-- Name: pointingdevice Type: ACL Owner: 
--

REVOKE ALL on "pointingdevice" from PUBLIC;
GRANT ALL on "pointingdevice" to "fgdb";
GRANT ALL on "pointingdevice" to "fgdiag";

--
-- TOC Entry ID 127 (OID 2556703)
--
-- Name: powersupply Type: TABLE Owner: fgdb
--

CREATE TABLE "powersupply" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"watts" integer DEFAULT '0' NOT NULL,
	"connection" character varying(10),
	Constraint "powersupply_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 128 (OID 2556703)
--
-- Name: powersupply Type: ACL Owner: 
--

REVOKE ALL on "powersupply" from PUBLIC;
GRANT ALL on "powersupply" to "fgdb";
GRANT ALL on "powersupply" to "fgdiag";

--
-- TOC Entry ID 129 (OID 2556706)
--
-- Name: processor Type: TABLE Owner: fgdb
--

CREATE TABLE "processor" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"chipclass" character varying(15),
	"interface" character varying(10),
	"speed" integer DEFAULT '0' NOT NULL,
	Constraint "processor_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 130 (OID 2556706)
--
-- Name: processor Type: ACL Owner: 
--

REVOKE ALL on "processor" from PUBLIC;
GRANT ALL on "processor" to "fgdb";
GRANT ALL on "processor" to "fgdiag";

--
-- TOC Entry ID 131 (OID 2556709)
--
-- Name: scsicard Type: TABLE Owner: fgdb
--

CREATE TABLE "scsicard" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"internalinterface" character varying(15),
	"externalinterface" character varying(15),
	"parms" text,
	Constraint "scsicard_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 132 (OID 2556709)
--
-- Name: scsicard Type: ACL Owner: 
--

REVOKE ALL on "scsicard" from PUBLIC;
GRANT ALL on "scsicard" to "fgdb";
GRANT ALL on "scsicard" to "fgdiag";

--
-- TOC Entry ID 133 (OID 2556715)
--
-- Name: scsiharddrive Type: TABLE Owner: fgdb
--

CREATE TABLE "scsiharddrive" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"sizemb" integer DEFAULT '0' NOT NULL,
	"scsiversion" character varying(10),
	Constraint "scsiharddrive_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 134 (OID 2556715)
--
-- Name: scsiharddrive Type: ACL Owner: 
--

REVOKE ALL on "scsiharddrive" from PUBLIC;
GRANT ALL on "scsiharddrive" to "fgdb";
GRANT ALL on "scsiharddrive" to "fgdiag";

--
-- TOC Entry ID 135 (OID 2556718)
--
-- Name: sales Type: TABLE Owner: fgdb
--

CREATE TABLE "sales" (
	"id" integer DEFAULT nextval('Sales_id_seq'::text) NOT NULL,
	"contactid" integer DEFAULT '0' NOT NULL,
	"contacttype" character varying(1) DEFAULT 'P' NOT NULL,
	"firstname" character varying(25),
	"middlename" character varying(25),
	"lastname" character varying(50),
	"organization" character varying(50),
	"address" character varying(50),
	"address2" character varying(50),
	"city" character varying(30) DEFAULT 'Portland' NOT NULL,
	"state" character varying(2) DEFAULT 'OR',
	"zip" character varying(10),
	"phone" character varying(20),
	"email" character varying(50),
	"emailok" character varying(1) DEFAULT 'Y' NOT NULL,
	"mailok" character varying(1) DEFAULT 'Y' NOT NULL,
	"phoneok" character varying(1) DEFAULT 'Y' NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"subtotal" numeric(8,2) DEFAULT '0.00' NOT NULL,
	"discount" numeric(8,2) DEFAULT '0.00' NOT NULL,
	"total" numeric(8,2) DEFAULT '0.00' NOT NULL,
	"sortname" character varying(25),
	CONSTRAINT "sales_contacttype" CHECK (((contacttype = 'O'::"varchar") OR (contacttype = 'P'::"varchar"))),
	CONSTRAINT "sales_emailok" CHECK (((emailok = 'N'::"varchar") OR (emailok = 'Y'::"varchar"))),
	CONSTRAINT "sales_mailok" CHECK (((mailok = 'N'::"varchar") OR (mailok = 'Y'::"varchar"))),
	CONSTRAINT "sales_phoneok" CHECK (((phoneok = 'N'::"varchar") OR (phoneok = 'Y'::"varchar"))),
	Constraint "sales_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 136 (OID 2556718)
--
-- Name: sales Type: ACL Owner: 
--

REVOKE ALL on "sales" from PUBLIC;
GRANT ALL on "sales" to "fgdb";
GRANT ALL on "sales" to "fgdiag";

--
-- TOC Entry ID 137 (OID 2556721)
--
-- Name: salesline Type: TABLE Owner: fgdb
--

CREATE TABLE "salesline" (
	"id" integer DEFAULT nextval('SalesLine_id_seq'::text) NOT NULL,
	"salesid" integer DEFAULT '0' NOT NULL,
	"gizmoid" integer DEFAULT '0' NOT NULL,
	"description" text,
	"cashvalue" numeric(8,2) DEFAULT '0.00' NOT NULL,
	"subtotal" numeric(8,2) DEFAULT '0.00' NOT NULL,
	"discount" numeric(8,2) DEFAULT '0.00' NOT NULL,
	"total" numeric(8,2) DEFAULT '0.00' NOT NULL,
	"merchtype" character varying(15),
	Constraint "salesline_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 138 (OID 2556721)
--
-- Name: salesline Type: ACL Owner: 
--

REVOKE ALL on "salesline" from PUBLIC;
GRANT ALL on "salesline" to "fgdb";
GRANT ALL on "salesline" to "fgdiag";

--
-- TOC Entry ID 139 (OID 2556727)
--
-- Name: scanner Type: TABLE Owner: fgdb
--

CREATE TABLE "scanner" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"interface" character varying(10),
	Constraint "scanner_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 140 (OID 2556727)
--
-- Name: scanner Type: ACL Owner: 
--

REVOKE ALL on "scanner" from PUBLIC;
GRANT ALL on "scanner" to "fgdb";
GRANT ALL on "scanner" to "fgdiag";

--
-- TOC Entry ID 141 (OID 2556730)
--
-- Name: scratchpad Type: TABLE Owner: fgdb
--

CREATE TABLE "scratchpad" (
	"id" integer DEFAULT nextval('ScratchPad_id_seq'::text) NOT NULL,
	"pageid" integer DEFAULT '0' NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"contactid" integer DEFAULT '0' NOT NULL,
	"name" character varying(25),
	"note" text,
	"urgent" character varying(1) DEFAULT 'N',
	"visible" character varying(1) DEFAULT 'Y',
	CONSTRAINT "scratchpad_urgent" CHECK (((urgent = 'N'::"varchar") OR (urgent = 'Y'::"varchar"))),
	CONSTRAINT "scratchpad_visible" CHECK (((visible = 'N'::"varchar") OR (visible = 'Y'::"varchar"))),
	Constraint "scratchpad_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 142 (OID 2556730)
--
-- Name: scratchpad Type: ACL Owner: 
--

REVOKE ALL on "scratchpad" from PUBLIC;
GRANT ALL on "scratchpad" to "fgdb";
GRANT ALL on "scratchpad" to "fgdiag";

--
-- TOC Entry ID 143 (OID 2556736)
--
-- Name: soundcard Type: TABLE Owner: fgdb
--

CREATE TABLE "soundcard" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"soundtype" character varying(15),
	Constraint "soundcard_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 144 (OID 2556736)
--
-- Name: soundcard Type: ACL Owner: 
--

REVOKE ALL on "soundcard" from PUBLIC;
GRANT ALL on "soundcard" to "fgdb";
GRANT ALL on "soundcard" to "fgdiag";

--
-- TOC Entry ID 145 (OID 2556739)
--
-- Name: speaker Type: TABLE Owner: fgdb
--

CREATE TABLE "speaker" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"powered" character varying(1) DEFAULT 'N' NOT NULL,
	"subwoofer" character varying(1) DEFAULT 'N' NOT NULL,
	CONSTRAINT "speaker_powered" CHECK (((powered = 'N'::"varchar") OR (powered = 'Y'::"varchar"))),
	CONSTRAINT "speaker_subwoofer" CHECK (((subwoofer = 'N'::"varchar") OR (subwoofer = 'Y'::"varchar"))),
	Constraint "speaker_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 146 (OID 2556739)
--
-- Name: speaker Type: ACL Owner: 
--

REVOKE ALL on "speaker" from PUBLIC;
GRANT ALL on "speaker" to "fgdb";
GRANT ALL on "speaker" to "fgdiag";

--
-- TOC Entry ID 147 (OID 2556742)
--
-- Name: system Type: TABLE Owner: fgdb
--

CREATE TABLE "system" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"systemconfiguration" text,
	"systemboard" text,
	"adapterinformation" text,
	"multiprocessorinformation" text,
	"displaydetails" text,
	"displayinformation" text,
	"scsiinformation" text,
	"pcmciainformation" text,
	"modeminformation" text,
	"multimediainformation" text,
	"plugnplayinformation" text,
	"physicaldrives" text,
	"ram" integer,
	"videoram" integer,
	"sizemb" integer,
	"scsi" character varying(1) DEFAULT 'N',
	"chipclass" character varying(15),
	"speed" integer DEFAULT '0' NOT NULL,
	CONSTRAINT "system_scsi" CHECK (((scsi = 'N'::"varchar") OR (scsi = 'Y'::"varchar"))),
	Constraint "system_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 148 (OID 2556742)
--
-- Name: system Type: ACL Owner: 
--

REVOKE ALL on "system" from PUBLIC;
GRANT ALL on "system" to "fgdb";
GRANT ALL on "system" to "fgdiag";

--
-- TOC Entry ID 149 (OID 2556748)
--
-- Name: systemboard Type: TABLE Owner: fgdb
--

CREATE TABLE "systemboard" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"pcislots" integer DEFAULT '0' NOT NULL,
	"vesaslots" integer DEFAULT '0' NOT NULL,
	"isaslots" integer DEFAULT '0' NOT NULL,
	"eisaslots" integer DEFAULT '0' NOT NULL,
	"agpslot" character varying(1) DEFAULT 'N',
	"ram30pin" integer DEFAULT '0' NOT NULL,
	"ram72pin" integer DEFAULT '0' NOT NULL,
	"ram168pin" integer DEFAULT '0' NOT NULL,
	"dimmspeed" character varying(10),
	"proc386" integer DEFAULT '0' NOT NULL,
	"proc486" integer DEFAULT '0' NOT NULL,
	"proc586" integer DEFAULT '0' NOT NULL,
	"procmmx" integer DEFAULT '0' NOT NULL,
	"procpro" integer DEFAULT '0' NOT NULL,
	"procsocket7" integer DEFAULT '0' NOT NULL,
	"procslot1" integer DEFAULT '0' NOT NULL,
	CONSTRAINT "systemboard_agpslot" CHECK (((agpslot = 'N'::"varchar") OR (agpslot = 'Y'::"varchar"))),
	Constraint "systemboard_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 150 (OID 2556748)
--
-- Name: systemboard Type: ACL Owner: 
--

REVOKE ALL on "systemboard" from PUBLIC;
GRANT ALL on "systemboard" to "fgdb";
GRANT ALL on "systemboard" to "fgdiag";

--
-- TOC Entry ID 151 (OID 2556751)
--
-- Name: systemcase Type: TABLE Owner: fgdb
--

CREATE TABLE "systemcase" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"casetype" character varying(10),
	Constraint "systemcase_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 152 (OID 2556751)
--
-- Name: systemcase Type: ACL Owner: 
--

REVOKE ALL on "systemcase" from PUBLIC;
GRANT ALL on "systemcase" to "fgdb";
GRANT ALL on "systemcase" to "fgdiag";

--
-- TOC Entry ID 153 (OID 2556754)
--
-- Name: tapedrive Type: TABLE Owner: fgdb
--

CREATE TABLE "tapedrive" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"interface" character varying(15),
	Constraint "tapedrive_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 154 (OID 2556754)
--
-- Name: tapedrive Type: ACL Owner: 
--

REVOKE ALL on "tapedrive" from PUBLIC;
GRANT ALL on "tapedrive" to "fgdb";
GRANT ALL on "tapedrive" to "fgdiag";

--
-- TOC Entry ID 155 (OID 2556757)
--
-- Name: unit2material Type: TABLE Owner: fgdb
--

CREATE TABLE "unit2material" (
	"id" integer DEFAULT nextval('Unit2Material_id_seq'::text) NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	"materialid" integer DEFAULT '0' NOT NULL,
	"unittype" character varying(20),
	Constraint "unit2material_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 156 (OID 2556757)
--
-- Name: unit2material Type: ACL Owner: 
--

REVOKE ALL on "unit2material" from PUBLIC;
GRANT ALL on "unit2material" to "fgdb";
GRANT ALL on "unit2material" to "fgdiag";

--
-- TOC Entry ID 157 (OID 2556760)
--
-- Name: users Type: TABLE Owner: fgdb
--

CREATE TABLE "users" (
	"id" integer DEFAULT nextval('Users_id_seq'::text) NOT NULL,
	"username" character varying(50) NOT NULL,
	"password" character varying(50),
	"usergroup" character varying(50),
	Constraint "users_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 158 (OID 2556760)
--
-- Name: users Type: ACL Owner: 
--

REVOKE ALL on "users" from PUBLIC;
GRANT ALL on "users" to "fgdb";
GRANT ALL on "users" to "fgdiag";

--
-- TOC Entry ID 159 (OID 2556763)
--
-- Name: videocard Type: TABLE Owner: fgdb
--

CREATE TABLE "videocard" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"videomemory" character varying(10),
	"resolutions" text,
	Constraint "videocard_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 160 (OID 2556763)
--
-- Name: videocard Type: ACL Owner: 
--

REVOKE ALL on "videocard" from PUBLIC;
GRANT ALL on "videocard" to "fgdb";
GRANT ALL on "videocard" to "fgdiag";

--
-- TOC Entry ID 161 (OID 2556769)
--
-- Name: workmonths Type: TABLE Owner: fgdb
--

CREATE TABLE "workmonths" (
	"id" integer DEFAULT nextval('WorkMonths_id_seq'::text) NOT NULL,
	"contactid" integer DEFAULT '0' NOT NULL,
	"work_year" integer DEFAULT '2004' NOT NULL,
	"work_month" integer DEFAULT '1' NOT NULL,
	"day_01" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_02" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_03" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_04" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_05" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_06" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_07" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_08" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_09" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_10" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_11" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_12" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_13" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_14" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_15" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_16" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_17" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_18" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_19" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_20" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_21" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_22" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_23" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_24" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_25" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_26" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_27" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_28" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_29" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_30" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"day_31" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "workmonths_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 162 (OID 2556769)
--
-- Name: workmonths Type: ACL Owner: 
--

REVOKE ALL on "workmonths" from PUBLIC;
GRANT ALL on "workmonths" to "fgdb";
GRANT ALL on "workmonths" to "fgdiag";

--
-- TOC Entry ID 163 (OID 2556772)
--
-- Name: workers Type: TABLE Owner: fgdb
--

CREATE TABLE "workers" (
	"id" integer DEFAULT '0' NOT NULL,
	"sunday" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"monday" numeric(5,2) DEFAULT '0.00' NOT NULL,
	"tuesday" numeric(5,2) DEFAULT '8.00' NOT NULL,
	"wednesday" numeric(5,2) DEFAULT '8.00' NOT NULL,
	"thursday" numeric(5,2) DEFAULT '8.00' NOT NULL,
	"friday" numeric(5,2) DEFAULT '8.00' NOT NULL,
	"saturday" numeric(5,2) DEFAULT '8.00' NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "workers_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 164 (OID 2556772)
--
-- Name: workers Type: ACL Owner: 
--

REVOKE ALL on "workers" from PUBLIC;
GRANT ALL on "workers" to "fgdb";
GRANT ALL on "workers" to "fgdiag";

--
-- TOC Entry ID 165 (OID 2556775)
--
-- Name: workersqualifyforjobs Type: TABLE Owner: fgdb
--

CREATE TABLE "workersqualifyforjobs" (
	"id" integer DEFAULT nextval('WorkersQualifyForJobs_id_seq'::text) NOT NULL,
	"contactid" integer DEFAULT '0' NOT NULL,
	"jobid" integer DEFAULT '0' NOT NULL,
	"injobdescription" character varying(1) DEFAULT 'N',
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	CONSTRAINT "workersqualifyf_injobdescriptio" CHECK (((injobdescription = 'N'::"varchar") OR (injobdescription = 'Y'::"varchar"))),
	Constraint "workersqualifyforjobs_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 166 (OID 2556775)
--
-- Name: workersqualifyforjobs Type: ACL Owner: 
--

REVOKE ALL on "workersqualifyforjobs" from PUBLIC;
GRANT ALL on "workersqualifyforjobs" to "fgdb";
GRANT ALL on "workersqualifyforjobs" to "fgdiag";

--
-- TOC Entry ID 167 (OID 2556778)
--
-- Name: all_emails Type: TABLE Owner: fgdb
--

CREATE TABLE "all_emails" (
	"contactid" integer DEFAULT nextval('all_emails_id_seq'::text),
	"listname" character varying(50) DEFAULT 'FGDB' NOT NULL,
	"email" character varying(50),
	"firstname" character varying(25),
	"middlename" character varying(25),
	"lastname" character varying(50),
	"created" timestamp with time zone
);

--
-- TOC Entry ID 168 (OID 2556778)
--
-- Name: all_emails Type: ACL Owner: 
--

REVOKE ALL on "all_emails" from PUBLIC;
GRANT ALL on "all_emails" to "fgdb";
GRANT ALL on "all_emails" to "fgdiag";

--
-- TOC Entry ID 169 (OID 2556783)
--
-- Name: anondict Type: TABLE Owner: fgdb
--

CREATE TABLE "anondict" (
	"id" integer DEFAULT nextval('anonDict_id_seq'::text) NOT NULL,
	"dicttype" integer,
	"value" character varying(50),
	Constraint "anondict_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 170 (OID 2556783)
--
-- Name: anondict Type: ACL Owner: 
--

REVOKE ALL on "anondict" from PUBLIC;
GRANT ALL on "anondict" to "fgdb";
GRANT ALL on "anondict" to "fgdiag";

--
-- TOC Entry ID 171 (OID 2556786)
--
-- Name: answers Type: TABLE Owner: fgdb
--

CREATE TABLE "answers" (
	"id" integer DEFAULT nextval('answers_id_seq'::text) NOT NULL,
	"fk_sess_id" integer,
	"qnum" integer,
	"ansr" character varying(255),
	"fk_questions_id" integer,
	Constraint "answers_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 172 (OID 2556786)
--
-- Name: answers Type: ACL Owner: 
--

REVOKE ALL on "answers" from PUBLIC;
GRANT ALL on "answers" to "fgdb";
GRANT ALL on "answers" to "fgdiag";

--
-- TOC Entry ID 173 (OID 2556789)
--
-- Name: classtree Type: TABLE Owner: fgdb
--

CREATE TABLE "classtree" (
	"id" integer DEFAULT nextval('classTree_id_seq'::text) NOT NULL,
	"classtree" character varying(100),
	"tablename" character varying(50),
	"level" integer,
	"instantiable" character varying(1) DEFAULT 'Y' NOT NULL,
	"intakecode" character varying(10),
	"intakeadd" integer,
	"description" character varying(50),
	CONSTRAINT "classtree_instantiable" CHECK (((instantiable = 'N'::"varchar") OR (instantiable = 'Y'::"varchar"))),
	Constraint "classtree_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 174 (OID 2556789)
--
-- Name: classtree Type: ACL Owner: 
--

REVOKE ALL on "classtree" from PUBLIC;
GRANT ALL on "classtree" to "fgdb";
GRANT ALL on "classtree" to "fgdiag";

--
-- TOC Entry ID 175 (OID 2556792)
--
-- Name: codedinfo Type: TABLE Owner: fgdb
--

CREATE TABLE "codedinfo" (
	"id" integer DEFAULT nextval('codedInfo_id_seq'::text) NOT NULL,
	"codetype" character varying(100),
	"codelength" integer DEFAULT '10',
	"code" character varying(25),
	"description" text,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	Constraint "codedinfo_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 176 (OID 2556792)
--
-- Name: codedinfo Type: ACL Owner: 
--

REVOKE ALL on "codedinfo" from PUBLIC;
GRANT ALL on "codedinfo" to "fgdb";
GRANT ALL on "codedinfo" to "fgdiag";

--
-- TOC Entry ID 177 (OID 2556798)
--
-- Name: defaultvalues Type: TABLE Owner: fgdb
--

CREATE TABLE "defaultvalues" (
	"id" integer DEFAULT nextval('defaultValues_id_seq'::text) NOT NULL,
	"classtree" character varying(100),
	"fieldname" character varying(50),
	"defaultvalue" character varying(50),
	Constraint "defaultvalues_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 178 (OID 2556798)
--
-- Name: defaultvalues Type: ACL Owner: 
--

REVOKE ALL on "defaultvalues" from PUBLIC;
GRANT ALL on "defaultvalues" to "fgdb";
GRANT ALL on "defaultvalues" to "fgdiag";

--
-- TOC Entry ID 179 (OID 2556801)
--
-- Name: fieldmap Type: TABLE Owner: fgdb
--

CREATE TABLE "fieldmap" (
	"id" integer DEFAULT nextval('fieldMap_id_seq'::text) NOT NULL,
	"tablename" character varying(50),
	"fieldname" character varying(50),
	"displayorder" integer DEFAULT '0' NOT NULL,
	"inputwidget" character varying(50),
	"inputwidgetparameters" character varying(100),
	"outputwidget" character varying(50),
	"outputwidgetparameters" character varying(100),
	"editable" character varying(1) DEFAULT 'Y',
	"helplink" character varying(1) DEFAULT 'N',
	"description" character varying(100),
	CONSTRAINT "fieldmap_editable" CHECK (((editable = 'N'::"varchar") OR (editable = 'Y'::"varchar"))),
	CONSTRAINT "fieldmap_helplink" CHECK (((helplink = 'N'::"varchar") OR (helplink = 'Y'::"varchar"))),
	Constraint "fieldmap_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 180 (OID 2556801)
--
-- Name: fieldmap Type: ACL Owner: 
--

REVOKE ALL on "fieldmap" from PUBLIC;
GRANT ALL on "fieldmap" to "fgdb";
GRANT ALL on "fieldmap" to "fgdiag";

--
-- TOC Entry ID 181 (OID 2556804)
--
-- Name: helpscreen Type: TABLE Owner: fgdb
--

CREATE TABLE "helpscreen" (
	"id" integer DEFAULT nextval('helpScreen_id_seq'::text) NOT NULL,
	"tablename" character varying(50),
	"fieldname" character varying(50),
	"displayorder" integer DEFAULT '0' NOT NULL,
	"helptext" text,
	"imageurl" text,
	Constraint "helpscreen_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 182 (OID 2556804)
--
-- Name: helpscreen Type: ACL Owner: 
--

REVOKE ALL on "helpscreen" from PUBLIC;
GRANT ALL on "helpscreen" to "fgdb";
GRANT ALL on "helpscreen" to "fgdiag";

--
-- TOC Entry ID 183 (OID 2556810)
--
-- Name: options Type: TABLE Owner: fgdb
--

CREATE TABLE "options" (
	"id" integer DEFAULT nextval('options_id_seq'::text) NOT NULL,
	"fk_qid" integer,
	"qopts" text,
	Constraint "options_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 184 (OID 2556810)
--
-- Name: options Type: ACL Owner: 
--

REVOKE ALL on "options" from PUBLIC;
GRANT ALL on "options" to "fgdb";
GRANT ALL on "options" to "fgdiag";

--
-- TOC Entry ID 185 (OID 2556816)
--
-- Name: questions Type: TABLE Owner: fgdb
--

CREATE TABLE "questions" (
	"id" integer DEFAULT nextval('questions_id_seq'::text) NOT NULL,
	"qtext" text,
	"qhint" text,
	"qnum" integer,
	"qname" character varying(16),
	"qtype" character varying(4),
	"qargx" character varying(50),
	"qatxt" character varying(50),
	"qsrc" character varying(4),
	"qgrp" character varying(25),
	"active" integer,
	Constraint "questions_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 186 (OID 2556816)
--
-- Name: questions Type: ACL Owner: 
--

REVOKE ALL on "questions" from PUBLIC;
GRANT ALL on "questions" to "fgdb";
GRANT ALL on "questions" to "fgdiag";

--
-- TOC Entry ID 187 (OID 2556822)
--
-- Name: relations Type: TABLE Owner: fgdb
--

CREATE TABLE "relations" (
	"id" integer DEFAULT nextval('relations_id_seq'::text) NOT NULL,
	"parenttable" character varying(50),
	"parentfield" character varying(50),
	"parentmultiplicity" character varying(10),
	"childtable" character varying(50),
	"childfield" character varying(50),
	"childmultiplicity" character varying(10),
	Constraint "relations_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 188 (OID 2556822)
--
-- Name: relations Type: ACL Owner: 
--

REVOKE ALL on "relations" from PUBLIC;
GRANT ALL on "relations" to "fgdb";
GRANT ALL on "relations" to "fgdiag";

--
-- TOC Entry ID 189 (OID 2556825)
--
-- Name: sessions Type: TABLE Owner: fgdb
--

CREATE TABLE "sessions" (
	"id" integer DEFAULT nextval('sessions_id_seq'::text) NOT NULL,
	"sysid" character varying(10),
	"status" integer,
	"nextq" integer,
	"boxtype" character varying(20),
	"mtime" character varying(50),
	"isold" character varying(1) DEFAULT 'N',
	CONSTRAINT "sessions_isold" CHECK (((isold = 'Y'::"varchar") OR (isold = 'N'::"varchar"))),
	Constraint "sessions_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 190 (OID 2556825)
--
-- Name: sessions Type: ACL Owner: 
--

REVOKE ALL on "sessions" from PUBLIC;
GRANT ALL on "sessions" to "fgdb";
GRANT ALL on "sessions" to "fgdiag";

--
-- TOC Entry ID 191 (OID 2556828)
--
-- Name: laptop Type: TABLE Owner: fgdb
--

CREATE TABLE "laptop" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"ram" integer,
	"harddrivesizegb" numeric(8,2) DEFAULT '0.00',
	"chipclass" character varying(15),
	"chipspeed" integer DEFAULT '0' NOT NULL,
	Constraint "laptop_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 192 (OID 2556828)
--
-- Name: laptop Type: ACL Owner: 
--

REVOKE ALL on "laptop" from PUBLIC;
GRANT ALL on "laptop" to "fgdb";
GRANT ALL on "laptop" to "fgdiag";

--
-- TOC Entry ID 193 (OID 2556831)
--
-- Name: printer Type: TABLE Owner: fgdb
--

CREATE TABLE "printer" (
	"id" integer DEFAULT '0' NOT NULL,
	"classtree" character varying(100),
	"speedppm" integer DEFAULT '0' NOT NULL,
	"printertype" character varying(10),
	"interface" character varying(10) DEFAULT 'Parallel',
	Constraint "printer_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 194 (OID 2556831)
--
-- Name: printer Type: ACL Owner: 
--

REVOKE ALL on "printer" from PUBLIC;
GRANT ALL on "printer" to "fgdb";
GRANT ALL on "printer" to "fgdiag";

--
-- TOC Entry ID 43 (OID 2556834)
--
-- Name: weeklyshifts_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "weeklyshifts_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 195 (OID 2556836)
--
-- Name: weeklyshifts Type: TABLE Owner: fgdb
--

CREATE TABLE "weeklyshifts" (
	"id" integer DEFAULT nextval('WeeklyShifts_id_seq'::text) NOT NULL,
	"schedulename" character varying(15) DEFAULT 'Main' NOT NULL,
	"contactid" integer DEFAULT '0' NOT NULL,
	"jobid" integer DEFAULT '0' NOT NULL,
	"weekday" integer DEFAULT '0' NOT NULL,
	"intime" time without time zone,
	"outtime" time without time zone,
	"meeting" character varying(1) DEFAULT 'N',
	"effective" date DEFAULT '2004-01-01' NOT NULL,
	"ineffective" date DEFAULT '3004-01-01' NOT NULL,
	"modified" timestamp with time zone DEFAULT now(),
	"created" timestamp with time zone DEFAULT now(),
	CONSTRAINT "weeklyshifts_meeting" CHECK (((meeting = 'N'::"varchar") OR (meeting = 'Y'::"varchar"))),
	Constraint "weeklyshifts_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 196 (OID 2556836)
--
-- Name: weeklyshifts Type: ACL Owner: 
--

REVOKE ALL on "weeklyshifts" from PUBLIC;
GRANT ALL on "weeklyshifts" to "fgdb";
GRANT ALL on "weeklyshifts" to "fgdiag";

\connect - rfs

--
-- TOC Entry ID 205 (OID 3641300)
--
-- Name: "gizmo_status_changed" () Type: FUNCTION Owner: rfs
--

CREATE FUNCTION "gizmo_status_changed" () RETURNS opaque AS '
  BEGIN
    IF NEW.newstatus <> OLD.newstatus THEN
      INSERT INTO gizmostatuschanges (id, oldStatus, newStatus) VALUES (OLD.id, OLD.newstatus, NEW.newstatus);
      -- this is redundant oldstatus is in the history table, so
      -- it does not really need to be in gizmo as well
      NEW.oldstatus := OLD.newstatus;
    END IF;
    RETURN NEW;
  END;
' LANGUAGE 'plpgsql';

--
-- TOC Entry ID 206 (OID 3641301)
--
-- Name: "gizmo_status_insert" () Type: FUNCTION Owner: rfs
--

CREATE FUNCTION "gizmo_status_insert" () RETURNS opaque AS '
  BEGIN
    INSERT INTO gizmostatuschanges (id, oldStatus, newStatus) VALUES (NEW.id, ''none'', NEW.newstatus);
    -- this is redundant oldstatus is in the history table, so
    -- it does not really need to be in gizmo as well
    NEW.oldstatus := ''none'';
    RETURN NEW;
  END;
' LANGUAGE 'plpgsql';

\connect - fgdb

--
-- TOC Entry ID 44 (OID 3745545)
--
-- Name: allowedstatuses_id_seq Type: SEQUENCE Owner: fgdb
--

CREATE SEQUENCE "allowedstatuses_id_seq" start 1 increment 1 maxvalue 9223372036854775807 minvalue 1 cache 1;

--
-- TOC Entry ID 197 (OID 3745547)
--
-- Name: allowedstatuses Type: TABLE Owner: fgdb
--

CREATE TABLE "allowedstatuses" (
	"id" integer DEFAULT nextval('allowedStatuses_id_seq'::text) NOT NULL,
	"oldstatus" character varying(15),
	"newstatus" character varying(15),
	Constraint "allowedstatuses_pkey" Primary Key ("id")
);

--
-- TOC Entry ID 198 (OID 3745547)
--
-- Name: allowedstatuses Type: ACL Owner: 
--

REVOKE ALL on "allowedstatuses" from PUBLIC;
GRANT ALL on "allowedstatuses" to "fgdb";
GRANT ALL on "allowedstatuses" to "fgdiag";

--
-- TOC Entry ID 199 (OID 3612471)
--
-- Name: "users_username_key" Type: INDEX Owner: fgdb
--

CREATE UNIQUE INDEX users_username_key ON users USING btree (username);

--
-- TOC Entry ID 200 (OID 3612472)
--
-- Name: "contact_sortname" Type: INDEX Owner: fgdb
--

CREATE INDEX contact_sortname ON contact USING btree (sortname);

--
-- TOC Entry ID 207 (OID 3612473)
--
-- Name: borrow_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "borrow_created_trigger" BEFORE INSERT ON "borrow"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 208 (OID 3612474)
--
-- Name: borrow_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "borrow_modified_trigger" BEFORE UPDATE ON "borrow"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 249 (OID 3612475)
--
-- Name: contact_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "contact_created_trigger" BEFORE INSERT ON "contact"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 250 (OID 3612476)
--
-- Name: contact_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "contact_modified_trigger" BEFORE UPDATE ON "contact"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 251 (OID 3612477)
--
-- Name: contactlist_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "contactlist_created_trigger" BEFORE INSERT ON "contactlist"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 252 (OID 3612478)
--
-- Name: contactlist_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "contactlist_modified_trigger" BEFORE UPDATE ON "contactlist"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 254 (OID 3612479)
--
-- Name: daysoff_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "daysoff_created_trigger" BEFORE INSERT ON "daysoff"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 255 (OID 3612480)
--
-- Name: daysoff_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "daysoff_modified_trigger" BEFORE UPDATE ON "daysoff"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 256 (OID 3612481)
--
-- Name: donation_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "donation_created_trigger" BEFORE INSERT ON "donation"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 257 (OID 3612482)
--
-- Name: donation_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "donation_modified_trigger" BEFORE UPDATE ON "donation"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 270 (OID 3612483)
--
-- Name: gizmo_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "gizmo_created_trigger" BEFORE INSERT ON "gizmo"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 271 (OID 3612484)
--
-- Name: gizmo_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "gizmo_modified_trigger" BEFORE UPDATE ON "gizmo"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 284 (OID 3612485)
--
-- Name: gizmoclones_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "gizmoclones_created_trigger" BEFORE INSERT ON "gizmoclones"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 285 (OID 3612486)
--
-- Name: gizmoclones_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "gizmoclones_modified_trigger" BEFORE UPDATE ON "gizmoclones"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 286 (OID 3612487)
--
-- Name: holidays_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "holidays_created_trigger" BEFORE INSERT ON "holidays"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 287 (OID 3612488)
--
-- Name: holidays_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "holidays_modified_trigger" BEFORE UPDATE ON "holidays"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 289 (OID 3612489)
--
-- Name: income_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "income_created_trigger" BEFORE INSERT ON "income"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 290 (OID 3612490)
--
-- Name: income_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "income_modified_trigger" BEFORE UPDATE ON "income"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 291 (OID 3612491)
--
-- Name: issuenotes_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "issuenotes_created_trigger" BEFORE INSERT ON "issuenotes"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 292 (OID 3612492)
--
-- Name: issuenotes_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "issuenotes_modified_trigger" BEFORE UPDATE ON "issuenotes"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 293 (OID 3612493)
--
-- Name: issues_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "issues_created_trigger" BEFORE INSERT ON "issues"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 294 (OID 3612494)
--
-- Name: issues_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "issues_modified_trigger" BEFORE UPDATE ON "issues"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 295 (OID 3612495)
--
-- Name: jobs_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "jobs_created_trigger" BEFORE INSERT ON "jobs"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 296 (OID 3612496)
--
-- Name: jobs_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "jobs_modified_trigger" BEFORE UPDATE ON "jobs"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 298 (OID 3612497)
--
-- Name: materials_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "materials_created_trigger" BEFORE INSERT ON "materials"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 299 (OID 3612498)
--
-- Name: materials_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "materials_modified_trigger" BEFORE UPDATE ON "materials"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 300 (OID 3612499)
--
-- Name: member_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "member_created_trigger" BEFORE INSERT ON "member"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 301 (OID 3612500)
--
-- Name: member_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "member_modified_trigger" BEFORE UPDATE ON "member"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 302 (OID 3612501)
--
-- Name: memberhour_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "memberhour_created_trigger" BEFORE INSERT ON "memberhour"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 303 (OID 3612502)
--
-- Name: memberhour_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "memberhour_modified_trigger" BEFORE UPDATE ON "memberhour"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 312 (OID 3612503)
--
-- Name: organization_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "organization_created_trigger" BEFORE INSERT ON "organization"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 313 (OID 3612504)
--
-- Name: organization_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "organization_modified_trigger" BEFORE UPDATE ON "organization"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 314 (OID 3612505)
--
-- Name: pages_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "pages_created_trigger" BEFORE INSERT ON "pages"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 315 (OID 3612506)
--
-- Name: pages_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "pages_modified_trigger" BEFORE UPDATE ON "pages"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 316 (OID 3612507)
--
-- Name: pickuplines_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "pickuplines_created_trigger" BEFORE INSERT ON "pickuplines"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 317 (OID 3612508)
--
-- Name: pickuplines_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "pickuplines_modified_trigger" BEFORE UPDATE ON "pickuplines"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 318 (OID 3612509)
--
-- Name: pickups_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "pickups_created_trigger" BEFORE INSERT ON "pickups"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 319 (OID 3612510)
--
-- Name: pickups_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "pickups_modified_trigger" BEFORE UPDATE ON "pickups"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 325 (OID 3612511)
--
-- Name: sales_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "sales_created_trigger" BEFORE INSERT ON "sales"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 326 (OID 3612512)
--
-- Name: sales_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "sales_modified_trigger" BEFORE UPDATE ON "sales"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 328 (OID 3612513)
--
-- Name: scratchpad_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "scratchpad_created_trigger" BEFORE INSERT ON "scratchpad"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 329 (OID 3612514)
--
-- Name: scratchpad_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "scratchpad_modified_trigger" BEFORE UPDATE ON "scratchpad"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 336 (OID 3612515)
--
-- Name: unit2material_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "unit2material_created_trigger" BEFORE INSERT ON "unit2material"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 337 (OID 3612516)
--
-- Name: unit2material_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "unit2material_modified_trigger" BEFORE UPDATE ON "unit2material"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 339 (OID 3612517)
--
-- Name: workmonths_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "workmonths_created_trigger" BEFORE INSERT ON "workmonths"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 340 (OID 3612518)
--
-- Name: workmonths_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "workmonths_modified_trigger" BEFORE UPDATE ON "workmonths"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 341 (OID 3612519)
--
-- Name: workers_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "workers_created_trigger" BEFORE INSERT ON "workers"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 342 (OID 3612520)
--
-- Name: workers_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "workers_modified_trigger" BEFORE UPDATE ON "workers"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 343 (OID 3612521)
--
-- Name: workersqualifyforjobs_created_t Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "workersqualifyforjobs_created_t" BEFORE INSERT ON "workersqualifyforjobs"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 344 (OID 3612522)
--
-- Name: workersqualifyforjobs_modified_ Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "workersqualifyforjobs_modified_" BEFORE UPDATE ON "workersqualifyforjobs"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 345 (OID 3612523)
--
-- Name: codedinfo_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "codedinfo_created_trigger" BEFORE INSERT ON "codedinfo"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 346 (OID 3612524)
--
-- Name: codedinfo_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "codedinfo_modified_trigger" BEFORE UPDATE ON "codedinfo"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 348 (OID 3612525)
--
-- Name: weeklyshifts_created_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "weeklyshifts_created_trigger" BEFORE INSERT ON "weeklyshifts"  FOR EACH ROW EXECUTE PROCEDURE "created_trigger" ();

--
-- TOC Entry ID 349 (OID 3612526)
--
-- Name: weeklyshifts_modified_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "weeklyshifts_modified_trigger" BEFORE UPDATE ON "weeklyshifts"  FOR EACH ROW EXECUTE PROCEDURE "modified_trigger" ();

--
-- TOC Entry ID 273 (OID 3641302)
--
-- Name: gizmo_status_change_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "gizmo_status_change_trigger" BEFORE UPDATE ON "gizmo"  FOR EACH ROW EXECUTE PROCEDURE "gizmo_status_changed" ();

--
-- TOC Entry ID 274 (OID 3641303)
--
-- Name: gizmo_status_insert_trigger Type: TRIGGER Owner: fgdb
--

CREATE TRIGGER "gizmo_status_insert_trigger" BEFORE INSERT ON "gizmo"  FOR EACH ROW EXECUTE PROCEDURE "gizmo_status_insert" ();

--
-- TOC Entry ID 224 (OID 3660954)
--
-- Name: "RI_ConstraintTrigger_3660953" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "component_gizmo_fk" AFTER INSERT OR UPDATE ON "component"  FROM "gizmo" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('component_gizmo_fk', 'component', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 272 (OID 3660956)
--
-- Name: "RI_ConstraintTrigger_3660955" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "component_gizmo_fk" AFTER DELETE ON "gizmo"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('component_gizmo_fk', 'component', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 275 (OID 3660958)
--
-- Name: "RI_ConstraintTrigger_3660957" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "component_gizmo_fk" AFTER UPDATE ON "gizmo"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('component_gizmo_fk', 'component', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 209 (OID 3660960)
--
-- Name: "RI_ConstraintTrigger_3660959" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "card_component_fk" AFTER INSERT OR UPDATE ON "card"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('card_component_fk', 'card', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 225 (OID 3660962)
--
-- Name: "RI_ConstraintTrigger_3660961" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "card_component_fk" AFTER DELETE ON "component"  FROM "card" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('card_component_fk', 'card', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 226 (OID 3660964)
--
-- Name: "RI_ConstraintTrigger_3660963" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "card_component_fk" AFTER UPDATE ON "component"  FROM "card" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('card_component_fk', 'card', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 304 (OID 3660966)
--
-- Name: "RI_ConstraintTrigger_3660965" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "misccard_card_fk" AFTER INSERT OR UPDATE ON "misccard"  FROM "card" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('misccard_card_fk', 'misccard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 210 (OID 3660968)
--
-- Name: "RI_ConstraintTrigger_3660967" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "misccard_card_fk" AFTER DELETE ON "card"  FROM "misccard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('misccard_card_fk', 'misccard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 211 (OID 3660970)
--
-- Name: "RI_ConstraintTrigger_3660969" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "misccard_card_fk" AFTER UPDATE ON "card"  FROM "misccard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('misccard_card_fk', 'misccard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 309 (OID 3660972)
--
-- Name: "RI_ConstraintTrigger_3660971" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "modemcard_card_fk" AFTER INSERT OR UPDATE ON "modemcard"  FROM "card" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('modemcard_card_fk', 'modemcard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 212 (OID 3660974)
--
-- Name: "RI_ConstraintTrigger_3660973" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "modemcard_card_fk" AFTER DELETE ON "card"  FROM "modemcard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('modemcard_card_fk', 'modemcard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 213 (OID 3660976)
--
-- Name: "RI_ConstraintTrigger_3660975" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "modemcard_card_fk" AFTER UPDATE ON "card"  FROM "modemcard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('modemcard_card_fk', 'modemcard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 311 (OID 3660978)
--
-- Name: "RI_ConstraintTrigger_3660977" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "networkcard_card_fk" AFTER INSERT OR UPDATE ON "networkcard"  FROM "card" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('networkcard_card_fk', 'networkcard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 214 (OID 3660980)
--
-- Name: "RI_ConstraintTrigger_3660979" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "networkcard_card_fk" AFTER DELETE ON "card"  FROM "networkcard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('networkcard_card_fk', 'networkcard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 215 (OID 3660982)
--
-- Name: "RI_ConstraintTrigger_3660981" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "networkcard_card_fk" AFTER UPDATE ON "card"  FROM "networkcard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('networkcard_card_fk', 'networkcard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 323 (OID 3660984)
--
-- Name: "RI_ConstraintTrigger_3660983" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "scsicard_card_fk" AFTER INSERT OR UPDATE ON "scsicard"  FROM "card" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('scsicard_card_fk', 'scsicard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 216 (OID 3660986)
--
-- Name: "RI_ConstraintTrigger_3660985" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "scsicard_card_fk" AFTER DELETE ON "card"  FROM "scsicard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('scsicard_card_fk', 'scsicard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 217 (OID 3660988)
--
-- Name: "RI_ConstraintTrigger_3660987" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "scsicard_card_fk" AFTER UPDATE ON "card"  FROM "scsicard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('scsicard_card_fk', 'scsicard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 330 (OID 3660990)
--
-- Name: "RI_ConstraintTrigger_3660989" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "soundcard_card_fk" AFTER INSERT OR UPDATE ON "soundcard"  FROM "card" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('soundcard_card_fk', 'soundcard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 218 (OID 3660992)
--
-- Name: "RI_ConstraintTrigger_3660991" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "soundcard_card_fk" AFTER DELETE ON "card"  FROM "soundcard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('soundcard_card_fk', 'soundcard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 219 (OID 3660994)
--
-- Name: "RI_ConstraintTrigger_3660993" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "soundcard_card_fk" AFTER UPDATE ON "card"  FROM "soundcard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('soundcard_card_fk', 'soundcard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 338 (OID 3660996)
--
-- Name: "RI_ConstraintTrigger_3660995" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "videocard_card_fk" AFTER INSERT OR UPDATE ON "videocard"  FROM "card" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('videocard_card_fk', 'videocard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 220 (OID 3660998)
--
-- Name: "RI_ConstraintTrigger_3660997" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "videocard_card_fk" AFTER DELETE ON "card"  FROM "videocard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('videocard_card_fk', 'videocard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 221 (OID 3661000)
--
-- Name: "RI_ConstraintTrigger_3660999" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "videocard_card_fk" AFTER UPDATE ON "card"  FROM "videocard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('videocard_card_fk', 'videocard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 253 (OID 3661002)
--
-- Name: "RI_ConstraintTrigger_3661001" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "controllercard_card_fk" AFTER INSERT OR UPDATE ON "controllercard"  FROM "card" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('controllercard_card_fk', 'controllercard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 222 (OID 3661004)
--
-- Name: "RI_ConstraintTrigger_3661003" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "controllercard_card_fk" AFTER DELETE ON "card"  FROM "controllercard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('controllercard_card_fk', 'controllercard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 223 (OID 3661006)
--
-- Name: "RI_ConstraintTrigger_3661005" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "controllercard_card_fk" AFTER UPDATE ON "card"  FROM "controllercard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('controllercard_card_fk', 'controllercard', 'card', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 258 (OID 3661008)
--
-- Name: "RI_ConstraintTrigger_3661007" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "drive_gizmo_fk" AFTER INSERT OR UPDATE ON "drive"  FROM "gizmo" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('drive_gizmo_fk', 'drive', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 276 (OID 3661010)
--
-- Name: "RI_ConstraintTrigger_3661009" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "drive_gizmo_fk" AFTER DELETE ON "gizmo"  FROM "drive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('drive_gizmo_fk', 'drive', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 277 (OID 3661012)
--
-- Name: "RI_ConstraintTrigger_3661011" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "drive_gizmo_fk" AFTER UPDATE ON "gizmo"  FROM "drive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('drive_gizmo_fk', 'drive', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 269 (OID 3661014)
--
-- Name: "RI_ConstraintTrigger_3661013" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "floppydrive_drive_fk" AFTER INSERT OR UPDATE ON "floppydrive"  FROM "drive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('floppydrive_drive_fk', 'floppydrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 259 (OID 3661016)
--
-- Name: "RI_ConstraintTrigger_3661015" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "floppydrive_drive_fk" AFTER DELETE ON "drive"  FROM "floppydrive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('floppydrive_drive_fk', 'floppydrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 260 (OID 3661018)
--
-- Name: "RI_ConstraintTrigger_3661017" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "floppydrive_drive_fk" AFTER UPDATE ON "drive"  FROM "floppydrive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('floppydrive_drive_fk', 'floppydrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 288 (OID 3661020)
--
-- Name: "RI_ConstraintTrigger_3661019" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "ideharddrive_drive_fk" AFTER INSERT OR UPDATE ON "ideharddrive"  FROM "drive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('ideharddrive_drive_fk', 'ideharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 261 (OID 3661022)
--
-- Name: "RI_ConstraintTrigger_3661021" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "ideharddrive_drive_fk" AFTER DELETE ON "drive"  FROM "ideharddrive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('ideharddrive_drive_fk', 'ideharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 262 (OID 3661024)
--
-- Name: "RI_ConstraintTrigger_3661023" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "ideharddrive_drive_fk" AFTER UPDATE ON "drive"  FROM "ideharddrive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('ideharddrive_drive_fk', 'ideharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 306 (OID 3661026)
--
-- Name: "RI_ConstraintTrigger_3661025" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "miscdrive_drive_fk" AFTER INSERT OR UPDATE ON "miscdrive"  FROM "drive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('miscdrive_drive_fk', 'miscdrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 263 (OID 3661028)
--
-- Name: "RI_ConstraintTrigger_3661027" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "miscdrive_drive_fk" AFTER DELETE ON "drive"  FROM "miscdrive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('miscdrive_drive_fk', 'miscdrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 264 (OID 3661030)
--
-- Name: "RI_ConstraintTrigger_3661029" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "miscdrive_drive_fk" AFTER UPDATE ON "drive"  FROM "miscdrive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('miscdrive_drive_fk', 'miscdrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 324 (OID 3661032)
--
-- Name: "RI_ConstraintTrigger_3661031" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "scsiharddrive_drive_fk" AFTER INSERT OR UPDATE ON "scsiharddrive"  FROM "drive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('scsiharddrive_drive_fk', 'scsiharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 265 (OID 3661034)
--
-- Name: "RI_ConstraintTrigger_3661033" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "scsiharddrive_drive_fk" AFTER DELETE ON "drive"  FROM "scsiharddrive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('scsiharddrive_drive_fk', 'scsiharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 266 (OID 3661036)
--
-- Name: "RI_ConstraintTrigger_3661035" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "scsiharddrive_drive_fk" AFTER UPDATE ON "drive"  FROM "scsiharddrive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('scsiharddrive_drive_fk', 'scsiharddrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 335 (OID 3661038)
--
-- Name: "RI_ConstraintTrigger_3661037" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "tapedrive_drive_fk" AFTER INSERT OR UPDATE ON "tapedrive"  FROM "drive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('tapedrive_drive_fk', 'tapedrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 267 (OID 3661040)
--
-- Name: "RI_ConstraintTrigger_3661039" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "tapedrive_drive_fk" AFTER DELETE ON "drive"  FROM "tapedrive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('tapedrive_drive_fk', 'tapedrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 268 (OID 3661042)
--
-- Name: "RI_ConstraintTrigger_3661041" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "tapedrive_drive_fk" AFTER UPDATE ON "drive"  FROM "tapedrive" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('tapedrive_drive_fk', 'tapedrive', 'drive', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 297 (OID 3661044)
--
-- Name: "RI_ConstraintTrigger_3661043" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "keyboard_component_fk" AFTER INSERT OR UPDATE ON "keyboard"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('keyboard_component_fk', 'keyboard', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 227 (OID 3661046)
--
-- Name: "RI_ConstraintTrigger_3661045" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "keyboard_component_fk" AFTER DELETE ON "component"  FROM "keyboard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('keyboard_component_fk', 'keyboard', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 228 (OID 3661048)
--
-- Name: "RI_ConstraintTrigger_3661047" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "keyboard_component_fk" AFTER UPDATE ON "component"  FROM "keyboard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('keyboard_component_fk', 'keyboard', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 305 (OID 3661050)
--
-- Name: "RI_ConstraintTrigger_3661049" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "misccompponent_component_fk" AFTER INSERT OR UPDATE ON "misccomponent"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('misccompponent_component_fk', 'misccomponent', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 229 (OID 3661052)
--
-- Name: "RI_ConstraintTrigger_3661051" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "misccompponent_component_fk" AFTER DELETE ON "component"  FROM "misccomponent" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('misccompponent_component_fk', 'misccomponent', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 230 (OID 3661054)
--
-- Name: "RI_ConstraintTrigger_3661053" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "misccompponent_component_fk" AFTER UPDATE ON "component"  FROM "misccomponent" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('misccompponent_component_fk', 'misccomponent', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 308 (OID 3661056)
--
-- Name: "RI_ConstraintTrigger_3661055" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "modem_component_fk" AFTER INSERT OR UPDATE ON "modem"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('modem_component_fk', 'modem', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 231 (OID 3661058)
--
-- Name: "RI_ConstraintTrigger_3661057" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "modem_component_fk" AFTER DELETE ON "component"  FROM "modem" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('modem_component_fk', 'modem', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 232 (OID 3661060)
--
-- Name: "RI_ConstraintTrigger_3661059" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "modem_component_fk" AFTER UPDATE ON "component"  FROM "modem" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('modem_component_fk', 'modem', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 310 (OID 3661062)
--
-- Name: "RI_ConstraintTrigger_3661061" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "monitor_component_fk" AFTER INSERT OR UPDATE ON "monitor"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('monitor_component_fk', 'monitor', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 233 (OID 3661064)
--
-- Name: "RI_ConstraintTrigger_3661063" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "monitor_component_fk" AFTER DELETE ON "component"  FROM "monitor" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('monitor_component_fk', 'monitor', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 234 (OID 3661066)
--
-- Name: "RI_ConstraintTrigger_3661065" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "monitor_component_fk" AFTER UPDATE ON "component"  FROM "monitor" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('monitor_component_fk', 'monitor', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 320 (OID 3661068)
--
-- Name: "RI_ConstraintTrigger_3661067" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "pointingdevice_component_fk" AFTER INSERT OR UPDATE ON "pointingdevice"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('pointingdevice_component_fk', 'pointingdevice', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 235 (OID 3661070)
--
-- Name: "RI_ConstraintTrigger_3661069" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "pointingdevice_component_fk" AFTER DELETE ON "component"  FROM "pointingdevice" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('pointingdevice_component_fk', 'pointingdevice', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 236 (OID 3661072)
--
-- Name: "RI_ConstraintTrigger_3661071" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "pointingdevice_component_fk" AFTER UPDATE ON "component"  FROM "pointingdevice" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('pointingdevice_component_fk', 'pointingdevice', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 321 (OID 3661074)
--
-- Name: "RI_ConstraintTrigger_3661073" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "powersupply_component_fk" AFTER INSERT OR UPDATE ON "powersupply"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('powersupply_component_fk', 'powersupply', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 237 (OID 3661076)
--
-- Name: "RI_ConstraintTrigger_3661075" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "powersupply_component_fk" AFTER DELETE ON "component"  FROM "powersupply" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('powersupply_component_fk', 'powersupply', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 238 (OID 3661078)
--
-- Name: "RI_ConstraintTrigger_3661077" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "powersupply_component_fk" AFTER UPDATE ON "component"  FROM "powersupply" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('powersupply_component_fk', 'powersupply', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 347 (OID 3661080)
--
-- Name: "RI_ConstraintTrigger_3661079" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "printer_component_fk" AFTER INSERT OR UPDATE ON "printer"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('printer_component_fk', 'printer', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 239 (OID 3661082)
--
-- Name: "RI_ConstraintTrigger_3661081" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "printer_component_fk" AFTER DELETE ON "component"  FROM "printer" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('printer_component_fk', 'printer', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 240 (OID 3661084)
--
-- Name: "RI_ConstraintTrigger_3661083" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "printer_component_fk" AFTER UPDATE ON "component"  FROM "printer" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('printer_component_fk', 'printer', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 322 (OID 3661086)
--
-- Name: "RI_ConstraintTrigger_3661085" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "processor_component_fk" AFTER INSERT OR UPDATE ON "processor"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('processor_component_fk', 'processor', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 241 (OID 3661088)
--
-- Name: "RI_ConstraintTrigger_3661087" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "processor_component_fk" AFTER DELETE ON "component"  FROM "processor" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('processor_component_fk', 'processor', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 242 (OID 3661090)
--
-- Name: "RI_ConstraintTrigger_3661089" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "processor_component_fk" AFTER UPDATE ON "component"  FROM "processor" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('processor_component_fk', 'processor', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 327 (OID 3661092)
--
-- Name: "RI_ConstraintTrigger_3661091" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "scanner_component_fk" AFTER INSERT OR UPDATE ON "scanner"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('scanner_component_fk', 'scanner', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 243 (OID 3661094)
--
-- Name: "RI_ConstraintTrigger_3661093" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "scanner_component_fk" AFTER DELETE ON "component"  FROM "scanner" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('scanner_component_fk', 'scanner', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 244 (OID 3661096)
--
-- Name: "RI_ConstraintTrigger_3661095" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "scanner_component_fk" AFTER UPDATE ON "component"  FROM "scanner" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('scanner_component_fk', 'scanner', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 331 (OID 3661098)
--
-- Name: "RI_ConstraintTrigger_3661097" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "speaker_component_fk" AFTER INSERT OR UPDATE ON "speaker"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('speaker_component_fk', 'speaker', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 245 (OID 3661100)
--
-- Name: "RI_ConstraintTrigger_3661099" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "speaker_component_fk" AFTER DELETE ON "component"  FROM "speaker" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('speaker_component_fk', 'speaker', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 246 (OID 3661102)
--
-- Name: "RI_ConstraintTrigger_3661101" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "speaker_component_fk" AFTER UPDATE ON "component"  FROM "speaker" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('speaker_component_fk', 'speaker', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 333 (OID 3661104)
--
-- Name: "RI_ConstraintTrigger_3661103" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "systemboard_component_fk" AFTER INSERT OR UPDATE ON "systemboard"  FROM "component" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('systemboard_component_fk', 'systemboard', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 247 (OID 3661106)
--
-- Name: "RI_ConstraintTrigger_3661105" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "systemboard_component_fk" AFTER DELETE ON "component"  FROM "systemboard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('systemboard_component_fk', 'systemboard', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 248 (OID 3661108)
--
-- Name: "RI_ConstraintTrigger_3661107" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "systemboard_component_fk" AFTER UPDATE ON "component"  FROM "systemboard" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('systemboard_component_fk', 'systemboard', 'component', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 307 (OID 3661110)
--
-- Name: "RI_ConstraintTrigger_3661109" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "miscgizmo_gizmo_fk" AFTER INSERT OR UPDATE ON "miscgizmo"  FROM "gizmo" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('miscgizmo_gizmo_fk', 'miscgizmo', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 278 (OID 3661112)
--
-- Name: "RI_ConstraintTrigger_3661111" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "miscgizmo_gizmo_fk" AFTER DELETE ON "gizmo"  FROM "miscgizmo" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('miscgizmo_gizmo_fk', 'miscgizmo', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 279 (OID 3661114)
--
-- Name: "RI_ConstraintTrigger_3661113" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "miscgizmo_gizmo_fk" AFTER UPDATE ON "gizmo"  FROM "miscgizmo" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('miscgizmo_gizmo_fk', 'miscgizmo', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 332 (OID 3661116)
--
-- Name: "RI_ConstraintTrigger_3661115" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "system_gizmo_fk" AFTER INSERT OR UPDATE ON "system"  FROM "gizmo" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('system_gizmo_fk', 'system', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 280 (OID 3661118)
--
-- Name: "RI_ConstraintTrigger_3661117" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "system_gizmo_fk" AFTER DELETE ON "gizmo"  FROM "system" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('system_gizmo_fk', 'system', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 281 (OID 3661120)
--
-- Name: "RI_ConstraintTrigger_3661119" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "system_gizmo_fk" AFTER UPDATE ON "gizmo"  FROM "system" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('system_gizmo_fk', 'system', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 334 (OID 3661122)
--
-- Name: "RI_ConstraintTrigger_3661121" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "systemcase_gizmo_fk" AFTER INSERT OR UPDATE ON "systemcase"  FROM "gizmo" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_check_ins" ('systemcase_gizmo_fk', 'systemcase', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 282 (OID 3661124)
--
-- Name: "RI_ConstraintTrigger_3661123" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "systemcase_gizmo_fk" AFTER DELETE ON "gizmo"  FROM "systemcase" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_del" ('systemcase_gizmo_fk', 'systemcase', 'gizmo', 'UNSPECIFIED', 'id', 'id');

--
-- TOC Entry ID 283 (OID 3661126)
--
-- Name: "RI_ConstraintTrigger_3661125" Type: TRIGGER Owner: fgdb
--

CREATE CONSTRAINT TRIGGER "systemcase_gizmo_fk" AFTER UPDATE ON "gizmo"  FROM "systemcase" NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE "RI_FKey_noaction_upd" ('systemcase_gizmo_fk', 'systemcase', 'gizmo', 'UNSPECIFIED', 'id', 'id');

