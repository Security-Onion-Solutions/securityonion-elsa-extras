use syslog;

/*  Create bro_rdp class */
INSERT IGNORE INTO classes (id, class) VALUES (26015, "BRO_RDP");

/* add new integers that don't already exist in fields table */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("desktop_width","int", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("desktop_height","int", "QSTRING");

/* add new strings that don't already exist in fields table */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("security_protocol","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("keyboard_layout","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("client_build","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("client_name","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("encryption_level","string", "QSTRING");

/* integers i0 through i5 are field order 5 through 10 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="srcip"), 5);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="srcport"), 6);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="dstip"), 7);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="dstport"), 8);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="desktop_width"), 9);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="desktop_height"), 10);

/* strings s0 through s5 are field order 11 through 16 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="result"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="security_protocol"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="keyboard_layout"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="client_build"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="client_name"), 15);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_RDP"), (SELECT id FROM fields WHERE field="encryption_level"), 16);
