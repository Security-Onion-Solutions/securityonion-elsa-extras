use syslog;

/*  Create BRO_SIP class */
INSERT IGNORE INTO classes (id, class) VALUES (26017, "BRO_SIP");

/* add new integers that don't already exist in fields table */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("trans_depth","int", "QSTRING");  

/* add new strings that don't already exist in fields table */
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("request_from","string", "QSTRING");  
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("request_to","string", "QSTRING");
INSERT IGNORE INTO fields (field, field_type, pattern_type) VALUES ("status_msg","string", "QSTRING");

/* integers i0 through i5 are field order 5 through 10 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SIP"), (SELECT id FROM fields WHERE field="srcip"), 5);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SIP"), (SELECT id FROM fields WHERE field="srcport"), 6);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SIP"), (SELECT id FROM fields WHERE field="dstip"), 7);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SIP"), (SELECT id FROM fields WHERE field="dstport"), 8);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SIP"), (SELECT id FROM fields WHERE field="trans_depth"), 9);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SIP"), (SELECT id FROM fields WHERE field="status_code"), 10);

/* strings s0 through s5 are field order 11 through 16 */
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SIP"), (SELECT id FROM fields WHERE field="method"), 11);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SIP"), (SELECT id FROM fields WHERE field="uri"), 12);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SIP"), (SELECT id FROM fields WHERE field="user_agent"), 13);
INSERT IGNORE INTO fields_classes_map (class_id, field_id, field_order) VALUES ((SELECT id FROM classes WHERE class="BRO_SIP"), (SELECT id FROM fields WHERE field="status_msg"), 14);
