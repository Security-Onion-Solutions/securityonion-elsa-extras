use syslog;

/*  Create bro_kerberos class */
INSERT IGNORE INTO classes (id, class) VALUES (26014, "BRO_KERBEROS");

/* add new fields that don't already exist in fields table */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("request_type","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("success","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("error_msg","string", "QSTRING");

/* integers i0 through i5 are field order 5 through 10 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_KERBEROS"), (SELECT id FROM fields WHERE field="srcip"), 5);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_KERBEROS"), (SELECT id FROM fields WHERE field="srcport"), 6);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_KERBEROS"), (SELECT id FROM fields WHERE field="dstip"), 7);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_KERBEROS"), (SELECT id FROM fields WHERE field="dstport"), 8);

/* strings s0 through s5 are field order 11 through 16 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_KERBEROS"), (SELECT id FROM fields WHERE field="request_type"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_KERBEROS"), (SELECT id FROM fields WHERE field="client"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_KERBEROS"), (SELECT id FROM fields WHERE field="service"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_KERBEROS"), (SELECT id FROM fields WHERE field="success"), 14);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_KERBEROS"), (SELECT id FROM fields WHERE field="error_msg"), 15);
