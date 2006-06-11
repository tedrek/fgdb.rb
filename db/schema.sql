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


SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: cards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE cards (
    id integer DEFAULT 0 NOT NULL,
    slot_type character varying(10)
);


--
-- Name: cd_drives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE cd_drives (
    id integer DEFAULT 0 NOT NULL,
    interface character varying(10) DEFAULT ''::character varying,
    speed character varying(10) DEFAULT ''::character varying,
    write_mode character varying(15) DEFAULT ''::character varying,
    scsi boolean DEFAULT false,
    spin_rate integer
);


--
-- Name: cell_phones; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE cell_phones (
    id integer DEFAULT 0 NOT NULL
);


--
-- Name: class_trees; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE class_trees (
    id integer DEFAULT nextval('class_trees_id_seq'::text) NOT NULL,
    class_tree character varying(100),
    table_name character varying(50),
    "level" integer,
    instantiable boolean DEFAULT true,
    intake_code character varying(10),
    intake_add integer,
    description character varying(50)
);


--
-- Name: class_trees_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE class_trees_id_seq
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
    system_id integer DEFAULT 0 NOT NULL
);


--
-- Name: controller_cards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE controller_cards (
    id integer DEFAULT 0 NOT NULL,
    serial_ports integer DEFAULT 0 NOT NULL,
    parallel_ports integer DEFAULT 0 NOT NULL,
    ide_ports integer DEFAULT 0 NOT NULL,
    floppy boolean DEFAULT true
);


--
-- Name: default_values; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE default_values (
    id integer DEFAULT nextval('default_values_id_seq'::text) NOT NULL,
    class_tree character varying(100),
    field_name character varying(50),
    default_value character varying(50)
);


--
-- Name: default_values_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE default_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: drives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE drives (
    id integer DEFAULT 0 NOT NULL
);


--
-- Name: floppy_drives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE floppy_drives (
    id integer DEFAULT 0 NOT NULL,
    disk_size character varying(10),
    capacity character varying(10),
    cylinders integer DEFAULT 0,
    heads integer DEFAULT 0,
    sectors integer DEFAULT 0
);


--
-- Name: gizmo_clones; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE gizmo_clones (
    id integer DEFAULT nextval('Gizmo_Clones_id_seq'::text) NOT NULL,
    parent_id integer DEFAULT 0 NOT NULL,
    child_id integer DEFAULT 0 NOT NULL,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now()
);


--
-- Name: gizmo_clones_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE gizmo_clones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gizmo_status_changes; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE gizmo_status_changes (
    id integer DEFAULT 0 NOT NULL,
    old_status character varying(15),
    new_status character varying(15),
    created timestamp with time zone DEFAULT now(),
    change_id integer DEFAULT nextval('Gizmo_Status_Changes_change_id_se'::text) NOT NULL
);


--
-- Name: gizmo_status_changes_change_id_se; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE gizmo_status_changes_change_id_se
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


--
-- Name: gizmo_statuses; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE gizmo_statuses (
    id integer DEFAULT nextval('gizmo_statuses_id_seq'::text) NOT NULL,
    old_status character varying(15),
    new_status character varying(15)
);


--
-- Name: gizmo_statuses_id_seq; Type: SEQUENCE; Schema: public; Owner: stillflame
--

CREATE SEQUENCE gizmo_statuses_id_seq
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
    gizmo_status_id integer,
    class_tree_id integer,
    modified timestamp with time zone DEFAULT now(),
    created timestamp with time zone DEFAULT now() --,
