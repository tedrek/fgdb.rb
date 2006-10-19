-- Tables (and table modifications) for selling items

-- change set 18oct06
-- replace class-level attributes in gizmo_types table
-- switch from fee, fee_is_required to two fee amount attributes
alter table gizmo_types
  add COLUMN required_fee      numeric(10,2) default 0.0;
alter table gizmo_types
  add COLUMN suggested_fee     numeric(10,2) default 0.0;
alter table gizmo_types
  add COLUMN discounts_apply   boolean  default true not null;

---- change set 18oct06
---- gizmo_actions deemed superfluous; using gizmo_contexts instead
--DROP TABLE gizmo_actions;
--
---- The old "gizmo_attrs" table name was chosen to minimize
---- length of rails-conventional bridge table names
---- It was really a bridge table from the old "gizmo_attr_types" to
---- gizmo_types, now renamed to better reflect that yet still be
---- short
--alter table gizmo_attrs         RENAME TO gizmo_typeattrs;
--alter table gizmo_typeattrs
--  RENAME COLUMN gizmo_attr_type_id TO gizmo_attr_id;
--
--alter table gizmo_attrs_gizmo_contexts
--  RENAME TO gizmo_typeattrs_gizmo_contexts;
--alter table gizmo_typeattrs_gizmo_contexts
--  RENAME COLUMN gizmo_attr_type_id TO gizmo_typeattr_id;
--
--alter table gizmo_attrs_gizmo_events
--  RENAME TO gizmo_typeattrs_gizmo_events;
--alter table gizmo_typeattrs_gizmo_events
--  RENAME COLUMN gizmo_attr_type_id TO gizmo_typeattr_id;
--
--alter table gizmo_attr_types    RENAME TO gizmo_attrs;
---- the following values will be entered via rails maint screens
----INSERT INTO gizmo_attrs (name,datatype) 
----  VALUES ('Unit Price','monetary');
----  VALUES ('Extended Price','monetary');
----  VALUES ('Discount Applied','monetary');
----  VALUES ('Sale Txn Amount','monetary');
----  VALUES ('Standard Extended Discount','monetary');
----  VALUES ('Is Custom Discount?','boolean');
----  VALUES ('Required Fee','monetary');
----  VALUES ('Suggested Fee','monetary');
----  VALUES ('Fee Is Required?','boolean');
----  VALUES ('Discountable?','boolean');
--
--alter table gizmo_types
--  DROP COLUMN fee;
--alter table gizmo_types
--  DROP COLUMN fee_is_required;
--alter table gizmo_types
--  DROP COLUMN discounts_apply;
--
--alter table gizmo_events
--  RENAME COLUMN gizmo_action_id   TO gizmo_context_id;
--alter table gizmo_events
--  DROP COLUMN unit_price;
--alter table gizmo_events
--  DROP COLUMN standard_extended_discount;
--alter table gizmo_events
--  DROP COLUMN is_custom_discount;
--alter table gizmo_events
--  DROP COLUMN extended_price;
--alter table gizmo_events
--  DROP COLUMN discount_applied;
--alter table gizmo_events
--  DROP COLUMN sale_txn_amount;


-- change set 30sep06
--alter TABLE discount_schedules
--  rename column name to short_name;

-- change set 30sep06
--alter table sale_txns
--  drop column is_refund;
--alter table sale_txn_lines
--  drop column is_refund;
 

-- change set 29sep06
--alter table sale_txns
--  add column discount_schedule_id integer default 1 not null,
--  drop column tax_amount;
--alter table sale_txn_lines
--  drop column taxable,
--  drop column tax_applied;
--alter table sale_txn_lines
--  rename column base_price to unit_price;
--alter table forsale_items
--  drop column taxable;
--
--CREATE TABLE discount_schedules (
--    id serial NOT NULL,
--    name character varying(25),
--    donated_item_rate numeric(10,2) DEFAULT 0,
--    resale_item_rate numeric(10,2) DEFAULT 0,
--    description character varying(100),
--    lock_version integer DEFAULT 0 NOT NULL,
--    updated_at timestamp with time zone DEFAULT now(),
--    created_at timestamp with time zone DEFAULT now(),
--    created_by bigint DEFAULT 1 NOT NULL,
--    updated_by bigint DEFAULT 1 NOT NULL
--);
--
--COMMENT ON TABLE discount_schedules IS 'discount schedules and their discount percents';


