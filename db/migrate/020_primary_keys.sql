ALTER TABLE ONLY discount_schedules
    ADD CONSTRAINT pk_discount_schedules PRIMARY KEY (id);

ALTER TABLE ONLY discount_schedules_gizmo_types
    ADD CONSTRAINT pk_discount_schedules_gizmo_types PRIMARY KEY (id);

ALTER TABLE ONLY donations
    ADD CONSTRAINT pk_donations PRIMARY KEY (id);

ALTER TABLE ONLY gizmo_attrs
    ADD CONSTRAINT pk_gizmo_attrs PRIMARY KEY (id);

ALTER TABLE ONLY gizmo_contexts
    ADD CONSTRAINT pk_gizmo_contexts PRIMARY KEY (id);

ALTER TABLE ONLY gizmo_events
    ADD CONSTRAINT pk_gizmo_events PRIMARY KEY (id);

ALTER TABLE ONLY gizmo_events_gizmo_typeattrs
    ADD CONSTRAINT pk_gizmo_events_gizmo_typeattrs PRIMARY KEY (id);

ALTER TABLE ONLY gizmo_typeattrs
    ADD CONSTRAINT pk_gizmo_typeattrs PRIMARY KEY (id);

ALTER TABLE ONLY gizmo_types
    ADD CONSTRAINT pk_gizmo_types PRIMARY KEY (id);

ALTER TABLE ONLY payment_methods
    ADD CONSTRAINT pk_payment_methods PRIMARY KEY (id);

ALTER TABLE ONLY sale_txns
    ADD CONSTRAINT pk_sale_txns PRIMARY KEY (id);

ALTER TABLE ONLY volunteer_task_types
    ADD CONSTRAINT pk_volunteer_task_types PRIMARY KEY (id);

ALTER TABLE ONLY volunteer_tasks
    ADD CONSTRAINT pk_volunteer_tasks PRIMARY KEY (id);