--     obsolete boolean DEFAULT false,
--     working character varying(1) DEFAULT 'M'::character varying NOT NULL,
--     architecture character varying(10) DEFAULT 'PC'::character varying NOT NULL,
--     manufacturer character varying(50),
--     model_number character varying(50),
--     "location" character varying(10) DEFAULT 'Free Geek'::character varying NOT NULL,
--     notes text,
--     value numeric(5,1) DEFAULT 0.0 NOT NULL,
--     inventoried timestamp with time zone DEFAULT now(),
--     builder_id integer DEFAULT 0 NOT NULL,
--     inspector_id integer DEFAULT 0 NOT NULL,
--     linux_fund boolean DEFAULT false,
--     cash_value numeric(8,2) DEFAULT 0.00 NOT NULL,
--     needs_expert_attention boolean DEFAULT false,
--     gizmo_type character varying(10) DEFAULT 'Other'::character varying,
--     adopter_id integer DEFAULT 0 NOT NULL,
--     CONSTRAINT gizmos_working CHECK (((((working)::text = ('N'::character varying)::text) OR ((working)::text = ('Y'::character varying)::text)) OR ((working)::text = ('M'::character varying)::text)))
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
-- Name: ide_hard_drives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE ide_hard_drives (
    id integer DEFAULT 0 NOT NULL,
    cylinders integer DEFAULT 0 NOT NULL,
    heads integer DEFAULT 0 NOT NULL,
    sectors integer DEFAULT 0 NOT NULL,
    ata character varying(10),
    size integer DEFAULT 0 NOT NULL
);


--
-- Name: keyboards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE keyboards (
    id integer DEFAULT 0 NOT NULL,
    connector_type character varying(10),
    number_of_keys character varying(10)
);


--
-- Name: laptops; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE laptops (
    id integer DEFAULT 0 NOT NULL,
    ram integer,
    hard_drives_size integer DEFAULT 0,
    processor_class character varying(15),
    processor_speed integer DEFAULT 0 NOT NULL
);


--
-- Name: misc_cards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE misc_cards (
    id integer DEFAULT 0 NOT NULL,
    misc_notes text
);


--
-- Name: misc_components; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE misc_components (
    id integer DEFAULT 0 NOT NULL,
    misc_notes text
);


--
-- Name: misc_drives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE misc_drives (
    id integer DEFAULT 0 NOT NULL,
    misc_notes text
);


--
-- Name: misc_gizmos; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE misc_gizmos (
    id integer DEFAULT 0 NOT NULL
);


--
-- Name: modem_cards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE modem_cards (
    id integer DEFAULT 0 NOT NULL,
    speed character varying(15)
);


--
-- Name: modems; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE modems (
    id integer DEFAULT 0 NOT NULL,
    speed character varying(15)
);


--
-- Name: monitors; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE monitors (
    id integer DEFAULT 0 NOT NULL,
    size character varying(10),
    resolution character varying(10)
);


--
-- Name: network_cards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE network_cards (
    id integer DEFAULT 0 NOT NULL,
    speed character varying(10),
    rj45 boolean DEFAULT false,
    aux boolean DEFAULT false,
    bnc boolean DEFAULT false,
    thicknet boolean DEFAULT false,
    module character varying(50),
    io character varying(10),
    irq character varying(2)
);


--
-- Name: networking_devices; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE networking_devices (
    id integer DEFAULT 0 NOT NULL,
    speed character varying(10),
    rj45 boolean DEFAULT false,
    aux boolean DEFAULT false,
    bnc boolean DEFAULT false,
    thicknet boolean DEFAULT false
);


--
-- Name: pointing_devices; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE pointing_devices (
    id integer DEFAULT 0 NOT NULL,
    connector_type character varying(10),
    pointer_type character varying(10)
);


--
-- Name: power_supplies; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE power_supplies (
    id integer DEFAULT 0 NOT NULL,
    watts integer DEFAULT 0 NOT NULL,
    connection character varying(10)
);


--
-- Name: printers; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE printers (
    id integer DEFAULT 0 NOT NULL,
    page_per_minute integer DEFAULT 0 NOT NULL,
    printer_type character varying(10),
    interface character varying(10) DEFAULT 'Parallel'::character varying
);


--
-- Name: processors; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE processors (
    id integer DEFAULT 0 NOT NULL,
    "class" character varying(15),
    interface character varying(10),
    speed integer DEFAULT 0 NOT NULL
);


--
-- Name: scanners; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE scanners (
    id integer DEFAULT 0 NOT NULL,
    interface character varying(10)
);


--
-- Name: scsi_cards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE scsi_cards (
    id integer DEFAULT 0 NOT NULL,
    internal_interface character varying(15),
    external_interface character varying(15),
    parms text
);


--
-- Name: scsi_hard_drives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE scsi_hard_drives (
    id integer DEFAULT 0 NOT NULL,
    size integer DEFAULT 0 NOT NULL,
    scsi_version character varying(10)
);