-- first pass

--CREATE TABLE source_types (
--    id serial NOT NULL,
--    description character varying(100),
--    lock_version integer DEFAULT 0 NOT NULL,
--    updated_at timestamp with time zone DEFAULT now(),
--    created_at timestamp with time zone DEFAULT now(),
--    created_by bigint DEFAULT 1 NOT NULL,
--    updated_by bigint DEFAULT 1 NOT NULL
--);
--
--COMMENT ON TABLE source_types IS 'sources of items for sale: store, other';
--
--CREATE TABLE forsale_items (
--    id serial NOT NULL,
--    source_type_id integer,
--    description character varying(100) not null,
--    price numeric(10,2) DEFAULT 9.99,
--    onhand_qty integer,
--    taxable boolean DEFAULT false not null,
--    lock_version integer DEFAULT 0 NOT NULL,
--    updated_at timestamp with time zone DEFAULT now(),
--    created_at timestamp with time zone DEFAULT now(),
--    created_by bigint DEFAULT 1 NOT NULL,
--    updated_by bigint DEFAULT 1 NOT NULL
--);
--COMMENT ON TABLE forsale_items IS 'items for sale; not intended as inventory';
--
--create table till_handlers (
--    id serial NOT NULL,
--    description character varying(100) not null,
--    contact_id integer NOT NULL,
--    can_alter_price boolean default false not null,
--    lock_version integer DEFAULT 0 NOT NULL,
--    updated_at timestamp with time zone DEFAULT now(),
--    created_at timestamp with time zone DEFAULT now(),
--    created_by bigint DEFAULT 1 NOT NULL,
--    updated_by bigint DEFAULT 1 NOT NULL
--);
--COMMENT ON TABLE till_handlers IS 'identifies those who operate the till';
--
--create table sale_txns (
--    id serial NOT NULL,
--    description character varying(100) not null,
--    contact_id integer NOT NULL,
--    till_handler_id integer NOT NULL,
--    payment_method_id integer NOT NULL,
--    gross_amount numeric(10,2) not null,
--    discount_amount numeric(10,2),
--    tax_amount numeric(10,2),
--    amount_due numeric(10,2) not null,
--    is_refund boolean,
--    comments character varying(100) not null,
--    lock_version integer DEFAULT 0 NOT NULL,
--    updated_at timestamp with time zone DEFAULT now(),
--    created_at timestamp with time zone DEFAULT now(),
--    created_by bigint DEFAULT 1 NOT NULL,
--    updated_by bigint DEFAULT 1 NOT NULL
--);
--COMMENT ON TABLE sale_txns IS 'each record represents one sales transaction';
--
--create table sale_txn_lines (
--    id serial NOT NULL,
--    sale_txn_id integer NOT NULL,
--    forsale_item_id integer NOT NULL,
--    base_price numeric(10,2) not null,
--    quantity integer NOT NULL,
--    extended_price numeric(10,2) not null,
--    discount_applied numeric(10,2),
--    taxable boolean DEFAULT false not null,
--    tax_applied numeric(10,2),
--    sale_txn_amount numeric(10,2) not null,
--    is_refund boolean,
--    comments character varying(100) not null,
--    lock_version integer DEFAULT 0 NOT NULL,
--    updated_at timestamp with time zone DEFAULT now(),
--    created_at timestamp with time zone DEFAULT now(),
--    created_by bigint DEFAULT 1 NOT NULL,
--    updated_by bigint DEFAULT 1 NOT NULL
--);
--COMMENT ON TABLE sale_txn_lines IS 'one record is one detail line in a sales transaction';
