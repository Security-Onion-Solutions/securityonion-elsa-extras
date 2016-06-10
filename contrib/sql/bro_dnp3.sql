use syslog;

/*  Create BRO_DNP3 class */
INSERT IGNORE INTO classes (id, class) VALUES (26019, "BRO_DNP3");

/* add new integers that don't already exist in fields table */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("iin","int", "QSTRING");  

/* add new strings that don't already exist in fields table */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("fc_request","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("fc_reply","string", "QSTRING");

/* integers i0 through i5 are field order 5 through 10 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNP3"), (SELECT id FROM fields WHERE field="srcip"), 5);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNP3"), (SELECT id FROM fields WHERE field="srcport"), 6);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNP3"), (SELECT id FROM fields WHERE field="dstip"), 7);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNP3"), (SELECT id FROM fields WHERE field="dstport"), 8);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNP3"), (SELECT id FROM fields WHERE field="iin"), 9);

/* strings s0 through s5 are field order 11 through 16 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNP3"), (SELECT id FROM fields WHERE field="fc_request"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_DNP3"), (SELECT id FROM fields WHERE field="fc_reply"), 12);