--
-- Name: sound_cards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE sound_cards (
    id integer DEFAULT 0 NOT NULL,
    sound_type character varying(15)
);


--
-- Name: speakers; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE speakers (
    id integer DEFAULT 0 NOT NULL,
    powered boolean DEFAULT false,
    subwoofer boolean DEFAULT false
);


--
-- Name: stereos; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE stereos (
    id integer DEFAULT 0 NOT NULL
);


--
-- Name: system_boards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE system_boards (
    id integer DEFAULT 0 NOT NULL,
    pci_slots integer DEFAULT 0 NOT NULL,
    vesa_slots integer DEFAULT 0 NOT NULL,
    isa_slots integer DEFAULT 0 NOT NULL,
    eisa_slots integer DEFAULT 0 NOT NULL,
    agp_slot boolean DEFAULT false,
    simms integer DEFAULT 0 NOT NULL,
    sdram integer DEFAULT 0 NOT NULL,
    ddr integer DEFAULT 0 NOT NULL,
    rambus integer DEFAULT 0 NOT NULL,
    frontside_bus_speed character varying(10),
    processor_socket integer DEFAULT 0 NOT NULL,
    processor_slot integer DEFAULT 0 NOT NULL
);


--
-- Name: system_cases; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE system_cases (
    id integer DEFAULT 0 NOT NULL,
    case_type character varying(10)
);


--
-- Name: systems; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE systems (
    id integer DEFAULT 0 NOT NULL,
    system_configuration text,
    system_boards text,
    adapter_information text,
    multi_processor_information text,
    display_details text,
    display_information text,
    scsi_information text,
    pcmcia_information text,
    modem_information text,
    multimedia_information text,
    plug_n_play_information text,
    physical_drivess text,
    ram integer,
    video_ram integer,
    size integer,
    scsi boolean DEFAULT false,
    processor_class character varying(15),
    processor_speed integer DEFAULT 0 NOT NULL
);


--
-- Name: tape_drives; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE tape_drives (
    id integer DEFAULT 0 NOT NULL,
    interface character varying(15)
);


--
-- Name: upses; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE upses (
    id integer DEFAULT 0 NOT NULL,
    rj11 boolean DEFAULT false,
    rj45 boolean DEFAULT false,
    usb boolean DEFAULT false,
    serial boolean DEFAULT false,
    va character varying(5),
    supported_outlets integer,
    unsupported_outlets integer
);


--
-- Name: vcrs; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE vcrs (
    id integer DEFAULT 0 NOT NULL
);


--
-- Name: video_cards; Type: TABLE; Schema: public; Owner: stillflame; Tablespace: 
--

CREATE TABLE video_cards (
    id integer DEFAULT 0 NOT NULL,
    memory character varying(10),
    resolutions text
);


--
-- Name: cards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (id);


--
-- Name: cd_drives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY cd_drives
    ADD CONSTRAINT cd_drives_pkey PRIMARY KEY (id);


--
-- Name: cell_phones_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY cell_phones
    ADD CONSTRAINT cell_phones_pkey PRIMARY KEY (id);


--
-- Name: class_trees_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY class_trees
    ADD CONSTRAINT class_trees_pkey PRIMARY KEY (id);


--
-- Name: components_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY components
    ADD CONSTRAINT components_pkey PRIMARY KEY (id);


--
-- Name: controller_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY controller_cards
    ADD CONSTRAINT controller_cards_pkey PRIMARY KEY (id);


--
-- Name: default_values_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY default_values
    ADD CONSTRAINT default_values_pkey PRIMARY KEY (id);


--
-- Name: drives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY drives
    ADD CONSTRAINT drives_pkey PRIMARY KEY (id);


--
-- Name: floppy_drives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY floppy_drives
    ADD CONSTRAINT floppy_drives_pkey PRIMARY KEY (id);


--
-- Name: gizmo_clones_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY gizmo_clones
    ADD CONSTRAINT gizmo_clones_pkey PRIMARY KEY (id);


--
-- Name: gizmo_status_changes_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY gizmo_status_changes
    ADD CONSTRAINT gizmo_status_changes_pkey PRIMARY KEY (change_id);


