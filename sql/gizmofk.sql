
alter table component add constraint component_gizmo_fk foreign key (id) references gizmo (id);

alter table card add constraint card_component_fk foreign key (id) references component (id);

alter table misccard add constraint misccard_card_fk foreign key (id) references card (id);

alter table modemcard add constraint modemcard_card_fk foreign key (id) references card (id);

alter table networkcard add constraint networkcard_card_fk foreign key (id) references card (id);

alter table scsicard add constraint scsicard_card_fk foreign key (id) references card (id);

alter table soundcard add constraint soundcard_card_fk foreign key (id) references card (id);

alter table videocard add constraint videocard_card_fk foreign key (id) references card (id);

alter table controllercard add constraint controllercard_card_fk foreign key (id) references card (id);


alter table drive add constraint drive_gizmo_fk foreign key (id) references gizmo (id);

alter table cddrive add constraint cddrive_drive_fk foreign key (id) references drive (id);

alter table floppydrive add constraint floppydrive_drive_fk foreign key (id) references drive (id);

alter table ideharddrive add constraint ideharddrive_drive_fk foreign key (id) references drive (id);

alter table miscdrive add constraint miscdrive_drive_fk foreign key (id) references drive (id);

alter table scsiharddrive add constraint scsiharddrive_drive_fk foreign key (id) references drive (id);

alter table tapedrive add constraint tapedrive_drive_fk foreign key (id) references drive (id);


alter table keyboard add constraint keyboard_component_fk foreign key (id) references component (id);

alter table misccomponent add constraint misccompponent_component_fk foreign key (id) references component (id);

alter table modem add constraint modem_component_fk foreign key (id) references component (id);

alter table monitor add constraint monitor_component_fk foreign key (id) references component (id);

alter table pointingdevice add constraint pointingdevice_component_fk foreign key (id) references component (id);

alter table powersupply add constraint powersupply_component_fk foreign key (id) references component (id);

alter table printer add constraint printer_component_fk foreign key (id) references component (id);

alter table processor add constraint processor_component_fk foreign key (id) references component (id);

alter table scanner add constraint scanner_component_fk foreign key (id) references component (id);

alter table speaker add constraint speaker_component_fk foreign key (id) references component (id);

alter table systemboard add constraint systemboard_component_fk foreign key (id) references component (id);



alter table miscgizmo add constraint miscgizmo_gizmo_fk foreign key (id) references gizmo (id);

alter table system add constraint system_gizmo_fk foreign key (id) references gizmo (id);

alter table systemcase add constraint systemcase_gizmo_fk foreign key (id) references gizmo (id);

