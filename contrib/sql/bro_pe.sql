use syslog;

/*  Create bro_pe class */
INSERT IGNORE INTO classes (id, class) VALUES (26016, "BRO_PE");

/* add new integers that don't already exist in fields table */
/* (no new integers for BRO_PE) */

/* add new strings that don't already exist in fields table */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("machine","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("os","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("subsystem","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("is_exe","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("is_64bit","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("section_names","string", "QSTRING");

/* integers i0 through i5 are field order 5 through 10 */
/* (no integers for BRO_PE) */

/* strings s0 through s5 are field order 11 through 16 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_PE"), (SELECT id FROM fields WHERE field="machine"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_PE"), (SELECT id FROM fields WHERE field="os"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_PE"), (SELECT id FROM fields WHERE field="subsystem"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_PE"), (SELECT id FROM fields WHERE field="is_exe"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_PE"), (SELECT id FROM fields WHERE field="is_64bit"), 15);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_PE"), (SELECT id FROM fields WHERE field="section_names"), 16);