--
-- Name: gizmo_statuses_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY gizmo_statuses
    ADD CONSTRAINT gizmo_statuses_pkey PRIMARY KEY (id);


--
-- Name: gizmos_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY gizmos
    ADD CONSTRAINT gizmos_pkey PRIMARY KEY (id);


--
-- Name: ide_hard_drives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY ide_hard_drives
    ADD CONSTRAINT ide_hard_drives_pkey PRIMARY KEY (id);


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
-- Name: misc_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY misc_cards
    ADD CONSTRAINT misc_cards_pkey PRIMARY KEY (id);


--
-- Name: misc_components_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY misc_components
    ADD CONSTRAINT misc_components_pkey PRIMARY KEY (id);


--
-- Name: misc_drives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY misc_drives
    ADD CONSTRAINT misc_drives_pkey PRIMARY KEY (id);


--
-- Name: misc_gizmos_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY misc_gizmos
    ADD CONSTRAINT misc_gizmos_pkey PRIMARY KEY (id);


--
-- Name: modem_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY modem_cards
    ADD CONSTRAINT modem_cards_pkey PRIMARY KEY (id);


--
-- Name: modems_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY modems
    ADD CONSTRAINT modems_pkey PRIMARY KEY (id);


--
-- Name: monitors_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY monitors
    ADD CONSTRAINT monitors_pkey PRIMARY KEY (id);


--
-- Name: network_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY network_cards
    ADD CONSTRAINT network_cards_pkey PRIMARY KEY (id);


--
-- Name: networking_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY networking_devices
    ADD CONSTRAINT networking_devices_pkey PRIMARY KEY (id);


--
-- Name: pointing_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY pointing_devices
    ADD CONSTRAINT pointing_devices_pkey PRIMARY KEY (id);


--
-- Name: power_supplies_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY power_supplies
    ADD CONSTRAINT power_supplies_pkey PRIMARY KEY (id);


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
-- Name: scanners_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY scanners
    ADD CONSTRAINT scanners_pkey PRIMARY KEY (id);


--
-- Name: scsi_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY scsi_cards
    ADD CONSTRAINT scsi_cards_pkey PRIMARY KEY (id);


--
-- Name: scsi_hard_drives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY scsi_hard_drives
    ADD CONSTRAINT scsi_hard_drives_pkey PRIMARY KEY (id);


--
-- Name: sound_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY sound_cards
    ADD CONSTRAINT sound_cards_pkey PRIMARY KEY (id);


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
-- Name: system_boards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY system_boards
    ADD CONSTRAINT system_boards_pkey PRIMARY KEY (id);


--
-- Name: system_cases_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY system_cases
    ADD CONSTRAINT system_cases_pkey PRIMARY KEY (id);


--
-- Name: systems_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY systems
    ADD CONSTRAINT systems_pkey PRIMARY KEY (id);


--
-- Name: tape_drives_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY tape_drives
    ADD CONSTRAINT tape_drives_pkey PRIMARY KEY (id);


--
-- Name: upses_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY upses
    ADD CONSTRAINT upses_pkey PRIMARY KEY (id);


--
-- Name: vcrs_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY vcrs
    ADD CONSTRAINT vcrs_pkey PRIMARY KEY (id);


--
-- Name: video_cards_pkey; Type: CONSTRAINT; Schema: public; Owner: stillflame; Tablespace: 
--

ALTER TABLE ONLY video_cards
    ADD CONSTRAINT video_cards_pkey PRIMARY KEY (id);


