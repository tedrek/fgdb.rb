CREATE TABLE grants (
    id serial NOT NULL,
    contact_id integer,
    comments text,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);

CREATE TABLE recyclings (
    id serial NOT NULL,
    contact_id integer,
    comments text,
    lock_version integer DEFAULT 0 NOT NULL,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    created_by bigint DEFAULT 1 NOT NULL,
    updated_by bigint DEFAULT 1 NOT NULL
);

ALTER TABLE ONLY grants
    ADD CONSTRAINT pk_grants PRIMARY KEY (id);

ALTER TABLE ONLY recyclings
    ADD CONSTRAINT pk_recyclings PRIMARY KEY (id);

