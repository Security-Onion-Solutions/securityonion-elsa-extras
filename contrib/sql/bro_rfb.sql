use syslog;

/*  Create bro_rfb class */
INSERT IGNORE INTO classes (id, class) VALUES (26020, "BRO_RFB");

/* add new integers that don't already exist in fields table */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("width","int", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("height","int", "QSTRING");

/* add new strings that don't already exist in fields table */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("client_major_version","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("client_minor_version","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("server_major_version","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("server_minor_version","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("authentication_method","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("desktop_name","string", "QSTRING");

/* integers i0 through i5 are field order 5 through 10 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="srcip"), 5);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="srcport"), 6);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="dstip"), 7);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="dstport"), 8);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="width"), 9);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="height"), 10);

/* strings s0 through s5 are field order 11 through 16 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="client_major_version"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="client_minor_version"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="server_major_version"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="server_minor_version"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="authentication_method"), 15);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RFB"), (SELECT id FROM fields WHERE field="desktop_name"), 16);