--
-- Name: RI_ConstraintTrigger_60489; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER components_gizmo_fk
    AFTER INSERT OR UPDATE ON components
    FROM gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('components_gizmo_fk', 'components', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60490; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER components_gizmos_fk
    AFTER DELETE ON gizmos
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('components_gizmos_fk', 'components', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60491; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER components_gizmos_fk
    AFTER UPDATE ON gizmos
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('components_gizmos_fk', 'components', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60492; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER cards_components_fk
    AFTER INSERT OR UPDATE ON cards
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('cards_components_fk', 'cards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60493; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER cards_components_fk
    AFTER DELETE ON components
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('cards_components_fk', 'cards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60494; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER cards_components_fk
    AFTER UPDATE ON components
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('cards_components_fk', 'cards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60495; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_cards_cards_fk
    AFTER INSERT OR UPDATE ON misc_cards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('misc_cards_cards_fk', 'misc_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60496; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_cards_cards_fk
    AFTER DELETE ON cards
    FROM misc_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('misc_cards_cards_fk', 'misc_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60497; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_cards_cards_fk
    AFTER UPDATE ON cards
    FROM misc_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('misc_cards_cards_fk', 'misc_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60498; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modem_cards_cards_fk
    AFTER INSERT OR UPDATE ON modem_cards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('modem_cards_cards_fk', 'modem_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60499; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modem_cards_cards_fk
    AFTER DELETE ON cards
    FROM modem_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('modem_cards_cards_fk', 'modem_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60500; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modem_cards_cards_fk
    AFTER UPDATE ON cards
    FROM modem_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('modem_cards_cards_fk', 'modem_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60501; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER network_cards_cards_fk
    AFTER INSERT OR UPDATE ON network_cards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('network_cards_cards_fk', 'network_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60502; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER network_cards_cards_fk
    AFTER DELETE ON cards
    FROM network_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('network_cards_cards_fk', 'network_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60503; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER network_cards_cards_fk
    AFTER UPDATE ON cards
    FROM network_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('network_cards_cards_fk', 'network_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60504; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsi_cards_cards_fk
    AFTER INSERT OR UPDATE ON scsi_cards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('scsi_cards_cards_fk', 'scsi_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60505; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsi_cards_cards_fk
    AFTER DELETE ON cards
    FROM scsi_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('scsi_cards_cards_fk', 'scsi_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60506; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsi_cards_cards_fk
    AFTER UPDATE ON cards
    FROM scsi_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('scsi_cards_cards_fk', 'scsi_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60507; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER sound_cards_cards_fk
    AFTER INSERT OR UPDATE ON sound_cards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('sound_cards_cards_fk', 'sound_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60508; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER sound_cards_cards_fk
    AFTER DELETE ON cards
    FROM sound_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('sound_cards_cards_fk', 'sound_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60509; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER sound_cards_cards_fk
    AFTER UPDATE ON cards
    FROM sound_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('sound_cards_cards_fk', 'sound_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60510; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER video_cards_cards_fk
    AFTER INSERT OR UPDATE ON video_cards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('video_cards_cards_fk', 'video_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60511; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER video_cards_cards_fk
    AFTER DELETE ON cards
    FROM video_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('video_cards_cards_fk', 'video_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60512; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER video_cards_cards_fk
    AFTER UPDATE ON cards
    FROM video_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('video_cards_cards_fk', 'video_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60513; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER controller_cards_cards_fk
    AFTER INSERT OR UPDATE ON controller_cards
    FROM cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('controller_cards_cards_fk', 'controller_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60514; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER controller_cards_cards_fk
    AFTER DELETE ON cards
    FROM controller_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('controller_cards_cards_fk', 'controller_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60515; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER controller_cards_cards_fk
    AFTER UPDATE ON cards
    FROM controller_cards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('controller_cards_cards_fk', 'controller_cards', 'cards', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60516; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER drives_gizmos_fk
    AFTER INSERT OR UPDATE ON drives
    FROM gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('drives_gizmos_fk', 'drives', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60517; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER drives_gizmos_fk
    AFTER DELETE ON gizmos
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('drives_gizmos_fk', 'drives', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60518; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER drives_gizmos_fk
    AFTER UPDATE ON gizmos
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('drives_gizmos_fk', 'drives', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60519; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER floppy_drives_drives_fk
    AFTER INSERT OR UPDATE ON floppy_drives
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('floppy_drives_drives_fk', 'floppy_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60520; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER floppy_drives_drives_fk
    AFTER DELETE ON drives
    FROM floppy_drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('floppy_drives_drives_fk', 'floppy_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60521; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER floppy_drives_drives_fk
    AFTER UPDATE ON drives
    FROM floppy_drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('floppy_drives_drives_fk', 'floppy_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60522; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER ide_hard_drives_drives_fk
    AFTER INSERT OR UPDATE ON ide_hard_drives
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('ide_hard_drives_drives_fk', 'ide_hard_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60523; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER ide_hard_drives_drives_fk
    AFTER DELETE ON drives
    FROM ide_hard_drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('ide_hard_drives_drives_fk', 'ide_hard_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60524; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER ide_hard_drives_drives_fk
    AFTER UPDATE ON drives
    FROM ide_hard_drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('ide_hard_drives_drives_fk', 'ide_hard_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60525; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_drives_drives_fk
    AFTER INSERT OR UPDATE ON misc_drives
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('misc_drives_drives_fk', 'misc_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60526; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_drives_drives_fk
    AFTER DELETE ON drives
    FROM misc_drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('misc_drives_drives_fk', 'misc_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60527; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_drives_drives_fk
    AFTER UPDATE ON drives
    FROM misc_drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('misc_drives_drives_fk', 'misc_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60528; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsi_hard_drives_drives_fk
    AFTER INSERT OR UPDATE ON scsi_hard_drives
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('scsi_hard_drives_drives_fk', 'scsi_hard_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60529; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsi_hard_drives_drives_fk
    AFTER DELETE ON drives
    FROM scsi_hard_drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('scsi_hard_drives_drives_fk', 'scsi_hard_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60530; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scsi_hard_drives_drives_fk
    AFTER UPDATE ON drives
    FROM scsi_hard_drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('scsi_hard_drives_drives_fk', 'scsi_hard_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60531; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER tape_drives_drives_fk
    AFTER INSERT OR UPDATE ON tape_drives
    FROM drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('tape_drives_drives_fk', 'tape_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60532; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER tape_drives_drives_fk
    AFTER DELETE ON drives
    FROM tape_drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('tape_drives_drives_fk', 'tape_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60533; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER tape_drives_drives_fk
    AFTER UPDATE ON drives
    FROM tape_drives
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('tape_drives_drives_fk', 'tape_drives', 'drives', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60534; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER keyboards_components_fk
    AFTER INSERT OR UPDATE ON keyboards
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('keyboards_components_fk', 'keyboards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60535; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER keyboards_components_fk
    AFTER DELETE ON components
    FROM keyboards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('keyboards_components_fk', 'keyboards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60536; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER keyboards_components_fk
    AFTER UPDATE ON components
    FROM keyboards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('keyboards_components_fk', 'keyboards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60537; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_components_components_fk
    AFTER INSERT OR UPDATE ON misc_components
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('misc_components_components_fk', 'misc_components', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60538; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_components_components_fk
    AFTER DELETE ON components
    FROM misc_components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('misc_components_components_fk', 'misc_components', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60539; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_components_components_fk
    AFTER UPDATE ON components
    FROM misc_components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('misc_components_components_fk', 'misc_components', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60540; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modems_components_fk
    AFTER INSERT OR UPDATE ON modems
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('modems_components_fk', 'modems', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60541; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modems_components_fk
    AFTER DELETE ON components
    FROM modems
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('modems_components_fk', 'modems', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60542; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER modems_components_fk
    AFTER UPDATE ON components
    FROM modems
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('modems_components_fk', 'modems', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60543; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER monitors_components_fk
    AFTER INSERT OR UPDATE ON monitors
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('monitors_components_fk', 'monitors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60544; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER monitors_components_fk
    AFTER DELETE ON components
    FROM monitors
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('monitors_components_fk', 'monitors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60545; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER monitors_components_fk
    AFTER UPDATE ON components
    FROM monitors
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('monitors_components_fk', 'monitors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60546; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER pointing_devices_components_fk
    AFTER INSERT OR UPDATE ON pointing_devices
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('pointing_devices_components_fk', 'pointing_devices', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60547; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER pointing_devices_components_fk
    AFTER DELETE ON components
    FROM pointing_devices
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('pointing_devices_components_fk', 'pointing_devices', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60548; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER pointing_devices_components_fk
    AFTER UPDATE ON components
    FROM pointing_devices
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('pointing_devices_components_fk', 'pointing_devices', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60549; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER power_supplies_components_fk
    AFTER INSERT OR UPDATE ON power_supplies
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('power_supplies_components_fk', 'power_supplies', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60550; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER power_supplies_components_fk
    AFTER DELETE ON components
    FROM power_supplies
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('power_supplies_components_fk', 'power_supplies', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60551; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER power_supplies_components_fk
    AFTER UPDATE ON components
    FROM power_supplies
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('power_supplies_components_fk', 'power_supplies', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60552; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER printers_components_fk
    AFTER INSERT OR UPDATE ON printers
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('printers_components_fk', 'printers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60553; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER printers_components_fk
    AFTER DELETE ON components
    FROM printers
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('printers_components_fk', 'printers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60554; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER printers_components_fk
    AFTER UPDATE ON components
    FROM printers
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('printers_components_fk', 'printers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60555; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER processors_components_fk
    AFTER INSERT OR UPDATE ON processors
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('processors_components_fk', 'processors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60556; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER processors_components_fk
    AFTER DELETE ON components
    FROM processors
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('processors_components_fk', 'processors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60557; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER processors_components_fk
    AFTER UPDATE ON components
    FROM processors
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('processors_components_fk', 'processors', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60558; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scanners_components_fk
    AFTER INSERT OR UPDATE ON scanners
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('scanners_components_fk', 'scanners', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60559; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scanners_components_fk
    AFTER DELETE ON components
    FROM scanners
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('scanners_components_fk', 'scanners', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60560; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER scanners_components_fk
    AFTER UPDATE ON components
    FROM scanners
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('scanners_components_fk', 'scanners', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60561; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER speakers_components_fk
    AFTER INSERT OR UPDATE ON speakers
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('speakers_components_fk', 'speakers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60562; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER speakers_components_fk
    AFTER DELETE ON components
    FROM speakers
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('speakers_components_fk', 'speakers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60563; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER speakers_components_fk
    AFTER UPDATE ON components
    FROM speakers
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('speakers_components_fk', 'speakers', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60564; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER system_boards_components_fk
    AFTER INSERT OR UPDATE ON system_boards
    FROM components
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('system_boards_components_fk', 'system_boards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60565; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER system_boards_components_fk
    AFTER DELETE ON components
    FROM system_boards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('system_boards_components_fk', 'system_boards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60566; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER system_boards_components_fk
    AFTER UPDATE ON components
    FROM system_boards
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('system_boards_components_fk', 'system_boards', 'components', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60567; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_gizmos_gizmos_fk
    AFTER INSERT OR UPDATE ON misc_gizmos
    FROM gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('misc_gizmos_gizmos_fk', 'misc_gizmos', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60568; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_gizmos_gizmos_fk
    AFTER DELETE ON gizmos
    FROM misc_gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('misc_gizmos_gizmos_fk', 'misc_gizmos', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60569; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER misc_gizmos_gizmos_fk
    AFTER UPDATE ON gizmos
    FROM misc_gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('misc_gizmos_gizmos_fk', 'misc_gizmos', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60570; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systems_gizmos_fk
    AFTER INSERT OR UPDATE ON systems
    FROM gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('systems_gizmos_fk', 'systems', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60571; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systems_gizmos_fk
    AFTER DELETE ON gizmos
    FROM systems
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('systems_gizmos_fk', 'systems', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60572; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER systems_gizmos_fk
    AFTER UPDATE ON gizmos
    FROM systems
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('systems_gizmos_fk', 'systems', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60573; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER system_cases_gizmos_fk
    AFTER INSERT OR UPDATE ON system_cases
    FROM gizmos
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_check_ins"('system_cases_gizmos_fk', 'system_cases', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60574; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER system_cases_gizmos_fk
    AFTER DELETE ON gizmos
    FROM system_cases
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_del"('system_cases_gizmos_fk', 'system_cases', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: RI_ConstraintTrigger_60575; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE CONSTRAINT TRIGGER system_cases_gizmos_fk
    AFTER UPDATE ON gizmos
    FROM system_cases
    NOT DEFERRABLE INITIALLY IMMEDIATE
    FOR EACH ROW
    EXECUTE PROCEDURE "RI_FKey_noaction_upd"('system_cases_gizmos_fk', 'system_cases', 'gizmos', 'UNSPECIFIED', 'id', 'id');


--
-- Name: gizmo_clones_created_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER gizmo_clones_created_trigger
    BEFORE INSERT ON gizmo_clones
    FOR EACH ROW
    EXECUTE PROCEDURE created_trigger();


--
-- Name: gizmo_clones_modified_trigger; Type: TRIGGER; Schema: public; Owner: stillflame
--

CREATE TRIGGER gizmo_clones_modified_trigger
    BEFORE UPDATE ON gizmo_clones
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
-- Name: cards_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY cards
    ADD CONSTRAINT cards_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: cd_drives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY cd_drives
    ADD CONSTRAINT cd_drives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: components_gizmos_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY components
    ADD CONSTRAINT components_gizmos_fk FOREIGN KEY (id) REFERENCES gizmos(id);


--
-- Name: controller_cards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY controller_cards
    ADD CONSTRAINT controller_cards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: drives_gizmos_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY drives
    ADD CONSTRAINT drives_gizmos_fk FOREIGN KEY (id) REFERENCES gizmos(id);


--
-- Name: floppy_drives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY floppy_drives
    ADD CONSTRAINT floppy_drives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: gizmos_gizmo_statuses_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY gizmos
    ADD CONSTRAINT gizmos_gizmo_statuses_fk FOREIGN KEY (gizmo_status_id) REFERENCES gizmo_statuses(id);


--
-- Name: ide_hard_drives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY ide_hard_drives
    ADD CONSTRAINT ide_hard_drives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: keyboards_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY keyboards
    ADD CONSTRAINT keyboards_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: misc_cards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY misc_cards
    ADD CONSTRAINT misc_cards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: misc_components_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY misc_components
    ADD CONSTRAINT misc_components_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: misc_drives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY misc_drives
    ADD CONSTRAINT misc_drives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: misc_gizmos_gizmos_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY misc_gizmos
    ADD CONSTRAINT misc_gizmos_gizmos_fk FOREIGN KEY (id) REFERENCES gizmos(id);


--
-- Name: modem_cards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY modem_cards
    ADD CONSTRAINT modem_cards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: modems_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY modems
    ADD CONSTRAINT modems_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: monitors_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY monitors
    ADD CONSTRAINT monitors_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: network_cards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY network_cards
    ADD CONSTRAINT network_cards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: pointing_devices_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY pointing_devices
    ADD CONSTRAINT pointing_devices_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: power_supplies_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY power_supplies
    ADD CONSTRAINT power_supplies_components_fk FOREIGN KEY (id) REFERENCES components(id);


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
-- Name: scsi_cards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY scsi_cards
    ADD CONSTRAINT scsi_cards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: scsi_hard_drives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY scsi_hard_drives
    ADD CONSTRAINT scsi_hard_drives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: sound_cards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY sound_cards
    ADD CONSTRAINT sound_cards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- Name: speakers_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY speakers
    ADD CONSTRAINT speakers_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: system_boards_components_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY system_boards
    ADD CONSTRAINT system_boards_components_fk FOREIGN KEY (id) REFERENCES components(id);


--
-- Name: system_cases_gizmos_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY system_cases
    ADD CONSTRAINT system_cases_gizmos_fk FOREIGN KEY (id) REFERENCES gizmos(id);


--
-- Name: systems_gizmos_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY systems
    ADD CONSTRAINT systems_gizmos_fk FOREIGN KEY (id) REFERENCES gizmos(id);


--
-- Name: tape_drives_drives_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY tape_drives
    ADD CONSTRAINT tape_drives_drives_fk FOREIGN KEY (id) REFERENCES drives(id);


--
-- Name: video_cards_cards_fk; Type: FK CONSTRAINT; Schema: public; Owner: stillflame
--

ALTER TABLE ONLY video_cards
    ADD CONSTRAINT video_cards_cards_fk FOREIGN KEY (id) REFERENCES cards(id);


--
-- PostgreSQL database dump complete
--

